#!/bin/sh
#
# Test it using indigo-dc/watts-plugin-tester
#
# Run a test for each input file of the form:
#   test/{parameter,request,revoke}_*_{pass,fail}.json
#
# Author: Joshua Bachmeier
#


# Parameters (passed as environment variables)
: ${PLUGIN_TESTER_REPO:="https://github.com/indigo-dc/watts-plugin-tester.git"}
: ${PLUGIN_TESTER_BUILD_DIR:="./plugin-tester"}


setup_plugin_tester() {
    echo '==>' "Obtaining WaTTS plugin tester from $PLUGIN_TESTER_REPO"
    rm -rf $PLUGIN_TESTER_BUILD_DIR
    git clone $PLUGIN_TESTER_REPO $PLUGIN_TESTER_BUILD_DIR || exit

    echo '==>' "Building WaTTS plugin tester"
    pushd $PLUGIN_TESTER_BUILD_DIR || exit
    ./utils/compile.sh || exit
    popd
}

test_plugin() {
    args="test plugin/info.py --plugin-action=$1 --json=$2"

    $PLUGIN_TESTER_BUILD_DIR/watts-plugin-tester $args
}

run_tests() {
    action=$1

    trap 'rm found_at_least_one_input' EXIT

    find test -name "${action}_*.json" \
        | (while read input
           do
               keys=${input%.json}
               keys=${keys#test/${action}_}
               name=${keys%_*}
               expected_result=${keys##*_}

               [[ $expected_result != fail && $expected_result != pass ]] && continue
               touch found_at_least_one_input

               echo '==>' "Running $action test $name with input '$input'"
               echo '==>' "Expecting test $name to $expected_result"


               test_plugin $action $input
               status=$?

               if [[ $status -eq 0 && $expected_result == fail ]]
               then
                   echo '==>' "But test $name passed (should have failed)"
                   exit 1
               elif [[ $status -ne 0 && $expected_result == pass ]]
               then
                   echo '==>' "But test $name failed with exit status $status (should have passed)"
                   exit $status
               else
                   echo '==>' "And test $name did $expected_result (as expected)"
               fi

           done) || exit

    if [[ ! -f found_at_least_one_input ]]
    then
        echo '==>' "No input files found for $action tests"
    fi
}



setup_plugin_tester || exit

run_tests parameter || exit
run_tests request || exit
run_tests revoke || exit
