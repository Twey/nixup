#!/usr/bin/env bash

declare -A toolchains
@toolchains@

toolchain_name="${RUST_TOOLCHAIN-default}"

if [[ "$1" == +* ]]
then
    toolchain_name="${1:1}"
    shift
fi

toolchain=${toolchains[$toolchain_name]-}

if [ -z "$toolchain" ]
then
    >&2 echo "nixup: unknown toolchain \`${toolchain_name}\`"
    exit 1
fi

PATH="$toolchain/bin:$PATH" \
    "${toolchains[$toolchain_name]}/bin/$(basename $0)" \
    "$@"
