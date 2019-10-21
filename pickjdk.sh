#!/bin/bash
#
# Provides a function that allows you to choose a JDK.  Just set the environment 
# variable JDKS_ROOT to the directory containing multiple versions of the JDK
# and the function will prompt you to select one.  JAVA_HOME and PATH will be cleaned
# up and set appropriately.

# Usage:
# Include in .profile or .bashrc or source at login to get 'pickjdk' command.
# 'pickjdk' alone to bring up a menu of installed JDKs on OS X. Select one.
# 'pickjdk <jdk number>' to immediately switch to one of those JDKs.

# Huge tip o' the hat to Nick Sieger for starting this script years ago:
#     https://twitter.com/nicksieger/status/1166070669244796929

CONFFILE=~/.pickjdk.conf

unset JDKS_ROOT
declare -a JDKS_ROOT

if [ ! -e $CONFFILE ] ; then
    echo "/usr/lib/jvm 
/usr/java 
/Library/Java/JavaVirtualMachines 
$HOME/.sdkman/candidates/java" > $CONFFILE
fi

for P in `cat $CONFFILE` ; do
    if [ -d $P ] ; then
        JDKS_ROOT+=($P)
    fi
done

_checkos()
{
    if [ $(uname -s) = $1 ]; then
        return 0
    else
        return 1
    fi
}

addjdkroot() {
    LC=`cat $CONFFILE | grep $1 | wc -l`
    if [ $LC == 0 ] ; then
        echo $1 >> $CONFFILE
        echo JDK root added.
    else
        echo JDK root already added.
    fi
}

pickjdk()
{
    declare -a JDKS
    local n=1 jdk total_jdks choice=0 currjdk=$JAVA_HOME explicit_jdk
    for root in ${JDKS_ROOT[@]} ; do
        for jdk in $root/[0-9a-z]*; do
            if [ -d $jdk -a ! -L $jdk -a -e $jdk/bin ]; then
                JDKNAMES[$n]="$(basename $jdk)"
                if _checkos Darwin ; then
                    jdk=$jdk/Contents/Home
                fi
                if [ -z "$1" ]; then
                    echo -n " $n) ${JDKNAMES[$n]}"
                    if [ $jdk = "$currjdk" ]; then
                        echo " < CURRENT"
                    else
                        echo
                    fi
                fi
                JDKS[$n]=$jdk
                total_jdks=$n
                n=$[ $n + 1 ]
            fi
        done
    done
    if [ -z "$1" ]; then
      echo " $n) None"
    fi
    JDKS[$n]=None
    total_jdks=$n

    if [ $total_jdks -gt 1 ]; then
        if [ -z "$1" ]; then
          while [ -z "${JDKS[$choice]}" ]; do
              echo -n "Choose one of the above [1-$total_jdks]: "
              read choice
          done
        else
          choice=$1
        fi
    fi

    if [ -z "$currjdk" ]; then
        currjdk=$(dirname $(dirname $(type -path java)))
    fi

    if [ ${JDKS[$choice]} != None ]; then
        export JAVA_HOME=${JDKS[$choice]}
    else
        unset JAVA_HOME
    fi

    explicit_jdk=
    for jdk in ${JDKS[*]}; do
        if [ "$currjdk" = "$jdk" ]; then
            explicit_jdk=$jdk
            break
        fi
    done

    if [ "$explicit_jdk" ]; then
        if [ -z "$JAVA_HOME" ]; then
            PATH=$(echo $PATH | sed "s|$explicit_jdk/bin:*||g")
        else
            PATH=$(echo $PATH | sed "s|$explicit_jdk|$JAVA_HOME|g")
        fi
    elif [ "$JAVA_HOME" ]; then
        PATH="$JAVA_HOME/bin:$PATH"
    fi

    echo "New JDK: ${JDKNAMES[$choice]}"

    hash -r
}
