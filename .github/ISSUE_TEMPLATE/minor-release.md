---
name: Minor release
about: Create a new X.Y.0 release
title: Produce release for Subversion X.Y.0
labels: ''
assignees: ''

---

Canonical source of information for producing a release is in [HACKING](https://subversion.apache.org/docs/community-guide/releasing.html#release-creating)

## Press Release
- [ ] Coordinate with Apache press@a.o

## Prepare to do a Release
- [ ] Prepare build environment
- [ ] Prepare Azure VM for running tests
- [ ] Do a test build on branch and run tests
- [ ] Announce plans to do release with community
- [ ] Finalize all backports

## Producing the Release Candidate
- [ ] Prepare CHANGES
- [ ] Produce the release tarballs
- [ ] Run and verify all tests
- [ ] Sign the release
- [ ] Create release tag
- [ ] Post the candidates
- [ ] Announce the candidates on dev@
- [ ] Update the issue tracker to add new releases

Wait for signatures to come in. Require three +1 votes with at least one for each Windows and Unix.

## Publish the Release

- [ ] Update dist (publish to mirrors)

Wait at least 24 hours for Mirrors to Sync

## Update Website

- [ ] Submit the version number to [reporter.apache.org](https://reporter.apache.org/addrelease.html?subversion)
- [ ] Edit downloads list
- [ ] Add news item
- [ ] List the release in `doap.rdf`
- [ ] List the release in release history
- [ ] Update supported versions
- [ ] Updated `supported_release_lines` in `release.py`
- [ ] Finalize release notes (remove draft warning)
- [ ] Create or update versioned documentation
- [ ] Publish website with all changes

## Announce the Release

- [ ] Send release announcement from @apache.org email address
- [ ] Update the news items with links to announcement
- [ ] Update supported versions in `STATUS` files
