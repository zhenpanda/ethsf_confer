#! env /bin/bash

zokrates compile --gadgets=sha256 -i zokrates/confidentx.code -o confidentx.out --light --optimized

zokrates setup -i confidentx.out
zokrates export-verifier

#zokrates generate-proof -w confidentx.witness

cd api
cargo run
