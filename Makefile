###################################################################
#
#  Makefile for dotfiles.
#
#  Author:  Lee Netherton
#  Created: 12/05/2010
#
#  Usage:
#      make          - will build sym links
#      make install  - will copy sym links to user directory
#      make bashrc   - will add the source command to the end
#                      of your .bashrc file (only do this once!)
#      make apt      - will install the packages listed in apt.sh
#
###################################################################

# Set MAKEFLAGS so that GNU make treats symbolic links
# as valid targets (and not the linked-to file)
MAKEFLAGS = "-L"


######################## Source Files #############################

# Files to link
LNK_FILES += vimrc
LNK_FILES += vim
LNK_FILES += vimoutliner
LNK_FILES += vimoutlinerrc
LNK_FILES += screenrc
LNK_FILES += bashrc.public
LNK_FILES += gitconfig
#LNK_FILES += rtorrent.rc
#LNK_FILES += irssi
#LNK_FILES += snownews

# Files to copy
CP_FILES += bashrc.private

# Dot files
DOT_LNK_FILES = $(addprefix .,$(LNK_FILES))
DOT_CP_FILES  = $(addprefix .,$(CP_FILES))

# Locations
DEST_DIR = ${HOME}
SOURCE_DIR = ${PWD}


########################## Rules #################################

# Default rule
#
.PHONY: all
all : $(DOT_LNK_FILES) $(DOT_CP_FILES)


# Dotfile creation rules
#
$(DOT_LNK_FILES): $(LNK_FILES) Makefile
	ln -sf $(SOURCE_DIR)/$(patsubst .%,%,$(@)) $(SOURCE_DIR)/$(@)

$(DOT_CP_FILES): $(CP_FILES) Makefile
	cp -f $(SOURCE_DIR)/$(patsubst .%,%,$(@)) $(SOURCE_DIR)/$(@)


# Install rule
#   - Installs all dotfiles. If the file exists and is not a link then
#     the file is backed up (to file~) and the user is prompted to overwrite
#     the file.
#
.PHONY: install
install: $(DOT_LNK_FILES) $(DOT_CP_FILES) bashrc
	install -m 644 --backup=numbered $(DOT_CP_FILES) $(DEST_DIR)
	@for dotfile in $(DOT_LNK_FILES); do \
		echo "Installing $${dotfile}"; \
		if [ -f $(DEST_DIR)/$${dotfile} -a ! -L $(DEST_DIR)/$${dotfile} ]; then \
			cp -f $(DEST_DIR)/$${dotfile}{,~}; \
			cp -id $${dotfile} $(DEST_DIR); \
		else \
			cp -d $${dotfile} $(DEST_DIR); \
		fi ; \
	done

# Add entry to ~/.bashrc
#
.PHONY: bashrc
bashrc: bashrc.include Makefile
	@if fgrep -q '.bashrc.public' $(HOME)/.bashrc; then \
		echo "Bash profile already added."; \
	else \
		cat bashrc.include >> $(HOME)/.bashrc; \
		echo "Bash profile source added."; \
	fi


# Clean all dot files
#
.PHONY: clean
clean:
	rm -f $(DOT_LNK_FILES)
	rm -f $(DOT_CP_FILES)

# Install all aptitude packages
#
.PHONY: apt
apt:
	sudo sh apt.sh

