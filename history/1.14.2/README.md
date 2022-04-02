# Transcript of 1.14.2 Release Process

## Run in the Docker Image

```bash
$ /opt/trunk/tools/dist/release.py --base-dir /opt/svnrm/1.14 --target ~/deploy-1.14  roll 1.14.2 1899510 
INFO:root:Rolling release 1.14.2 from branch branches/1.14.x@1899510
INFO:root:Preparing working copy source
INFO:root:Building Windows tarballs
../svnadmin/svnadmin.c:2935: warning: Although being used in a format string position, the msgid is not a valid C format string. Reason: The string ends in the middle of a directive.
INFO:root:Building Unix tarballs
INFO:root:Moving artifacts and calculating checksums
```

## Copy files to AzureVM from MacOS

```bash
scp -i ~/.ssh/xxx.pem mount/deploy-1.10/subversion-1.10.8.tar.gz xxx@xxx.xxx.xxx.xxx:~
scp -i ~/.ssh/xxx.pem mount/deploy-1.10/subversion-1.10.8.tar.gz.sha512 xxx@xxx.xxx.xxx.xxx:~
```

## Run on AzureVM

```bash
$ openssl sha512 subversion-1.14.2.tar.gz
SHA512(subversion-1.14.2.tar.gz)= 053d9d38f675f5ddd6ad9c6bd061482f5e9ec9f0cb8ea6db76a91e0646af26dfdab2a882d09395df4e073d704be909160c230251957f86a452d32408da6d7468
$ cat subversion-1.14.2.tar.gz.sha512 
053d9d38f675f5ddd6ad9c6bd061482f5e9ec9f0cb8ea6db76a91e0646af26dfdab2a882d09395df4e073d704be909160c230251957f86a452d32408da6d7468
$ tar xvf subversion-1.14.2.tar.gz
$ cd subversion-1.14.2
$ nohup bash -c "(time ~/svnrm/scripts/build-1.14.sh > ~/build-1.14.out) &> ~/time_n_err-1.14.out" &
```

Wait 60-90 minutes for build and test to finish

## Run on MacOS

Get the logs and verify no test or build failures

```bash
scp -i ~/.ssh/xxx.pem xxx@xxx.xxx.xxx.xxx:~/build-1.14.out history/1.14.2
scp -i ~/.ssh/xxx.pem xxx@xxx.xxx.xxx.xxx:~/time_n_err-1.14.out history/1.14.2
```

### Sign the Release

```bash
$ gpg -ba mount/deploy-1.14/subversion-1.14.2.tar.bz2
$ gpg -ba mount/deploy-1.14/subversion-1.14.2.tar.gz
$ gpg -ba mount/deploy-1.14/subversion-1.14.2.zip
```
## Run in Docker Image

```bash
$ /opt/trunk/tools/dist/release.py --base-dir /opt/svnrm/1.14 --target ~/deploy-1.14 --username markphip create-tag 1.14.2 1899510
INFO:root:Creating tag for 1.14.2
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

$ /opt/trunk/tools/dist/release.py --base-dir /opt/svnrm/1.14 --target ~/deploy-1.14 --username markphip post-candidates 1.14.2
INFO:root:Importing tarballs to https://dist.apache.org/repos/dist/dev/subversion
```

