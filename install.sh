#!/bin/bash

echo "Installing programs..."
sudo pacman -S hyprland hyprpaper waybar neovim alacritty btop cmus wofi grim slurp

echo "Installing fonts..."
sudo pacman -S ttf-liberation ttf-dejavu opendesktop-fonts ttf-bitstream-vera ttf-arphic-ukai ttf-arphic-uming ttf-hanazono ttf-jetbrains-mono-nerd

echo "Copying settings..."
cp -r .config ~/
cp -r .bashrc ~/
