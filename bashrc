# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#export PATH=~/bin:/usr/local/mysql/bin:/usr/local/ant-1.8/bin:/usr/local/sbin:$PATH
#echo "start .bashrc"
export PATH=~/bin:~/scripts:/Applications/Postgres.app/Contents/MacOS/bin:/usr/local/mysql/bin:/usr/local/ant-1.8/bin:/usr/local/sbin:/usr/local/bin:$PATH
export DYLD_FALLBACK_LIBRARY_PATH=/Applications/Postgres.app/Contents/MacOS/lib:$DYLD_LIBRARY_PATH
export NODE_PATH=$(npm root -g)

export CATALINA_HOME=/usr/local/tomcat6
export JAVA_HOME=/usr
#echo "end .bashrc"


