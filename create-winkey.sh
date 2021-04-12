#!/usr/bin/env bash

ssh-keygen -N "" -t rsa -b 4096 -C "splice_windows@splicemachine.com" -f winkey
ssh-keygen -p -N "" -m pem -f winkey

cp winkey* aws/
cp winkey* gcp/

