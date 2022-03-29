# SVN Release Management

This repository contains the base `Dockerfile` for creating a Dockerized
environment for running the SVN [Release Management](https://subversion.apache.org/docs/community-guide/releasing.html#release-creating)
process in Docker. The SVN RM process requires a Linux environment, so
doing this with Docker allows someone to run the process on MacOS or Windows.
It is also a convenient way to run it on Linux as it is a much more "clean room"
environment where the dependencies can be easily maintained.

## Docker Information

I am using a Debian Buster-slim as the base image. This is because I wanted to have
a native Python 2.x environment so that I can build older SVN releases. Once
we are only building SVN 1.14+ then we could move to Bullseye or newer base.

The `Dockerfile` installs the packages needed for the RM process as well as packages
needed to build SVN. My original plan was to do the builds in this Docker environment
too. That does work, but I decided to only do the RM process in Docker and then copy
the release tarballs to an Azure VM to run the tests. This allows me to run the process
faster and without tying up my local machine. The other issue is that Docker with a
mounted file system on MacOS and Windows can be a bit slow and even flaky.

The point is only that we could slim down the installed packages if we never wanted to
run a build in this container. For now, since that works, I have decided to leave it in
place.

## Docker Compose

I am using Docker Compose (`docker-compose.yml`) for personal preference. I am mounting a
local folder into the container at runtime so that the release tarballs are available
to my host operating system. I find it easier to declare volume mounts in a compose file
then have to always specify them on the docker command line.

## Build

To build the image just run the command `docker-compose build`. This installs all of the
dependencies, creates a `svnrm` user and also initializes the SVN RM tools for 1.10 and 1.14.
In testing the process, I found it was more stable to build this environment as a layer within
the container and then use the `release.py` options to direct the output of the RM process to
the home folder that I have mounted locally. Since the svn `/trunk` folder is checked out by
this process, it is just important to force a new build at the beginning the the RM cycle to
ensure the latest version of the RM tools are included inside the Docker image.

## Run the RM Process

To run the RM tools just run the command `docker-compose run svnrm bash`. This will run the container
and open to a bash prompt. You can then run the SVN `release.py` script within the container. As an
example:

```bash
/opt/trunk/tools/dist/release.py --base-dir /opt/svnrm/1.10 --target ~/deploy-1.10  roll 1.10.8 1899349 
```

The `--base-dir` and `--target` options are important. The former points the script at the RM environment
that was provisioned in the container image and the latter directs the release output to the home folder
so that the release artifacts are saved in the host operating system.

## Testing the Release

After generating the release artifacts, in the host operating system I upload them to an Azure VM I have
configured with Debian Buster and the build dependencies pre-installed. The process looks something
like this:

```bash
# Transfer tarballs to Azure and connect
scp -i ~/.ssh/xxx.pem mount/deploy-1.10/subversion-1.10.8.tar.gz xxx@xxx.xxx.xxx.xxx:~
scp -i ~/.ssh/xxx.pem mount/deploy-1.10/subversion-1.10.8.tar.gz.sha512 xxx@xxx.xxx.xxx.xxx:~
ssh -i ~/.ssh/xxx.pem xxx@xxx.xxx.xxx.xxx

# On Azure, verify tarball sha512, extract and cd
openssl sha512 subversion-1.10.8.tar.gz
tar xzf subversion-1.10.8.tar.gz
cd subversion-1.10.8
nohup bash -c "(time ~/svnrm/scripts/build-1.10.sh > ~/build-1.10.out) &> ~/time_n_err-1.10.out" &
```

At this point I can disconnect and move on to the next release. I just need to wait for tests to
finish and inspect the log output for problems.

## Signing the Release

I have not figured out how to mount my GPG key inside the container so I have to sign the release
in the host operating system. I anticipate being able to just re-run the container to run the
rest of the process such as creating tags, posting releases etc.

## GitHub Build

I tried to run the process via GitHub Actions. It did not fully work and was too slow. That is
what gave me the idea to just run an Azure VM. This let me provision a system with 8 cores so
I can run the tests quickly. I have enough montly credits to easily cover the cost. It takes
less than a couple dollars to start the VM, run the tests and stop it. I can run the
tests for multiple releases concurrently on the same VM without problem.



