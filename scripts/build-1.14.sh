#!/bin/bash -x

cd ~

#
# Build and Install Release
#
tar xvzf subversion-1.14.2.tar.gz
cd subversion-1.14.2
./get-deps.sh
./autogen.sh
./configure --enable-javahl --with-junit=/usr/share/java/junit4.jar \
    --with-jdk=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64 --with-ctypesgen=/usr/local/bin/ctypesgen \
    --enable-mod-activation --prefix=/opt/build-svn-1.14 --with-serf=/usr --enable-shared

make -j8
make -j8 javahl
make -j8 swig-py
make -j8 swig-pl
make -j8 swig-rb
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

# Test the installed build
/opt/build-svn-1.14/bin/svn --version --verbose
/opt/build-svn-1.14/bin/svn co https://svn.apache.org/repos/asf/subversion/trunk --depth=immediates /tmp/trunk-1.14

