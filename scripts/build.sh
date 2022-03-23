#!/bin/sh
cd /opt
tar xvzf ~/deploy/subversion-1.14.2.tar.gz
cd subversion-1.14.2
./get-deps.sh
./autogen.sh
./configure --enable-javahl --with-junit=/usr/share/java/junit4.jar \
   --with-jdk=/usr/lib/jvm/default-java --with-ctypesgen=/usr/local/bin/ctypesgen \
   --enable-mod-activation --prefix=/opt/build-svn --with-serf=/usr
   
make -j4 && make javahl && make swig-py && make swig-pl && make swig-rb
sudo make install

