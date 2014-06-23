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
    echo "$0 Signaling success to parent: $PPID"
    kill -s SIGCONT $PPID  #`pgrep -f example.py`
}

# Send failure signal to other process by name
function signal_failure() {
    echo "$0 Signaling failure to parent: $PPID"
    kill -s SIGUSR2 $PPID #`pgrep -f example.py`
}


# Exit on failure function
function exit_on_fail {
    echo "$0 Last command did not execute successfully but is required!" >&2
    echo "$0 [$( caller )] $*"
    echo "$0 BASH_SOURCE: ${BASH_SOURCE[*]}"
    echo "$0 BASH_LINENO: ${BASH_LINENO[*]}"
    echo "$0 FUNCNAME: ${FUNCNAME[*]}"
    echo "$0 Exiting and rolling back all changes!" >&2
    # Tell deployment process about the error
    signal_failure 'deploy.py'
    exit 1
}


# Traps for cleaning up on exit
# Originally from http://www.linuxjournal.com/content/use-bash-trap-statement-cleanup-temporary-files
declare -a on_sig_items

function on_exit() {
    echo "$0 Received SIGEXIT, Cleaning up: $i"
    for i in "${on_sig_items[@]}"; do
	echo "$0 Executing cleanup statement: $i"
      	eval $i
    done
}

function on_break() {
    echo "$0 Signal receied, unexpected exit"
    for i in "${on_sig_items[@]}"; do
        echo "$0 Executing cleanup statement: $i"
        eval $i
    done
}

function add_on_sig() {
    local n=${#on_sig_items[*]}
    on_sig_items[$n]="$*"
    if [[ $n -eq 0 ]]; then
        echo "$0 Setting up signal trap"
        #trap on_exit EXIT
	trap on_break INT QUIT TERM
    fi
}

echo "$0 Sleeping for 10 seconds then signaling success"
echo "$0 SIGINT passed to PID $$ will be passed on as a fail"
add_on_sig signal_failure 'example.py'
sleep 10
signal_success 'example.py'
