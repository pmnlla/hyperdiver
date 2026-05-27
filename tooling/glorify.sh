#!/bin/bash

if [ "$1" == "alert" ]; then
    gum log --time timeonly --level $2 $3;
fi