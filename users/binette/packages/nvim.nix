#!/bin/nix
{ config, lib, pkgs, ... }: {

  home-manager.users.binette.programs.neovim = {
    enable = true;
    extraConfig = ''

    '';
