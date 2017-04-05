#!/bin/sh
#
# Test it using indigo-dc/watts-plugin-tester
#
# Author: Joshua Bachmeier
#

# Parameters (passed as environment variables)
: ${PLUGIN_TESTER_REPO:="https://github.com/indigo-dc/watts-plugin-tester.git"}


test_plugin() {
    echo ${2:-'null'} > /tmp/plugin_input || return
    args="test plugin/info.py --plugin-action=$1 --json=/tmp/plugin_input"

    /tmp/plugin-tester/plugin-tester $args
}


# Get and build the plugin tester
rm -rf /tmp/plugin-tester
git clone $PLUGIN_TESTER_REPO /tmp/plugin-tester || exit

pushd /tmp/plugin-tester || exit
go build || exit
popd

# TODO More tests than one per action?
test_plugin parameter "$PLUGIN_PARAMETER_INPUT" || exit
test_plugin request "$PLUGIN_REQUEST_INPUT" || exit
test_plugin revoke "$PLUGIN_REVOKE_INPUT" || exit
