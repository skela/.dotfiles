# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Setup (First time)

## Check Health

  :checkhealth

## Cheatsheet

	Space + c + h

## Theme Switcher

	Space + t + h

## Syntax Highlighting

Check which languages are installed

	:TSInstallInfo

Install a language

	:TSInstall {language}

## Language Server Protocol Configs

More info can be found [here](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
or type in

	:help lspconfig-all

## Vim Madness

### Replace Text (Multiple Times)

Yank your word (might also work for deletions)

	yw

Paste

	ve"0p

v - visualmode

e - select word

"0 - get value from Register 0 address

p - paste

