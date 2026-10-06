# steaminit

SteamOS post-installation script.

## Features

- `install_flatpaks`: installs the applications listed in `config/flatpaks.cfg`
- `install_geforcenow`: adds the NVIDIA repository and installs GeForce NOW via
  Flathub

## Configuration

The `config/config.cfg` file lets you configure how the script runs to suit your
preferences. Comment out the functions you don't want to use. Example:

```txt
# steaminit config

install_flatpaks
install_geforcenow
```

## Usage

Once you've edited `config/config.cfg`, run the script:

```bash
./steaminit.sh
```
