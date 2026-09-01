#!/usr/bin/env python3
import os
import sys
import ssl
import ftplib
from pathlib import Path

# Fix TLS session resumption for FTPS data connection
class SSLSessionReuseFTP(ftplib.FTP_TLS):
    def ntransfercmd(self, cmd, rest=None):
        conn, size = ftplib.FTP.ntransfercmd(self, cmd, rest)
        if self._cnx:
            conn = self.context.wrap_socket(
                conn,
                server_hostname=self.host,
                session=self.sock.session
            )
        return conn, size

def upload_directory(ftp, local_dir, remote_dir):
    local_path = Path(local_dir)
    print(f"[*] Starting upload from {local_path} to {remote_dir}")
    
    file_count = 0
    dir_count = 0

    for root, dirs, files in os.walk(local_path):
        rel_path = Path(root).relative_to(local_path)
        current_remote_dir = (Path(remote_dir) / rel_path).as_posix()
        
        # Ensure remote directory exists
        try:
            ftp.cwd(current_remote_dir)
        except ftplib.error_perm:
            # Create directories recursively
            parts = current_remote_dir.strip("/").split("/")
            path_builder = ""
            for part in parts:
                path_builder += f"/{part}"
                try:
                    ftp.mkd(path_builder)
                except ftplib.error_perm:
                    pass
            ftp.cwd(current_remote_dir)
            dir_count += 1

        # Upload files in this directory
        for filename in files:
            local_file = Path(root) / filename
            with open(local_file, "rb") as f:
                remote_cmd = f"STOR {filename}"
                ftp.storbinary(remote_cmd, f)
                file_count += 1
                if file_count % 10 == 0:
                    print(f"    [+] Uploaded {file_count} files...")

    print(f"[✓] Upload complete! Total files: {file_count}, directories created: {dir_count}")

def main():
    host = os.environ.get("FTP_HOST", "186.241.115.49")
    user = os.environ.get("FTP_USER")
    passwd = os.environ.get("FTP_PASS")
    local_dir = sys.argv[1] if len(sys.argv) > 1 else "./public"
    remote_dir = sys.argv[2] if len(sys.argv) > 2 else "/public_html"

    if not user or not passwd:
        print("[!] Missing FTP_USER or FTP_PASS environment variables.")
        sys.exit(1)

    print(f"[*] Connecting to FTPS server {host} as {user}...")
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    ftp = SSLSessionReuseFTP(context=ctx, timeout=30)
    ftp.connect(host, 21)
    print("    [+] Handshake connected. Authenticating...")
    ftp.auth()
    ftp.login(user, passwd)
    ftp.prot_p()  # Enforce encrypted data connection
    ftp.set_pasv(True)
    print("    [+] Authentication successful!")

    # Check remote root listing
    print("    [+] Remote root layout:")
    lines = []
    ftp.dir(lines.append)
    for l in lines[:5]:
        print(f"        {l}")

    upload_directory(ftp, local_dir, remote_dir)
    ftp.quit()

if __name__ == "__main__":
    main()
