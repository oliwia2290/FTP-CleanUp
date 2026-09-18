#!/bin/bash

BASE="/u01/ftp/hasler/NEWAG_Griffin/Griffin"
LOGS="/root/ftp/NEWAG_Griffin"

for dir in "$BASE"/*/; do
   latest=$(find "$dir" -mindepth 1 -maxdepth 1 -type d \
      -name '20[0-9][0-9][0-9][0-9][0-9][0-9]' \
      -printf '%f\n' | sort -n | tail -1)

   [[ -z "$latest" ]] && continue

   target=$(date -d "$latest -12 months" +%Y%m%d)
   find "$dir" -mindepth 1 -maxdepth 1 -type d -name '20[0-9][0-9][0-9][0-9][0-9][0-9]' |
   while read -r folder; do
      if [[ "$(basename "$folder")" < "$target"  ]]; then
         echo "Deleting: $folder"
         rm -r -- "$folder" && echo "$folder" >> "$LOGS/deleted_$(date +%Y%m%d).log"
      fi
   done
done
