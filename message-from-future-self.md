# A message from your future self

Little nuances that are not so obvious and thus handy when reproducing the setup.

## Enable dark mode

### GTK

Write the following to `$XDG_CONFIG_HOME/gtk-3.0/settings.ini`:
```
[Settings]
gtk-application-prefer-dark-theme=1
```

```sh
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
```
In case the theme does not apply the dark scheme to Gtk4 applications:
```sh
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
```

### Qt

Qt4 applications should take the theme from the GTK setting.

Qt5 abd Qt6 applications expect a DE, so instead we use `qt5ct` and `qt6ct` respectively to configure them.
This includes setting the environment variable `QT_QPA_PLATFORMTHEME` to `qt5ct` 
before starting Wayland.

## Make tofi open alacritty

Tofi delegates the finding of the installed terminal to `glib`, which fails to detect `alacritty`.
It does however detect `rxvt`, and so the workaround is to create a symlink, called `rxvt`, that points to `alacritty`.
```sh
ln -s /usr/bin/alacritty /usr/bin/rxvt
```

## Manage wifi connections the right way

### Add a new network

First find the SSID of the new network.
```sh
# wpa_cli
> scan
> scan_results
```
_Note: A message is printed once the scan is completed. Do not query the results
before._
Add the network to the `wpa_supplicant` config:
```sh
# wpa_passphrase '<SSID>' '<PASSPHRASE>' >> /etc/wpa_supplicant/wpa_supplicant.conf
```
This stores the passphrase in plain text and hashed from.
You can edit the config file to manually remove the plain text form.

Restart `wpa_supplicant` to reload the config now.
```sh
# rc-service wpa_supplicant restart
```

### Remove an added network

List the added networks get the ID of the network you want to remove.
```sh
# wpa_cli
> list_networks
```
Remove the network:
```sh
> remove_network <ID>
```

### Select a different network

To connect to a network different from the current one,
first list the networks added so far.
```sh
# wpa_cli
> list_networks
```
Use the ID of the network you want to connect to:
```sh
> select_network <ID>
```

## Assign permission to change screen brightness

Assign yourself to the `video` group.
```sh
# usermod -aG video <username>
```

Add the following udev rule to allow the `video` group to change the brightness.
```sh
/etc/udev/rules.d/backlight.rules
---
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"
```

