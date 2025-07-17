#!/usr/bin/env bash

declare -A toolchains
@toolchains@

toolchain_name=default

if [[ "$1" == +* ]]
then
    toolchain_name="${1:1}"
    shift
fi

toolchain=${toolchains[$toolchain_name]}

PATH="$toolchain/bin:$PATH" \
    "${toolchains[$toolchain_name]}/bin/$(basename $0)" \
    "$@"
