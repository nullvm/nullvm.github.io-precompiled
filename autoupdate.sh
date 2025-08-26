#!/bin/bash

rm -r public/*

hugo

cd public
git add .
git commit -m 'auto update performed using script'
git push

cd ..
git add .
git commit -m 'auto update performed using script'
git push
