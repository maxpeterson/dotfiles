# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export PATH=/usr/local/opt/python/libexec/bin/:$PATH
export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/usr/local/heroku/bin:$PATH
export PATH=~/bin:~/scripts:$PATH

#export CATALINA_HOME=/usr/local/tomcat6
export JAVA_HOME=$(/usr/libexec/java_home)

# Required to fix compile error following Xcode upgrade to 5.1
# clang: error: unknown argument: '-mno-fused-madd' [-Wunused-command-line-argument-hard-error-in-future]
export CFLAGS=-Qunused-arguments
export CPPFLAGS="-Qunused-arguments -I/usr/local/opt/zlib/include"
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export LIBMEMCACHED=/usr/local


export DYLD_FALLBACK_LIBRARY_PATH=/Applications/Postgres.app/Contents/Versions/latest/lib:$DYLD_LIBRARY_PATH

