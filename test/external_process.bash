#!/bin/bash

# The MIT License (MIT)

# Copyright (c) 2014 SDElements

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Send success signal to other process by name
function signal_success() {
    kill -s SIGCONT `pgrep -f $1`
}

# Send failure signal to other process by name
function signal_failure() {
    kill -s SIGUSR2  `pgrep -f $1`
}


# Exit on failure function
function exit_on_fail {
    color_echo red "Last command did not execute successfully but is required!" >&2
    debug 10 "[$( caller )] $*"
    debug 10 "BASH_SOURCE: ${BASH_SOURCE[*]}"
    debug 10 "BASH_LINENO: ${BASH_LINENO[*]}"
    debug 0  "FUNCNAME: ${FUNCNAME[*]}"
    color_echo red "Exiting and rolling back all changes!" >&2
    # Tell deployment process about the error
    signal_failure 'deploy.py'
    exit 1
}


# Traps for cleaning up on exit
# Originally from http://www.linuxjournal.com/content/use-bash-trap-statement-cleanup-temporary-files
declare -a on_sig_items

function on_exit() {
    debug 10 "Received SIGEXIT, Cleaning up: $i"
    for i in "${on_sig_items[@]}"; do
	debug 10 "Executing cleanup statement: $i"
      	eval $i
    done
}

function on_break() {
    color_echo red "Signal receied, unexpected exit"
    for i in "${on_sig_items[@]}"; do
        color_echo red "Executing cleanup statement: $i"
        eval $i
    done
}

function add_on_sig() {
    local n=${#on_sig_items[*]}
    on_sig_items[$n]="$*"
    if [[ $n -eq 0 ]]; then
        debug 10 "Setting up signal trap"
        trap on_exit EXIT
	trap on_break INT QUIT TERM
    fi
}

echo "$0 Sleeping for 10 seconds then signaling sucess"
echo "CTRL-C and SIGEXIT will be passed on as a fail"
add_on_sig signal_failure 'example.py'
sleep 10
signal_success 'example.py'
exit 0
