#!/bin/bash -x

#
# Initialize RM Environment
#
cd /opt
svn co --depth=immediates https://svn.apache.org/repos/asf/subversion/trunk
svn up --set-depth=infinity trunk/tools
svn up --set-depth=infinity trunk/build
trunk/tools/dist/release.py build-env 1.14.0
trunk/tools/dist/release.py roll 1.14.2 1899108 || true
cp deploy/* ~/

#
# Build and Install Release
#
tar xvzf deploy/subversion-1.14.2.tar.gz
cd subversion-1.14.2
./get-deps.sh
./autogen.sh
./configure --enable-javahl --with-junit=/usr/share/java/junit4.jar \
   --with-jdk=/usr/lib/jvm/default-java --with-ctypesgen=/usr/local/bin/ctypesgen \
   --enable-mod-activation --prefix=/opt/build-svn --with-serf=/usr
   
make -j4 && make javahl && make swig-py && make swig-pl && make swig-rb
sudo make install

#
# Run Tests
#
make check PARALLEL=4
make check-javahl
make check-swig-py
make check-swig-rb
make check-swig-pl
make -svnserveautocheck PARALLEL=4
make davautocheck APACHE_MPM=event PARALLEL=4


