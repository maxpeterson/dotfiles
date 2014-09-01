# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export PATH=~/bin:~/scripts:/Applications/Postgres.app/Contents/Versions/9.3/bin:/usr/local/mysql/bin:/usr/local/ant-1.8/bin:/usr/local/sbin:/usr/local/bin:$PATH
export PATH="/usr/local/heroku/bin:$PATH"

# Setup rbenv
eval "$(rbenv init -)"

export NODE_PATH=$(npm root -g)

#export CATALINA_HOME=/usr/local/tomcat6
export JAVA_HOME=$(/usr/libexec/java_home)

# Required to fix compile error following Xcode upgrade to 5.1
# clang: error: unknown argument: '-mno-fused-madd' [-Wunused-command-line-argument-hard-error-in-future]
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments
