---
title: Personnaliser le modèle
description: Remplacer l’identité et les exemples sans reconstruire le thème.
book_kind: chapter
book_number: 3
weight: 30
---

La plupart des projets n’exigent que du contenu et deux modifications de configuration.

## Modifier l’identité une seule fois {#identity}

Le titre du site et l'URL de base se trouvent en haut de `hugo.yaml` — une ancre YAML unique propage le nom dans les trois langues.

Ne remplacez `assets/icons/logo.svg` et `static/favicon.svg` que lorsque vous disposez d’une véritable identité visuelle.

## Remplacer l’accueil {#home}

Modifiez `data/home/en.yaml`, `zh.yaml` et `fr.yaml`. La liste `sections` fixe l’ordre ; les blocs nommés fournissent le texte.

## Remplacer les exemples {#content}

Gardez la structure des dossiers, puis réécrivez ou supprimez les pages d’exemple. Pour renommer une entrée principale, modifiez les fichiers `_index` traduits correspondants.

## Activer les intégrations volontairement {#integrations}

`hugo.yaml` propose des exemples commentés pour les liens du dépôt, Giscus, Google Analytics, les couleurs, la typographie, le partage et les retours. Ne décommentez qu’une configuration complète que vous comptez exploiter.
