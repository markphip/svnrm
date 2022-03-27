#!/bin/bash -x

#
# Initialize RM Environment
#
cd ~
trunk/tools/dist/release.py build-env 1.10.0
trunk/tools/dist/release.py roll 1.10.8 1899108 || true

#
# Build and Install Release
#
tar xvzf deploy/subversion-1.10.8.tar.gz
cd subversion-1.10.8
./get-deps.sh
./autogen.sh
./configure --enable-javahl --with-junit=/usr/share/java/junit4.jar \
    --with-jdk=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64 --with-ctypesgen=/usr/local/bin/ctypesgen \
    --enable-mod-activation --prefix=/opt/build-svn --with-serf=/usr

make -j8
make javahl
make swig-py
make swig-pl
make swig-rb
sudo make install

#
# Run Tests
#
make check PARALLEL=8
make check-javahl
make check-swig-py
make check-swig-rb
make check-swig-pl
make svnserveautocheck PARALLEL=8
make davautocheck APACHE_MPM=event PARALLEL=8
