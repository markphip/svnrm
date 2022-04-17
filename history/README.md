# Release History

## 1.10.8/1.14.2 Releases

### 2022-04-02: Started at 7:30 AM

* Updated branches make sure there are no more changes.
* Revision number is going to be r1899510
* Build docker and start image to get latest trunk and generate KEYS

```bash
docker-compose build
docker-compose run svnrm bash
```

* Edit the `/opt/trunk/tools/dist/release.py` for location of `KEYS`

```diff
svnrm@61c80612c859:~$ svn diff /opt/trunk
Index: /opt/trunk/tools/dist/release.py
===================================================================
--- /opt/trunk/tools/dist/release.py	(revision 1899510)
+++ /opt/trunk/tools/dist/release.py	(working copy)
@@ -98,7 +98,7 @@
 dist_archive_url = 'https://archive.apache.org/dist/subversion'
 buildbot_repos = os.getenv('SVN_RELEASE_BUILDBOT_REPOS',
                            'https://svn.apache.org/repos/infra/infrastructure/buildbot/aegis/buildmaster')
-KEYS = 'https://people.apache.org/keys/group/subversion.asc'
+KEYS = 'file:///tmp/KEYS'
 extns = ['zip', 'tar.gz', 'tar.bz2']
```
* Begin [1.14.2](1.14.2/README.md) release process
* Begin [1.10.8](1.10.8/README.md) release process

### 2022-04-02: Started around 9:30 AM
* Sign releases
* Create tags
* Post releases
* Send emails to dev@
* Update Issue Tracker with releases

```bash
docker-compose down
```

### 2022-04-10

Came back to post releases to dist and seed the mirrors. This part was sort of simple but I wanted to
also prepare for the release announcement and update staging. This was less simple. All of the problems
were due to the PGP key I generated being the newer format that is not supported everywhere. I could
not use the Docker image because the version of OpenGPG did not like my key, or it could have been
the `release.py` script did not like it. This was eventually all fixed but I found I could just run
all these steps from MacOS which has a newer OpenPGP. I did have to prep my environment by making sure
I had Python 3 installed (which I  did via Homebrew) and then install the `pyyaml` package via `pip3`.

I suspect going forward I could just use the Docker image to produce the tarballs and do all other steps
from MacOS.

```bash
❯ python3 tools/dist/release.py --target ~/projects/svn-release-staging --username markphip move-to-dist 1.10.8
INFO:root:Moving release artifacts to https://dist.apache.org/repos/dist/release/subversion
❯ python3 tools/dist/release.py --target ~/projects/svn-release-staging --username markphip move-to-dist 1.14.2
INFO:root:Moving release artifacts to https://dist.apache.org/repos/dist/release/subversion
> python3 tools/dist/release.py --target ~/projects/svn-release-live write-announcement 1.10.8
> python3 tools/dist/release.py --target ~/projects/svn-release-live write-announcement 1.14.2
```

### 2022-04-27

Cleanup old releases. I waited a week after release was live. This has not been run in a while so the output
here was quite large. Normally it should only remove the previous release.

```bash
❯ python3 tools/dist/release.py --username markphip clean-dist
INFO:root:Saving release '1.10.8'
INFO:root:Saving release '1.14.2'
INFO:root:Removing 'subversion-1.10.6.tar.bz2'
INFO:root:Removing 'subversion-1.10.6.tar.bz2.asc'
INFO:root:Removing 'subversion-1.10.6.tar.bz2.sha1'
INFO:root:Removing 'subversion-1.10.6.tar.bz2.sha512'
INFO:root:Removing 'subversion-1.10.6.tar.gz'
INFO:root:Removing 'subversion-1.10.6.tar.gz.asc'
INFO:root:Removing 'subversion-1.10.6.tar.gz.sha1'
INFO:root:Removing 'subversion-1.10.6.tar.gz.sha512'
INFO:root:Removing 'subversion-1.10.6.zip'
INFO:root:Removing 'subversion-1.10.6.zip.asc'
INFO:root:Removing 'subversion-1.10.6.zip.sha1'
INFO:root:Removing 'subversion-1.10.6.zip.sha512'
INFO:root:Removing 'subversion-1.10.7.KEYS'
INFO:root:Removing 'subversion-1.10.7.tar.bz2'
INFO:root:Removing 'subversion-1.10.7.tar.bz2.asc'
INFO:root:Removing 'subversion-1.10.7.tar.bz2.sha1'
INFO:root:Removing 'subversion-1.10.7.tar.bz2.sha512'
INFO:root:Removing 'subversion-1.10.7.tar.gz'
INFO:root:Removing 'subversion-1.10.7.tar.gz.asc'
INFO:root:Removing 'subversion-1.10.7.tar.gz.sha1'
INFO:root:Removing 'subversion-1.10.7.tar.gz.sha512'
INFO:root:Removing 'subversion-1.10.7.zip'
INFO:root:Removing 'subversion-1.10.7.zip.asc'
INFO:root:Removing 'subversion-1.10.7.zip.sha1'
INFO:root:Removing 'subversion-1.10.7.zip.sha512'
INFO:root:Removing 'subversion-1.14.0.KEYS'
INFO:root:Removing 'subversion-1.14.0.tar.bz2'
INFO:root:Removing 'subversion-1.14.0.tar.bz2.asc'
INFO:root:Removing 'subversion-1.14.0.tar.bz2.sha512'
INFO:root:Removing 'subversion-1.14.0.tar.gz'
INFO:root:Removing 'subversion-1.14.0.tar.gz.asc'
INFO:root:Removing 'subversion-1.14.0.tar.gz.sha512'
INFO:root:Removing 'subversion-1.14.0.zip'
INFO:root:Removing 'subversion-1.14.0.zip.asc'
INFO:root:Removing 'subversion-1.14.0.zip.sha512'
INFO:root:Removing 'subversion-1.14.1.KEYS'
INFO:root:Removing 'subversion-1.14.1.tar.bz2'
INFO:root:Removing 'subversion-1.14.1.tar.bz2.asc'
INFO:root:Removing 'subversion-1.14.1.tar.bz2.sha512'
INFO:root:Removing 'subversion-1.14.1.tar.gz'
INFO:root:Removing 'subversion-1.14.1.tar.gz.asc'
INFO:root:Removing 'subversion-1.14.1.tar.gz.sha512'
INFO:root:Removing 'subversion-1.14.1.zip'
INFO:root:Removing 'subversion-1.14.1.zip.asc'
INFO:root:Removing 'subversion-1.14.1.zip.sha512'
```
