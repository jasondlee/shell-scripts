#!/bin/bash

source `dirname $0`/includes.sh

SUSPEND=n
OTEL=false
CLEAN=false
BASE_DIR=~/src/redhat/wildfly/wildfly-full/build/target/
CONFIG=standalone.xml
DEBUG_LOGGING=false
MICROMETER=false
CLI=""
DEBUG=false
SERVER_DIR=`pwd`/build/target/wildfly*/
DONTRUN=false
#STATS="-Dwildfly.undertow.statistics-enabled=false -Dwildfly.statistics-enabled=false -Dwildfly.undertow.active-request-statistics-enabled=false"

function clean() {
    if [ -e "$SERVER_DIR" ] ; then
        echo "Deleting $SERVER_DIR"
        rm -rf "$SERVER_DIR"
    else
        echo "SERVER_DIR does not exist: $SERVER_DIR"
    fi

    ARCHIVE=$( find "$BASE_DIR" -maxdepth 1 -type f -name \*zip -o -name \*.tar.gz | grep -v 'src\.' )

    case "$ARCHIVE" in
        *zip )
            echo "Unzipping $ARCHIVE"
            unzip "$ARCHIVE" -d "$BASE_DIR" &> /dev/null
            ;;
        *.tar.gz )
            echo "Untarring $ARCHIVE"
            tar xf "$ARCHIVE" -C "$BASE_DIR"
            ;;
    esac
    find_server_dir
}

function find_server_dir() {
    SERVER_DIR=$( find "$BASE_DIR" -maxdepth 1 -type d -name wildfly\* )

    if [ "$SERVER_DIR" == "" ] ; then
        SERVER_DIR=$( find "$BASE_DIR" -maxdepth 1 -type d -name jboss-eap\* )
    fi
}

function add_cli_commands() {
    debug "===== Adding $*"
    if [ "$CLI" == "" ]; then
        CLI=$( mktemp clicommandsXXX )
        debug "CLI file is $CLI"
        echo "embed-server -c=$CONFIG" > "$CLI"
    fi

    echo "$*" >> "$CLI"
}


while getopts "cmMfhnosw:Ld" opt ; do
    debug "=== opt = $opt"
    case "$opt" in
        L) debug "Setting logging level"
            DEBUG_LOGGING=true
            ;;
        c) CLEAN=true ;;
        d) DEBUG=true ;;
        o) OTEL=true ;;
        m) CONFIG=standalone-microprofile.xml ;;
        M) MICROMETER="true" ;;
        f) CONFIG=standalone-full.xml ;;
        h) CONFIG=standalone-full-ha.xml ;;
        s) SUSPEND=y ;;
        #S) STATS=$( echo $STATS | sed -e 's/false/true/g') ;;
        n) DONTRUN="true" ;;
        w) BASE_DIR=$OPTARG ;;
        *) echo "Unrecognized option: $opt" ; exit 1 ;;
    esac
done

echo "Default SERVER_DIR = $SERVER_DIR"

find_server_dir

pause

if [ "$CLEAN" == "true" ] ; then
    clean
fi
set +x

pause

echo "Discovered SERVER_DIR = $SERVER_DIR"

if [ "$SERVER_DIR" == "" ] || [ ! -e "$SERVER_DIR" ] ; then
    echo "Unable to determine server base directory"
    exit 1
fi

sed --in-place "s/#\?JAVA_OPTS=\"\$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,address=8787,server=y,suspend=[ny]\"/JAVA_OPTS=\"\$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,address=8787,server=y,suspend=$SUSPEND\"/" \
    "$SERVER_DIR/bin/standalone.conf"

pause

debug "DEBUG_LOGGING = $DEBUG_LOGGING"

if [ "$DEBUG_LOGGING" == "true" ] ; then
    add_cli_commands "/subsystem=logging/console-handler=CONSOLE:write-attribute(name=level,value=DEBUG)
    /subsystem=logging/root-logger=ROOT:write-attribute(name=level,value=DEBUG)"
fi

pause

if [ "$OTEL" == "true" ] ; then
    #add_cli_commands "if (outcome != success) of /extension=org.wildfly.extension.opentelemetry:read-resource
    add_cli_commands "/extension=org.wildfly.extension.opentelemetry:add()
        /subsystem=opentelemetry:add()

        /subsystem=opentelemetry:write-attribute(name=sampler-type,value=on)
        /subsystem=opentelemetry:write-attribute(name=batch-delay,value=1)"
fi

pause

if [ "$MICROMETER" == "true" ] ; then
    #add_cli_commands "if (outcome != success) of /extension=org.wildfly.extension.micrometer:read-resource
    add_cli_commands " /extension=org.wildfly.extension.micrometer:add
       /subsystem=micrometer:add(endpoint=\"http://localhost:4318/v1/metrics\")
       /subsystem=undertow:write-attribute(name=statistics-enabled,value=true)"
       #/subsystem=micrometer:write-attribute(name=\"step\",value=\"1\")"
       #/subsystem=micrometer/registry=prometheus:add(context=/prometheus)"

#     add_cli_commands << EOF
#         if (outcome != success) of /extension=org.wildfly.extension.micrometer:read-resource
#             /extension=org.wildfly.extension.micrometer:add
#         end-if
#
#         if (outcome != success) of /subsystem=micrometer:read-resource
#             /subsystem=micrometer:add()
#             reload
#         end-if
#         /subsystem=micrometer/registry=otlp:add(endpoint="http://localhost:4318/v1/metrics")
#
# EOF
fi

if [ "$CLI" != ""  ] ; then
    echo "Configuring the server..."
    echo "reload" >> "$CLI"
    "$SERVER_DIR"/bin/jboss-cli.sh --echo-command "--file=$CLI"
    rm "$CLI"
fi

pause

PATH="$SERVER_DIR/bin:$PATH"

export JBOSS_HOME="$SERVER_DIR"
echo Starting WildFly from "$SERVER_DIR"

if [ "$DONTRUN" != "true" ] ; then
    "$SERVER_DIR"/bin/standalone.sh -c "$CONFIG"
fi

set +x
