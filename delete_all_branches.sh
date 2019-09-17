#!/bin/bash

git branch -a | grep remotes | sed 's/  remotes\/origin\///' | grep -v master | grep -v develop | xargs -I @ git push origin :@;

git remote prune origin

git branch -a
