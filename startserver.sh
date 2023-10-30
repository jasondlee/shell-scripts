#!/bin/bash

SUSPEND=n
OTEL=false
CLEAN=FALSE
BASE_DIR=~/src/redhat/wildfly/wildfly-full/build/target/
CONFIG=standalone.xml
STATS=
PORT=14250
DEBUG_LOGGING=false
MICROMETER=false
CLI=""

function pause() {
    read -p "Press enter..."
}

function clean() {
    if [ -e $SERVER_DIR ] ; then
        echo "Deleting $SERVER_DIR"
        rm -rf $SERVER_DIR
    fi

    ARCHIVE=`find $BASE_DIR -maxdepth 1 -type f -name \*zip -o -name \*.tar.gz | grep -v 'src\.'`

    case $ARCHIVE in
        *zip )
            echo "Unzipping $ARCHIVE"
            unzip $ARCHIVE -d $BASE_DIR &> /dev/null
            ;;
        *.tar.gz )
            echo "Untarring $ARCHIVE"
            tar xf $ARCHIVE -C $BASE_DIR
            ;;
    esac
    find_server_dir
}

function find_server_dir() {
    SERVER_DIR=`find $BASE_DIR -maxdepth 1 -type d -name wildfly\*`

    if [ "$SERVER_DIR" == "" ] ; then
        SERVER_DIR=`find $BASE_DIR -maxdepth 1 -type d -name jboss-eap\*`
    fi
}

function add_cli_commands() {
    if [ "$CLI" == "" ]; then
        CLI=`mktemp clicommandsXXX`
        echo "embed-server -c=$CONFIG" > $CLI
    fi

    echo "$*" >> $CLI
}


while getopts "cmMfnosSw:L" opt ; do
    case $opt in
        c) CLEAN=true ;;
        o) OTEL=true ;;
        m) CONFIG=standalone-microprofile.xml ;;
        M) MICROMETER=true ;;
        f) CONFIG=standalone-full.xml ;;
        s) SUSPEND=y ;;
        S) STATS="-Dwildfly.undertow.statistics-enabled=true -Dwildfly.statistics-enabled=true -Dwildfly.undertow.active-request-statistics-enabled=true" ;;
        n) DONTRUN="true" ;;
        w) BASE_DIR=$OPTARG ;;
        L) DEBUG_LOGGING=true ;;
    esac
done

echo "Default SERVER_DIR = $SERVER_DIR"

find_server_dir

if [ "$CLEAN" == "true" ] ; then
    clean
fi

echo "Discovered SERVER_DIR = $SERVER_DIR"

if [ "$SERVER_DIR" == "" -o ! -e "$SERVER_DIR" ] ; then
    echo "Unable to determine server base directory"
    exit -1
fi

sed --in-place "s/#\?JAVA_OPTS=\"\$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,address=8787,server=y,suspend=[ny]\"/JAVA_OPTS=\"\$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,address=8787,server=y,suspend=$SUSPEND\"/" \
    $SERVER_DIR/bin/standalone.conf

if [ "$DEBUGG_LOGGING" == "true" ] ; then
    add_cli_commands "/subsystem=logging/console-handler=CONSOLE:write-attribute(name=level,value=DEBUG)
    /subsystem=logging/root-logger=ROOT:write-attribute(name=level,value=DEBUG)"
fi

if [ "$OTEL" == "true" ] ; then
    add_cli_commands "if (outcome != success) of /extension=org.wildfly.extension.opentelemetry:read-resource
        /extension=org.wildfly.extension.opentelemetry:add()
        /subsystem=opentelemetry:add()
    fi
    /subsystem=opentelemetry:write-attribute(name=exporter-type,value=otlp)
    /subsystem=opentelemetry:write-attribute(name=sampler-type,value=on)
    /subsystem=opentelemetry:write-attribute(name=max-queue-size,value=128)
    /subsystem=opentelemetry:write-attribute(name=max-export-batch-size,value=512)"
fi

if [ "$MICROMETER" == "true" ] ; then
    add_cli_commands "if (outcome != success) of /extension=org.wildfly.extension.micrometer:read-resource
            /extension=org.wildfly.extension.micrometer:add
            /subsystem=micrometer:add(endpoint=\"http://localhost:4317/v1/metrics\")
        fi
        /subsystem=micrometer:write-attribute(name=step,value=10)
        /subsystem=undertow:write-attribute(name=statistics-enabled,value=true)"
fi

if [ "$CLI" != ""  ] ; then
    echo "Configuring the server..."
    echo "reload" >> $CLI
    $SERVER_DIR/bin/jboss-cli.sh --file=$CLI
    rm $CLI
fi

PATH=$SERVER_DIR/bin:$PATH

JBOSS_HOME=$SERVER_DIR
echo Starting WildFly from $SERVER_DIR

if [ "$DONTRUN" != "true" ] ; then
    $SERVER_DIR/bin/standalone.sh -c $CONFIG $STATS
fi
