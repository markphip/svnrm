#!/bin/bash -x

#
# Initialize RM Environment
#
cd ~
svn co --depth=immediates https://svn.apache.org/repos/asf/subversion/trunk
svn up --set-depth=infinity trunk/tools
svn up --set-depth=infinity trunk/build