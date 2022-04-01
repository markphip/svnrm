#!/bin/bash -x

#
# Initialize RM Environment
#
export BASE=/opt/svnrm
cd /opt
svn co --depth=immediates https://svn.apache.org/repos/asf/subversion/trunk
svn up --set-depth=infinity trunk/tools
svn up --set-depth=infinity trunk/build

mkdir -p $BASE/1.10
trunk/tools/dist/release.py --base-dir $BASE/1.10 --target ~/deploy-1.10 build-env 1.10.0
mkdir -p $BASE/1.14
trunk/tools/dist/release.py --base-dir $BASE/1.14 --target ~/deploy-1.14 build-env 1.14.0

# Create KEYS
cd trunk
/opt/scripts/make-keys.sh
cp KEYS /tmp