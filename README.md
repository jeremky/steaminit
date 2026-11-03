# steaminit

SteamOS post-installation script.

## Features

- `init_passwd`: asks for change deck user password
- `install_flatpaks`: installs the applications listed in `config/flatpaks.cfg`
- `install_decky`: installs [Decky Loader](https://decky.xyz/)
- `configure_sshd`: hardens access to the OpenSSH server

> [!IMPORTANT]
> `configure_sshd` writes its config to `/etc/ssh/sshd_config.d/deck.conf`

## Configuration

The `config/config.cfg` file lets you configure how the script runs to suit your
preferences. Comment out the functions you don't want to use. Example:

```txt
# steaminit config

init_passwd
install_flatpaks
install_decky
configure_sshd
```

## Usage

Once you've edited `config/config.cfg`, run the script:

```bash
./steaminit.sh
```
