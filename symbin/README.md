# symbin
easy "install to PATH" via symlinks

### setup
###### symbin-setup.sh [SYMBIN_DIR = ~/sym-bin]
 1. configures current user's .bashrc to support symbin
 2. SYMBIN_DIR will be added to PATH
 3. 'symbin' and 'symbin-rm' will be symlinked from SYMBIN_DIR (by running symbin on itself, lol)

### adding commands
###### symbin path/to/exec \[...]
 1. links ${SYMBIN_DIR}/exec to the original executable
 2. .sh extension will be stripped (cmd.sh -> cmd)
 3. conflicts

### removing commands
###### symbin-rm cmd \[...]
 1. removes each 'cmd' from SYMBIN_DIR (and therefore from your PATH)
