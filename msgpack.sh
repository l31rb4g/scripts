#!/bin/bash

tmpfile='/tmp/msgpack'

echo '' > $tmpfile
vim $tmpfile
cat $tmpfile | base64 -d | msgpack2json -p

