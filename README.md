Dot files!

== Installation

Create soft links to the files from your home directory.

    for file in *; do [[ ! -e ~/.$file ]] && ln -s `pwd`/$file ~/.$file; done
