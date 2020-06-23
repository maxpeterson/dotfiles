Dot files!

## Installation

Create soft links to the files from your home directory.

    for file in *; do [[ ! -e ~/.$file ]] && ln -s `pwd`/$file ~/.$file; done


Install https://github.com/ohmyzsh/ohmyzsh

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
