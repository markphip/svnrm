# Transcript of 1.10.8 Release Process

## Run in the Docker Image
```bash
$ /opt/trunk/tools/dist/release.py --base-dir /opt/svnrm/1.10 --target ~/deploy-1.10  roll 1.10.8 1899510 
INFO:root:Rolling release 1.10.8 from branch branches/1.10.x@1899510
WARNING:root:CHANGES has unmerged revisions: r1899487 
INFO:root:Preparing working copy source
INFO:root:Building Windows tarballs
INFO:root:Building Unix tarballs
INFO:root:Moving artifacts and calculating checksums
```

## Copy files to AzureVM
```bash
$ scp -i ~/.ssh/xxx.pem mount/deploy-1.10/subversion-1.10.8.tar.gz xxx@xxx.xxx.xxx.xxx:~
$ scp -i ~/.ssh/xxx.pem mount/deploy-1.10/subversion-1.10.8.tar.gz.sha512 xxx@xxx.xxx.xxx.xxx:~
```

## Run on AzureVM
```bash
$ openssl sha512 subversion-1.10.8.tar.gz
SHA512(subversion-1.10.8.tar.gz)= 9ab75f22078520d31d4c06bf619fce96763e40cf91f988853b7415e6782cd2237338cf8ec4ee4170da45a70913479ec94440015b7bbc56a4bb32e23bfad4449c
$ cat subversion-1.10.8.tar.gz.sha512 
9ab75f22078520d31d4c06bf619fce96763e40cf91f988853b7415e6782cd2237338cf8ec4ee4170da45a70913479ec94440015b7bbc56a4bb32e23bfad4449c
$ tar xvf subversion-1.10.8.tar.gz
$ cd subversion-1.10.8
$ nohup bash -c "(time ~/svnrm/scripts/build-1.10.sh > ~/build-1.10.out) &> ~/time_n_err-1.10.out" &
```

Wait 60-90 minutes for build and test to finish

## Run on MacOS

Get the logs and verify no test or build failures

```bash
$ scp -i ~/.ssh/xxx.pem xxx@xxx.xxx.xxx.xxx:~/build-1.10.out history/1.10.8
$ scp -i ~/.ssh/xxx.pem xxx@xxx.xxx.xxx.xxx:~/time_n_err-1.10.out history/1.10.8
```
Note that there was 1 Ruby test failure. It looks like it has to do with both test suites running at the same time so I 
logged back in to Azure and re-ran the Ruby tests. This confirmed that they are **OK**

```bash
~/subversion-1.10.8$ make check-swig-rb
if [ "LD_LIBRARY_PATH" = "DYLD_LIBRARY_PATH" ]; then for d in /home/markphip/subversion-1.10.8/subversion/bindings/swig/ruby/libsvn_swig_ruby /home/markphip/subversion-1.10.8/subversion/bindings/swig/ruby/../../../libsvn_*; do if [ -n "$DYLD_LIBRARY_PATH" ]; then LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$d/.libs"; else LD_LIBRARY_PATH="$d/.libs"; fi; done; export LD_LIBRARY_PATH; fi; \
cd /home/markphip/subversion-1.10.8/subversion/bindings/swig/ruby; \
  check_rb() { \
    /usr/bin/ruby -I /home/markphip/subversion-1.10.8/subversion/bindings/swig/ruby /home/markphip/subversion-1.10.8/subversion/bindings/swig/ruby/test/run-test.rb "$@"; \
  }; \
  if check_rb --help 2>&1 | grep -q -- --collector; then \
    check_rb --collector=dir --verbose=normal; \
  elif [ "2" -eq 1 -a "5" -lt 9 ] ; then \
    check_rb --verbose=normal; \
  else \
    check_rb; \
          fi
Loaded suite .
Started
..........................................................................................
..........................................................................................
.........................................
Finished in 114.651535731 seconds.
------------------------------------------------------------------------------------------
221 tests, 5544 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
100% passed
------------------------------------------------------------------------------------------
1.93 tests/s, 48.36 assertions/s
```

### Sign the Release

```bash
$ gpg -ba mount/deploy-1.10/subversion-1.10.8.tar.bz2
$ gpg -ba mount/deploy-1.10/subversion-1.10.8.tar.gz
$ gpg -ba mount/deploy-1.10/subversion-1.10.8.zip
```
## Run in Docker Image

```bash
$ /opt/trunk/tools/dist/release.py --base-dir /opt/svnrm/1.10 --target ~/deploy-1.10 --username markphip create-tag 1.10.8 1899510
INFO:root:Creating tag for 1.10.8
Authentication realm: <https://svn.apache.org:443> ASF Committers
Password for 'markphip': ********


-----------------------------------------------------------------------
ATTENTION!  Your password for authentication realm:

   <https://svn.apache.org:443> ASF Committers

can only be stored to disk unencrypted!  You are advised to configure
your system so that Subversion can store passwords encrypted, if
possible.  See the documentation for details.

You can avoid future appearances of this warning by setting the value
of the 'store-plaintext-passwords' option to either 'yes' or 'no' in
'(null)'.
-----------------------------------------------------------------------
Store password unencrypted (yes/no)? yes
INFO:root:Bumping version numbers on the branch
Traceback (most recent call last):
  File "/opt/trunk/tools/dist/release.py", line 1916, in <module>
    main()
  File "/opt/trunk/tools/dist/release.py", line 1912, in main
    args.func(args)
  File "/opt/trunk/tools/dist/release.py", line 1134, in create_tag_and_bump_versions
    bump_versions_on_branch(args)
  File "/opt/trunk/tools/dist/release.py", line 1106, in bump_versions_on_branch
    svn_version_h = file_object_for('subversion/include/svn_version.h')
  File "/opt/trunk/tools/dist/release.py", line 1099, in file_object_for
    fd = tempfile.NamedTemporaryFile(mode='w+', encoding='UTF-8')
TypeError: NamedTemporaryFile() got an unexpected keyword argument 'encoding'

$ /opt/trunk/tools/dist/release.py --base-dir /opt/svnrm/1.10 --target ~/deploy-1.10 --username markphip post-candidates 1.10.8
INFO:root:Importing tarballs to https://dist.apache.org/repos/dist/dev/subversion
Authentication realm: <https://dist.apache.org:443> ASF Committers
Password for 'markphip': ********


-----------------------------------------------------------------------
ATTENTION!  Your password for authentication realm:

   <https://dist.apache.org:443> ASF Committers

can only be stored to disk unencrypted!  You are advised to configure
your system so that Subversion can store passwords encrypted, if
possible.  See the documentation for details.

You can avoid future appearances of this warning by setting the value
of the 'store-plaintext-passwords' option to either 'yes' or 'no' in
'/home/svnrm/.subversion/servers'.
-----------------------------------------------------------------------
Store password unencrypted (yes/no)? yes
```

