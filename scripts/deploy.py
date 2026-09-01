#!/usr/bin/env python3
import os
import sys
import ssl
import ftplib
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
import threading

thread_local = threading.local()

def get_thread_ftp(host: str, user: str, passwd: str) -> ftplib.FTP_TLS:
    if not hasattr(thread_local, "ftp"):
        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE

        ftp = ftplib.FTP_TLS(context=ctx, timeout=30)
        ftp.encoding = "utf-8"
        ftp.connect(host, 21)
        if ftp.sock is not None:
            ftp.file = ftp.sock.makefile('r', encoding='utf-8', errors='surrogateescape')
        ftp.auth()
        if ftp.sock is not None:
            ftp.file = ftp.sock.makefile('r', encoding='utf-8', errors='surrogateescape')
        ftp.login(user, passwd)
        if ftp.sock is not None:
            ftp.file = ftp.sock.makefile('r', encoding='utf-8', errors='surrogateescape')
        ftp.prot_p()
        ftp.set_pasv(True)
        thread_local.ftp = ftp
    return thread_local.ftp

def upload_single_file(host: str, user: str, passwd: str, local_path: Path, remote_dir: str) -> bool:
    ftp = get_thread_ftp(host, user, passwd)
    filename = local_path.name
    
    clean_remote_dir = remote_dir if remote_dir else "/"
    try:
        ftp.cwd(clean_remote_dir)
    except ftplib.error_perm:
        parts = clean_remote_dir.strip("/").split("/")
        builder = ""
        for p in parts:
            if not p:
                continue
            builder += f"/{p}"
            try:
                ftp.mkd(builder)
            except ftplib.error_perm:
                pass
        ftp.cwd(clean_remote_dir)

    with open(local_path, "rb") as f:
        ftp.storbinary(f"STOR {filename}", f)
    return True

def deploy_to_target(host: str, user: str, passwd: str, local_dir: str, remote_dir: str, workers: int = 8) -> None:
    local_path = Path(local_dir)
    print(f"[*] Scanning local files in {local_path} for target {remote_dir}...")
    
    files_to_upload: list[tuple[Path, str]] = []
    for root, _, files in os.walk(local_path):
        rel = Path(root).relative_to(local_path)
        if rel == Path("."):
            rem_dir = remote_dir
        else:
            rem_dir = f"{remote_dir}/{rel.as_posix()}" if remote_dir != "/" else f"/{rel.as_posix()}"
        for f in files:
            files_to_upload.append((Path(root) / f, rem_dir))

    total = len(files_to_upload)
    print(f"[*] Deploying {total} files to {remote_dir} using {workers} parallel FTPS workers...")

    completed = 0
    with ThreadPoolExecutor(max_workers=workers) as executor:
        futures = {
            executor.submit(upload_single_file, host, user, passwd, lp, rd): lp
            for lp, rd in files_to_upload
        }
        for future in as_completed(futures):
            try:
                _ = future.result()
                completed += 1
            except Exception as e:
                f_path = futures[future]
                print(f"    [!] Error uploading {f_path}: {e}")

    print(f"[✓] Deployment to {remote_dir} complete! Synced {completed}/{total} files.")

def main() -> None:
    host = os.environ.get("FTP_HOST", "186.241.115.49")
    user = os.environ.get("FTP_USER")
    passwd = os.environ.get("FTP_PASS")
    local_dir = sys.argv[1] if len(sys.argv) > 1 else "./public"

    if not user or not passwd:
        print("[!] Missing FTP_USER or FTP_PASS environment variables.")
        sys.exit(1)

    print(f"[*] Connecting to FTPS server {host}...")
    # Deploy to both /public_html and / root
    deploy_to_target(host, user, passwd, local_dir, "/public_html", workers=8)
    deploy_to_target(host, user, passwd, local_dir, "/", workers=8)

if __name__ == "__main__":
    main()
