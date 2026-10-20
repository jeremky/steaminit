# steaminit

SteamOS post-installation script.

## Features

- `install_flatpaks`: installs the applications listed in `config/flatpaks.cfg`
- `configure_sshd`: hardens access to the OpenSSH server

> [!IMPORTANT]
> `configure_sshd` writes its config to `/etc/ssh/sshd_config.d/<user>.conf`

## Configuration

The `config/config.cfg` file lets you configure how the script runs to suit your
preferences. Comment out the functions you don't want to use. Example:

```txt
# steaminit config

install_flatpaks
configure_sshd
```

## Usage

Once you've edited `config/config.cfg`, run the script:

```bash
./steaminit.sh
```
