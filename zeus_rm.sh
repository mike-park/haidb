#!/bin/sh
base="/Applications/RubyMine EAP.app/rb/testing/patch"
exec env RUBYLIB="${base}/common:${base}/bdd" zeus start
