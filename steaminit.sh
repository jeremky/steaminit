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

configure_sshd() {
  if [[ ! -d /etc/ssh/sshd_config.d ]]; then
    error "SSH is not installed"
    return 1
  fi
  warning "Securing SSH"
  sudo tee "/etc/ssh/sshd_config.d/deck.conf" <<EOF
# Secure Config
X11Forwarding no
AllowUsers deck
HostKey /etc/ssh/ssh_host_ed25519_key
PasswordAuthentication no
KbdInteractiveAuthentication no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
KexAlgorithms mlkem768x25519-sha256,sntrup761x25519-sha512@openssh.com,curve25519-sha256
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
Ciphers aes256-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-gcm@openssh.com,aes128-ctr
EOF
  sudo systemctl enable --now sshd || {
    error "Error while starting SSH"
    exit 1
  }
  message "SSH secured"
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

if [[ -n "$1" ]]; then
  if declare -f "$1" >/dev/null; then
    "$1"
    exit 0
  else
    error "Function $1 not found"
    exit 1
  fi
fi

while read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  if declare -f "$line" >/dev/null; then
    "$line"
  else
    error "No function matches parameter $line"
    exit 1
  fi
done <"$cfg"
