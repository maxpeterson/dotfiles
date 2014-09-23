# some more ls aliases
alias ll='ls -al'
alias la='ls -A'

alias l='less'
alias h='history'
alias n='mvim'
alias mvimr='mvim --remote'
alias pu=pushd
alias po=popd


alias git=hub

# Django
alias pm='python $([ -e manage.py ] && echo manage.py || echo */manage.py)'
alias pmr='pm runserver_plus'
alias pms='pm shell_plus'

# Set up DB tunnel to Sultan
alias sshtunnel='ssh incuna@dev.incuna.com -L 9432:localhost:5432'
# Update DATABASE_URL to use 127.0.0.1:9432
alias dbtunnel='export DATABASE_URL=$(echo $DATABASE_URL|sed -e "s/192.168.0.2/127.0.0.1:9432/")'

# Set up AFP tunnel to Sultan (for finder)
alias afptunnel='ssh incuna@dev.incuna.com -L 5480:192.168.0.3:548 -N -f && open afp://incuna@127.0.0.1:5480/Clients'

# Set env using hoard
alias setenv='$(hoard get | sed s/^/export\ /)'

alias junglediskload='sudo launchctl load -w /Library/LaunchDaemons/com.jungledisk.service.plist'
alias junglediskunload='sudo launchctl unload -w /Library/LaunchDaemons/com.jungledisk.service.plist'

alias builddocx='for file in docs/src/*.md; do pandoc -s -S $file -o docs/docx/$(basename ${file%%.*}).docx; done'

# Git utils 
function git-authors {
    git log --format='%aN' | sort -u
}
function gitstat-author {
    
    git log --all --author="${1}" --after=`date -v-${2-7}d "+%Y-%m-%d"` --pretty=tformat: --numstat | \
        awk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' -
}
function gitstat-authors {
    git-authors | while read author; do
        echo "$author"
        echo "  "$(gitstat-author "$author" $@)
        
    done
}

# ssh to a local machine (pass in the last part of the machines ip)
# Use sslocal 7 for ssh incuna@192.168.0.7
function sslocal
{
if [[ "${1}" ]] ; then 
    ssh ${2:-incuna}@192.168.0.$1
else
    echo "Host number not specified"; 
    echo "Usage sslocal <machine number> [user]"; 
fi
}


alias dist-packages='cd /usr/local/lib/python2.6/dist-packages/'

function svnaddall
{
svn status $@ | egrep '^\?' | sed -e 's/^\?\s*//' | xargs svn add
}

function stat {
    cwd=`pwd`;
    for dir in ${@:-./src/*}; do
        if [ -d "$dir" ] ; then
            cd $dir;
            echo "Status for $dir";
            if [ -e .svn ]; then svn st; fi;
            if [ -e .hg ]; then hg status; fi;
            if [ -e .git ]; then git status; fi;
            cd $cwd; 
        fi
    done;
}

function incoming {
    cwd=`pwd`;
    for dir in ${@:-./src/*}; do
        if [ -d "$dir" ] ; then
            cd $dir;
            echo "Incoming for $dir";
            if [ -e .svn ]; then svn st -u; fi;
            if [ -e .hg ]; then hg incoming; fi;
            if [ -e .git ]; then git fetch && git log ..origin/master; fi;
            cd $cwd; 
        fi
    done;
}

function update {
    cwd=`pwd`;
    for dir in ${@:-./src/*}; do
        if [ -d "$dir" ] ; then
            cd $dir;
            echo "Updating $dir";
            if [ -e .svn ]; then svn update; fi;
            if [ -e .hg ]; then hg fetch; fi;
            if [ -e .git ]; then git pull; fi;
            cd $cwd; 
        fi
    done;
}

function bitbucketadd {
    BITBUCKET_ACOUNT=incuna
    PROJECT_NAME=$1
    IS_PRIVATE=${2:-true}
    BITBUCKET_USER=${3:-incuna:$BITBUCKET_PASSWORD}
    echo "Adding the project to bitbucket."
    curl -s -u "${BITBUCKET_USER}" 'https://api.bitbucket.org/1.0/repositories/' -X POST -d "name=${PROJECT_NAME}&is_private=${IS_PRIVATE}"
    
}


function bitbucketaddpermissions {
    BITBUCKET_ACOUNT=incuna
    BITBUCKET_USER=${2:-incuna:$BITBUCKET_PASSWORD}
    PROJECT_NAME=$1

    if [ "${PROJECT_NAME}" == "" ] ; then
        export REPOS=`curl -u "${BITBUCKET_USER}" "https://api.bitbucket.org/1.0/users/${BITBUCKET_ACOUNT}/"`
        # Parse permissions (json) using python
        python -c "from json import loads" > /dev/null 2>&1
        if [ $? != 0 ] ; then
            echo "python module json not found"
        else
            SLUGS=`python -c "
from os import environ
from json import loads
repos = loads(environ['REPOS'])
if 'repositories' in repos: 
    for p in repos['repositories']: 
        print p['slug']"`;
            for SLUG in $SLUGS; do
                bitbucketaddpermissions $SLUG
            done
            
            return 0
        fi
    fi
    # user permissions
    export PERMS=`curl -u "${BITBUCKET_USER}" "https://api.bitbucket.org/1.0/privileges/${BITBUCKET_ACOUNT}/incuna-project/"`;

    # Parse permissions (json) using python
    python -c "from json import loads" > /dev/null 2>&1
    if [ $? != 0 ] ; then
        echo "python module json not found"
    else
        PRIVILEGES=`python -c "
from os import environ
from json import loads
for p in loads(environ['PERMS']): print '%s:%s' % (p['user']['username'], p['privilege'])"`;

        echo "Adding user permission."
        for PAIR in $PRIVILEGES; do
            USER=${PAIR%:*}
            PRIVILEGE=${PAIR#*:}
            if [ $USER == $PRIVILEGE ]; then 
                PRIVILEGE='write'; 
            fi
            echo "    $USER > $PRIVILEGE"
            bitbucketaddpermission $PROJECT_NAME $USER $PRIVILEGE
        done
    fi

    # group permissions
    export PERMS=`curl -u "${BITBUCKET_USER}" "https://api.bitbucket.org/1.0/group-privileges/incuna/incuna-project/"`;

    # Parse permissions (json) using python
    python -c "from json import loads" > /dev/null 2>&1
    if [ $? != 0 ] ; then
        echo "python module json not found"
    else
        PRIVILEGES=`python -c "
from os import environ
from json import loads
for p in loads(environ['PERMS']): print '%s:%s' % (p['group']['slug'], p['privilege'])"`;

        echo "Adding group permission."
        for PAIR in $PRIVILEGES; do
            USER=${PAIR%:*}
            PRIVILEGE=${PAIR#*:}
            if [ $USER == $PRIVILEGE ]; then 
                PRIVILEGE='write'; 
            fi
            echo "    $USER > $PRIVILEGE"
            bitbucketaddgrouppermission $PROJECT_NAME $USER $PRIVILEGE
        done
    fi


}
function bitbucketaddprivilege {
    BITBUCKET_ACOUNT=incuna
    BITBUCKET_USER=${5:-incuna:$BITBUCKET_PASSWORD}
    TYPE=${4:-privileges}
    PERMISSION=${3:-write}
    WHAT=$2
    PROJECT_NAME=$1
    echo "https://api.bitbucket.org/1.0/${TYPE}/${BITBUCKET_ACOUNT}/${PROJECT_NAME}/${WHAT}" -d $PERMISSION
    curl -s -u  -X PUT "$BITBUCKET_USER" "https://api.bitbucket.org/1.0/${TYPE}/${BITBUCKET_ACOUNT}/${PROJECT_NAME}/${WHAT}" -d $PERMISSION
}

function bitbucketaddpermission {
    BITBUCKET_ACOUNT=incuna
    BITBUCKET_USER=${4:-incuna:$BITBUCKET_PASSWORD}
    PERMISSION=${3:-write}
    USER=$2
    PROJECT_NAME=$1
    curl -s  -X PUT -u "$BITBUCKET_USER" "https://api.bitbucket.org/1.0/privileges/$BITBUCKET_ACOUNT/$PROJECT_NAME/$USER" -d $PERMISSION
    #bitbucketaddprivilege $1 $2 ${3:-write} 'privileges' $4
}

function bitbucketaddgrouppermission {
    BITBUCKET_ACOUNT=incuna
    BITBUCKET_USER=${4:-incuna:$BITBUCKET_PASSWORD}
    PERMISSION=${3:-write}
    GROUP=$2
    PROJECT_NAME=$1
    curl -s  -X PUT -u "$BITBUCKET_USER" "https://api.bitbucket.org/1.0/group-privileges/$BITBUCKET_ACOUNT/$PROJECT_NAME/$BITBUCKET_ACOUNT/$GROUP" -d $PERMISSION
    #bitbucketaddprivilege $1 $2 ${3:-write} 'group-privileges' $4
}

alias activate='source bin/activate'
alias virtualenvactivate='(virtualenv --no-site-packages .) && activate'
alias activatebuildout='virtualenvactivate && (bin/python bootstrap.py) && (bin/buildout -N)'

function rebuildvirtualenv {
    project=${1}
    python=${2:-$(which python)}
    workon ${project}
    deactivate
    rmvirtualenv ${project}
    mkvirtualenv ${project} --python=${python}
    setvirtualenvproject
    pip install -r requirements.txt
}

function key-share {
    if [ "${1}" == "" ] ; then
        echo "Host not specified"; 
        echo "Usage key-share [user]@[host]"; 
        return 1
    fi

    host=${1}
    echo "${host}" | grep -q "@"
    if [ $? == 1 ] ; then
        host="incuna@${host}"
    fi

    cat ~/.ssh/id_rsa.pub | ssh ${host} 'cat - >> ~/.ssh/authorized_keys'
}

function update-keys {
    usage="Usage update-keys [key_file] [user]@[host1] ...";
    if [ "${1}" == "" ] ; then
        echo "File not specified"; 
        echo ${usage}; 
        return 1
    fi
    key_file=${1}; shift;
    
    if [ "${1}" == "" ] ; then
        echo "Host not specified"; 
        echo $usage; 
        return 1
    fi

    for host in $@; do 
        echo "${host}" | grep -q "@"
        if [ $? == 1 ] ; then
            host="incuna@${host}"
        fi
        echo "${key_file} | ssh ${host} 'cat - > ~/.ssh/authorized_keys'"
        cat ${key_file} | ssh ${host} 'cat - > ~/.ssh/authorized_keys'
    done
}


function release {
    user=${1:-incuna}
    python setup.py register -r $user sdist upload -r $user
}

function sgrep 
{
    grep $@ | egrep -v '(.svn|.pyc)'
}

# Synopsis planning tool build
function cpt_build
{
    if [ "$1" == "" ] ; then
        echo "No customer"
        return 1
    fi
    ant -Dcustomer=$1 deploy_customer
}

function cpt_release
{
    if [ "$1" == "" ] ; then
        echo "No customer"
        return 1
    fi
    ant -Dcustomer=$1 release_customer
}

djvim() {
     mvim "+cd $1" "+TlistAddFilesRecursive . [^_]*py\|*js\|*html\|*css" +TlistOpen
}

changelog() {
    last=''
    while IFS= read -r first; do
        while read tag; do
            echo
            echo "## ${last:-CURRENT}"
            echo
            git log "$last...$tag" --pretty=format:"* %s" --reverse | grep -v Merge;
            last=$tag
        done < <(git tag | grep "^$first" | sort -r -t . -k 2 -n)
    done < <(git tag | sed -e 's/^\(v[^.]*\)\..*/\1/' | sort -u -r)
}

