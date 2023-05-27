# Setup (First time)

	rm -fdr ~/.config/nvim
	rm -rf ~/.local/share/nvim
	git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
	ln -s ~/.dotfiles/config/nvim ~/.config/nvim/lua/custom

# Cheatsheet

	Space + c + h

# Theme Switcher

	Space + t + h

# Syntax Highlighting

Check which languages are installed

	:TSInstallInfo

Install a language

	:TSInstall {language}

