#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR/..

zokrates compile --gadgets=sha256 -i zokrates/confidentx.code -o confidentx.out --light --optimized

cp zokrates/*.key .
#zokrates setup -i confidentx.out
#zokrates export-verifier

#zokrates generate-proof -w confidentx.witness

cargo run --bin api
