# Release History

## 1.10.8/1.14.2 Releases

### 2002-04-02: Started at 7:30 AM

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
