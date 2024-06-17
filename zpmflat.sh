#!/bin/bash

dialog --title "Authentification" --insecure --passwordbox "Entrez le mot de passe root:" 8 40 2>password.txt
PASSWORD=$(<password.txt)
rm password.txt

run_with_sudo() {
    echo "$PASSWORD" | sudo -S "$@"
}

DIALOGRC=$(mktemp)
cat <<EOF > $DIALOGRC
screen_color = (BLUE,BLUE,ON)
title_color = (WHITE,BLUE,ON)
border_color = (WHITE,BLUE,ON)
button_active_color = (GREEN,BLUE,ON)
button_inactive_color = (WHITE,BLUE,ON)
EOF
export DIALOGRC

install_dependencies() {
    if ! command -v dialog &> /dev/null; then
        echo "Installation de 'dialog'..."
        case $PKG_MANAGER in
            apt) run_with_sudo apt install -y dialog ;;
            dnf) run_with_sudo dnf install -y dialog ;;
            zypper) run_with_sudo zypper install -y dialog ;;
            rpm-ostree) run_with_sudo rpm-ostree install dialog ;;
        esac
        if [ $? -eq 0 ]; then
            echo "Installation avec succès"
        else
            echo "Oups, il y a une erreur"
        fi
    fi
}

if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
elif command -v zypper &> /dev/null; then
    PKG_MANAGER="zypper"
elif command -v rpm-ostree &> /dev/null; then
    PKG_MANAGER="rpm-ostree"
else
    echo "Aucun gestionnaire n'est trouvé,Le script est disponible seulement pour les systèmes des familles Debian, Redhat, OpenSuse et Fedora Silverblue."
    exit 1
fi

install_dependencies

manage_flatpak() {
    while true; do
        cmd=(dialog --menu "ZPM - Zeima Package Manager -Flatpak Edition" 22 76 16)
        options=(
            1 "Installer une application Flatpak"
            2 "Mettre à jour les applications Flatpak"
            3 "Désinstaller une application Flatpak"
            4 "Quitter"
        )
        choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [ $? -ne 0 ]; then
            break
        fi
        case $choices in
            1) 
                app=$(dialog --menu "Choisissez une application Flatpak à installer:" 22 76 16 \
                    1 "GIMP" \
                    2 "VLC" \
                    3 "LibreOffice" \
                    4 "Spotify" \
                    5 "Firefox" \
                    6 "Discord" \
                    7 "Steam" \
                    8 "Visual Studio Code" \
                    9 "Gnome Extension Manager" \
                    10 "Wine-Windows Emulator" \
                    11 "KdenLive" \
                    12 "Freetube" \
                    13 "HandBrake" \
                    14 "Postman" \
                    15 "ClamTk" \
                    16 "ytDownloader" \
                    17 "Podman Desktop" \
                    18 "Gear Lever" \
                    19 "Bleach Bit" \
                    20 "Taper votre application" 2>&1 >/dev/tty)
                if [ $? -ne 0 ]; then
                    continue
                fi
                case $app in
                    1) app="org.gimp.GIMP" ;;
                    2) app="org.videolan.VLC" ;;
                    3) app="org.libreoffice.LibreOffice" ;;
                    4) app="com.spotify.Client" ;;
                    5) app="org.mozilla.firefox" ;;
                    6) app="com.discordapp.Discord";;
                    7) app="com.valvesoftware.Steam";;
                    8) app="com.visualstudio.code";;
                    9) app="com.mattjakeman.ExtensionManager";;
                    10) app="org.winehq.Wine";;
                    11) app="org.kde.kdenlive";;
                    12) app="io.freetubeapp.FreeTube";;
                    13) app="fr.handbrake.ghb";;
                    14) app="com.getpostman.Postman";;
                    15) app="com.gitlab.davem.ClamTk";;
                    16) app="io.github.aandrew_me.ytdn";;
                    17) app="io.podman_desktop.PodmanDesktop";;
                    18) app="it.mijorus.gearlever";;
                    19) app="com.bleachbit.BleachBit";;
                    20) app=$(dialog --inputbox "Entrez le nom de l'application Flatpak à installer:" 8 40 2>&1 >/dev/tty) ;;
                esac
                run_with_sudo flatpak install flathub "$app"
                if [ $? -eq 0 ]; then
                    dialog --msgbox "Installation Flatpak avec succès" 6 40
                else
                    dialog --msgbox "Installation Flatpak échoué, il y a une erreur !" 6 40
                fi
                ;;
            2) 
                run_with_sudo flatpak update -y
                if [ $? -eq 0 ]; then
                    dialog --msgbox "Mise à jour Flatpak avec succès" 6 40
                else
                    dialog --msgbox "Mise à jour Flatpak échoué, il y a une erreur !" 6 40
                fi
                ;;
            3) 
                app=$(dialog --inputbox "Entrez le nom de l'application Flatpak à désinstaller:" 8 40 2>&1 >/dev/tty)
                if [ $? -ne 0 ]; then
                    continue
                fi
                run_with_sudo flatpak uninstall -y "$app"
                if [ $? -eq 0 ]; then
                    dialog --msgbox "Désinstallation Flatpak avec succès" 6 40
                else
                    dialog --msgbox "Désinstallation Flatpak échoué, il y a une erreur !" 6 40
                fi
                ;;
            4) break ;;
        esac
    done
}

manage_flatpak

echo "Merci à la prochaine ! :) "
