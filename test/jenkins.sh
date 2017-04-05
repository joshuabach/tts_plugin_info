#!/bin/sh
#
# Test it using indigo-dc/watts-plugin-tester
#
# Author: Joshua Bachmeier
#


# Parameters (passed as environment variables)
: ${PLUGIN_TESTER_REPO:="https://github.com/indigo-dc/watts-plugin-tester.git"}
: ${PLUGIN_TESTER_BUILD_DIR:="./plugin-tester"}


setup_plugin_tester() {
    rm -rf $PLUGIN_TESTER_BUILD_DIR
    git clone $PLUGIN_TESTER_REPO $PLUGIN_TESTER_BUILD_DIR || exit

    pushd $PLUGIN_TESTER_BUILD_DIR || exit
    ./utils/compile.sh || exit
    popd
}

test_plugin() {
    echo ${2:-'null'} > /tmp/plugin_input || return
    args="test plugin/info.py --plugin-action=$1 --json=/tmp/plugin_input"

    $PLUGIN_TESTER_BUILD_DIR/plugin-tester $args
}


setup_plugin_tester

# TODO More tests than one per action?
test_plugin parameter "$PLUGIN_PARAMETER_INPUT" || exit
test_plugin request "$PLUGIN_REQUEST_INPUT" || exit
test_plugin revoke "$PLUGIN_REVOKE_INPUT" || exit
