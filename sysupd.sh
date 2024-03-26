#!/bin/bash

source "$HOME"/.bashrc

sudo dnf update --refresh -y
sdk update
yes | sdk upgrade
sudo snap refresh
sudo flatpak update -y
