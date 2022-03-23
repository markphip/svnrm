#!/bin/sh
cd /opt/subversion-1.14.2
make check PARALLEL=4
make check-javahl
make check-swig-py
make check-swig-rb
make check-swig-pl
make -svnserveautocheck PARALLEL=4
make davautocheck APACHE_MPM=event PARALLEL=4

