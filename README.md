# rehan-autorestic

[![Puppet Forge](http://img.shields.io/puppetforge/v/rehan/autorestic.svg)](https://forge.puppetlabs.com/rehan/autorestic) [![Build Status](https://travis-ci.com/rehanone/puppet-autorestic.svg?branch=master)](https://travis-ci.com/rehanone/puppet-autorestic)

#### Table of Contents
1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
    * [Classes](#classes)
5. [Dependencies](#dependencies)
6. [Development](#development)

## Overview
The `rehan-autorestic` installs & manages `autorestic` and `restic`,  tools to back up and restore data to various local and cloud storage solutions. More information can be found on their respective sites.

  - [restic](https://restic.net/)
  - [autorestic](https://autorestic.vercel.app/)

## Module Description

This module can create/manage a new user account for backup and restore using `autorestic` for scripting the backup locations and backends.
It can install system-wide and restricted copies of `restic` binary with file read capability that allows `autorestic` user to back up read all system files without `root` access.

More information on this can be found at:

  - [Backing up your system without running restic as root](https://restic.readthedocs.io/en/stable/080_examples.html#backing-up-your-system-without-running-restic-as-root)

## Setup
In order to install `rehan-autorestic`, run the following command:
```bash
$ puppet module install rehan-autorestic
```
The module does expect all the data to be provided through 'Hiera'. See [Usage](#usage) for examples on how to configure it.

## Usage

### Classes

#### `autorestic`

A basic install with the defaults would be:
```puppet
include autorestic
```

And the default hiera settings are:
```yaml
autorestic::account_manage: true
autorestic::account_ensure: present
autorestic::account_name: 'autorestic'
autorestic::account_gid: '990'
autorestic::account_uid: '990'
autorestic::account_home: '/var/lib/autorestic'
autorestic::account_groups: []

autorestic::dependencies_manage: true
autorestic::dependencies_packages:
   - bzip2

autorestic::architecture: "%{facts.os.architecture}"
autorestic::os_type: 'linux'

autorestic::restic_ensure: present
autorestic::restic_version: '0.12.1'
autorestic::restic_download_file_extension: "bz2"
autorestic::restic_download_filename: "restic_%{lookup('autorestic::restic_version')}_%{lookup('autorestic::os_type')}_%{lookup('autorestic::architecture')}"
autorestic::restic_download_url: "https://github.com/restic/restic/releases/download/v%{lookup('autorestic::restic_version')}/%{lookup('autorestic::restic_download_filename')}.%{lookup('autorestic::restic_download_file_extension')}"
autorestic::restic_checksum: '11d6ee35ec73058dae73d31d9cd17fe79661090abeb034ec6e13e3c69a4e7088'
autorestic::restic_checksum_type: sha256
autorestic::restic_global_install_directory: '/opt/restic'
autorestic::restic_global_install_ensure: absent

autorestic::autorestic_ensure: present
autorestic::autorestic_version: '1.5.0'
autorestic::autorestic_download_file_extension: "bz2"
autorestic::autorestic_download_filename: "autorestic_%{lookup('autorestic::autorestic_version')}_%{lookup('autorestic::os_type')}_%{lookup('autorestic::architecture')}"
autorestic::autorestic_download_url: "https://github.com/cupcakearmy/autorestic/releases/download/v%{lookup('autorestic::autorestic_version')}/%{lookup('autorestic::autorestic_download_filename')}.%{lookup('autorestic::autorestic_download_file_extension')}"
autorestic::autorestic_checksum: '823c4b766f289d5d1a40fea52a6f4f1fbd4071ca6e57c74b88e57e0649cbaeaf'
autorestic::autorestic_checksum_type: sha256
autorestic::autorestic_install_directory: '/opt/autorestic'

autorestic::wrapper_user: "%{lookup('autorestic::account_name')}"
```


## Dependencies

* [stdlib][1]
* [archive][2]
* [file_capability][3]

[1]:https://forge.puppet.com/modules/puppetlabs/stdlib
[2]:https://forge.puppet.com/modules/puppet/archive
[3]:https://forge.puppet.com/modules/stm/file_capability

## Development

You can submit pull requests and create issues through the official page of this module: https://github.com/rehan/puppet-autorestic.
Please do report any bug and suggest new features/improvements.
