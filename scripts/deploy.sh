#!/bin/bash

cd public
git add --all
git commit -m 'Publish to gh-pages'
git push origin gh-pages
