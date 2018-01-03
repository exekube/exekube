#!/bin/bash

if [ "$1" = 'apply' ] || [ "$1" = 'destroy' ] || [ "$1" = 'plan' ] || [ "$1" = 'output' ]; then
        if [ -z "$2" ]; then
                cd $XK_LIVE_DIR && terragrunt $1-all
        else
                cd $2 && terragrunt $1
        fi
else
        $@
fi
