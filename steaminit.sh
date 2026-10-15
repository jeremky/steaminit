#!/bin/bash

# Colored messages
error() { echo -e "\033[0;31m❯ $*\033[0m"; }
message() { echo -e "\033[0;36m──────────\033[0m\n\033[0;32m❯ $*\033[0m"; }
warning() { echo -e "\033[0;33m❯ $*\033[0m\n\033[0;36m──────────\033[0m"; }

# Functions
install_flatpaks() {
  if [[ -f "$apps" ]]; then
    warning "Installing flatpaks"
    grep -v -e '#' -e '^$' "$apps" | xargs -r flatpak install -y --user flathub || {
      error "Error while installing flatpaks"
      return 1
    }
    message "Flatpak installation complete"
    echo
  fi
}

install_geforcenow() {
  warning "Installing GeForce NOW"
  flatpak remote-add --user --if-not-exists GeForceNOW https://international.download.nvidia.com/GFNLinux/flatpak/geforcenow.flatpakrepo
  flatpak install -y --user flathub org.freedesktop.Platform/x86_64/24.08 || {
    error "Error while installing the Freedesktop platform"
    return 1
  }
  flatpak install -y --user GeForceNOW com.nvidia.geforcenow || {
    error "Error while installing GeForce NOW"
    return 1
  }
  message "GeForce NOW installation complete"
  echo
}

# Execution
dir="$(dirname "$0")/config"
cfg="$dir/config.cfg"
apps="$dir/flatpaks.cfg"
if [[ ! -f "$cfg" ]]; then
  error "File $cfg not found"
  exit 1
fi
echo
while read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  if declare -f "$line" >/dev/null; then
    "$line"
  else
    error "No function matches parameter $line"
    exit 1
  fi
done <"$cfg"
