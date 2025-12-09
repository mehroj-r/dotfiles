#!/bin/bash
#
# Full Cleanup Script for Flatpak, Snap, Pacman, and System Junk
#

echo "🧹 Starting full cleanup..."

### DISK USAGE BEFORE ###
echo "📊 Disk usage before cleanup:"
df -h /

### FLATPAK CLEANUP ###
if command -v flatpak &>/dev/null; then
  echo "👉 Cleaning Flatpak unused runtimes..."
  flatpak uninstall --unused -y

  echo "👉 Removing Flatpak cache files..."
  rm -rf ~/.var/app/*/cache/*
  rm -rf ~/.cache/flatpak

  echo "✅ Flatpak cleanup done."
else
  echo "⚠️ Flatpak not installed, skipping."
fi

### SNAP CLEANUP ###
if command -v snap &>/dev/null; then
  echo "👉 Removing old/disabled Snap revisions..."
  snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
    sudo snap remove "$snapname" --revision="$revision"
  done

  echo "👉 Cleaning Snap cache..."
  sudo rm -rf /var/lib/snapd/cache/*

  echo "✅ Snap cleanup done."
else
  echo "⚠️ Snap not installed, skipping."
fi

### PACMAN CLEANUP ###
if command -v pacman &>/dev/null; then
  echo "👉 Cleaning Pacman cache (keeping last 2 versions)..."
  sudo paccache -r -k2

  echo "👉 Removing unused packages..."
  sudo pacman -Rns $(pacman -Qdtq) --noconfirm 2>/dev/null || echo "No unused packages found."

  echo "✅ Pacman cleanup done."
else
  echo "⚠️ Pacman not installed, skipping."
fi

### TRASH CLEANUP ###
echo "👉 Emptying user trash..."
rm -rf ~/.local/share/Trash/*

if [ "$EUID" -eq 0 ]; then
  echo "👉 Emptying system-wide trash..."
  rm -rf /root/.local/share/Trash/*
  rm -rf /tmp/*
fi

### TEMP CLEANUP ###
echo "👉 Cleaning temporary files..."
rm -rf /tmp/*
rm -rf /var/tmp/*

### JOURNALD LOGS CLEANUP ###
if command -v journalctl &>/dev/null; then
  echo "👉 Vacuuming old system logs (keep 7 days)..."
  sudo journalctl --vacuum-time=7d
fi

### DISK USAGE AFTER ###
echo "📊 Disk usage after cleanup:"
df -h /

echo "🎉 Cleanup finished!"
