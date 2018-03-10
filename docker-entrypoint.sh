#!/bin/bash

if [ "$1" = 'apply' ] || [ "$1" = 'destroy' ] || [ "$1" = 'plan' ] || [ "$1" = 'output' ]; then
        if [ -z "$2" ]; then
                cd $TF_VAR_xk_live_dir && terragrunt $1-all 2>&1 | grep -v 'terragrunt'
        else
                cd $2 && terragrunt $1-all
        fi

elif [ "$1" = 'up' ]; then
        if [ -z "$2" ]; then
                cd $TF_VAR_xk_live_dir && terragrunt apply-all
        else
                cd $2 && terragrunt apply-all 2>&1 | grep -v 'terragrunt'
        fi

elif [ "$1" = 'down' ]; then
        if [ -z "$2" ]; then
                cd $TF_VAR_xk_live_dir && terragrunt destroy-all
        else
                cd $2 && terragrunt destroy-all 2>&1 | grep -v 'terragrunt'
        fi

elif [ "$1" = 'init' ]; then
        cd $2 && terragrunt $1

else
        $@
fi
