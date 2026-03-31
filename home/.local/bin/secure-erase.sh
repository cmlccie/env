#!/bin/bash
# Secure-delete a file or folder on macOS (native tools only)

set -euo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 /full/path/to/file-or-folder"
  exit 1
fi

# Detect filesystem and encryption
VOLDEV=$(df "$TARGET" | tail -1 | awk '{print $1}')
FS_TYPE=$(diskutil info "$VOLDEV" 2>/dev/null | grep "File System Personality" | awk '{print $4}')
FILEVAULT=$(diskutil apfs list | grep -q "FileVault" && echo "yes" || echo "no")

# -------------------------------------------------
# Handle based on filesystem and encryption
if [[ "$FS_TYPE" == "APFS" ]]; then
  if [[ "$FILEVAULT" == "yes" ]]; then
    echo "🔒 FileVault enabled on APFS - using TRIM instead of overwriting."
    if [[ "$TARGET" == /* ]]; then
      # Get the volume path for TRIM
      VOLUME_PATH=$(echo "$TARGET" | cut -d'/' -f2)
      echo "Trim free space on APFS volume..."
      sudo trimforce enable || true
      sudo diskutil apfs trimDisk "/$VOLUME_PATH" 2>/dev/null || echo "TRIM not available, deleting normally"
    fi
    rm -rf "$TARGET"
  else
    echo "Deleting file(s) (APFS without FileVault - TRIM recommended)..."
    rm -rf "$TARGET"
  fi
else
  # HFS+ or other filesystems
  if [[ -d "$TARGET" ]]; then
    echo "Target is a directory - recursing manually."
    find "$TARGET" -type f -print0 | while IFS= read -r -d '' file; do
      echo "Overwriting $file"
      size=$(stat -f%z "$file" 2>/dev/null || echo "0")
      if [[ "$size" -gt 0 ]]; then
        dd if=/dev/zero of="$file" bs=1m count=$(( (size + 1048575) / 1048576 )) conv=notrunc status=none 2>/dev/null || true
      fi
    done
    rm -rf "$TARGET"
  else
    echo "Overwriting $TARGET then removing..."
    size=$(stat -f%z "$TARGET" 2>/dev/null || echo "0")
    if [[ "$size" -gt 0 ]]; then
      dd if=/dev/zero of="$TARGET" bs=1m count=$(( (size + 1048575) / 1048576 )) conv=notrunc status=none
    fi
    rm -f "$TARGET"
  fi
fi

# Free space wipe prompt (only for non-APFS or if user wants it)
if [[ "$FS_TYPE" != "APFS" ]]; then
  read -p "Free-space wipe on $VOLDEV? This may take a while. (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo diskutil secureErase freespace 1 "$VOLDEV"
  else
    echo "Skipping free-space wipe."
  fi
fi

echo "Done. The target has been deleted."
