# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#export PATH=~/bin:/usr/local/mysql/bin:/usr/local/ant-1.8/bin:/usr/local/sbin:$PATH
echo "start .bashrc"
export PATH=~/bin:~/scripts:/usr/local/mysql/bin:/usr/local/ant-1.8/bin:/usr/local/sbin:/usr/local/bin:$PATH
export NODE_PATH=$(npm root -g)

export CATALINA_HOME=/usr/local/tomcat6
export JAVA_HOME=/usr
echo "end .bashrc"


