#!/usr/bin/env zsh

echo utilities/nbunny/**/deps/* itsyscape/Resources/Game/Maps/*/DB/Default.lua | tr " " "\n" > .clocignore
cloc --vcs git --exclude-list-file=.clocignore utilities/nbunny utilities/goober itsyscape cicd 
