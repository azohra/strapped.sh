![logo](https://raw.githubusercontent.com/azohra/strapped/master/_static/img/logo-black.png)

[![Build Status](https://travis-ci.org/azohra/strapped.sh.svg?branch=master)](https://travis-ci.org/azohra/strapped.sh)![License](https://img.shields.io/github/license/azohra/strapped.sh.svg)![Issues](https://img.shields.io/github/issues/azohra/strapped.sh.svg)

---

# Introduction

Strapped.sh aims to be a universal platform for computer configuration management. Written purely in Bash
and having no physical dependancies, Strapped.sh maintains a minimal footprint by operating as a SaaS which remotely
sources the files it needs on demand.

At a high level view, Strapped.sh acts as a console command orchestrator. These commands are implemented by something we
call `straps`. Simply write a `yml` configuration file containing any number of these straps and let Strapped.sh do the rest.

An example of a full computer configuration file can be seen [here](https://gist.github.com/MatthewNielsen27/92b7c99e8c5b6632e977539110301def).

🔫 #StayStrapped

# Installation

To install strapped.sh, simply run this command:

```console
curl -s https://stay.strapped.sh | sh
```

Upgrading strapped.sh can be done by re-running the installation command above or in the following way:

```console
strapped --upgrade
```

Here are all the command-line flags for strapped.sh (if that's your thing):

```console
Usage: strapped [flags]

flags:
  -u, --upgrade                  upgrade strapped to the latest version
  -v, --version                  print the current strapped version
  -a, --auto                     do not prompt for confirmation
  -y, --yml                      path to a valid strapped yml config [type: file path or url]
  -s, --straps                   run a subset of your config. Comma seperated
  -h, --help                     prints this message
```

# Usage

To strap your computer, simply run strapped and point to your strap config file with the `-y` or `--yml` flag

```console
strapped -y my_config.yml
```

You can even pass the URL to a remotely stored config file!

```console
strapped -y https://www.example.com/my_config.yml
```

## About Configuration Files

Configuration files are used as a blueprint for your computer's configuration. These files are composed of various `straps`
which each serve different purposes. Straps themselves are implemented by `routines` that form the functionality of the strap.

Lets take a look at a config file:

```yaml
# You must specify the repo that strapped.sh will source its straps from
# this can be in the form of a URL or a link to a local repo.
# By default, straps will be sourced from this repository, but you can link
# strapped to any repo that implements strapped functionality.
strapped:
  repo: https://raw.githubusercontent.com/azohra/strapped/master/straps

# Use the brew strap (specifically v0.1.0) to tap taps and install packages and casks
brew:
  version: v0.1.0
  # Tap routine
  taps:
    - { name: homebrew/core }
  # Packages routine
  packages:
    - { name: terraform }
  # Casks routine
  casks:
    - { name: visual-studio-code }

# Use the git strap to clone repos into a specific directory.
# Since we have not specified a strap version it will search for the 
# latest version in the globally specified strapped repo
git:
  clone:
    - { repo: git@github.com:kelseyhightower/nocode.git, folder: ~/repos }

# Install vscode extensions using latest version of the visual_studio_code strap
visual_studio_code:
  extensions:
    - { name: PKief.material-icon-theme }
```

The complete list of straps and their usage can be found [here](https://docs.strapped.sh/#/).

# Contributing

We are open to anyone contributing to this repo. Please ensure you follow the [code of conduct](https://github.com/azohra/strapped.sh/blob/master/CODE_OF_CONDUCT.md).

If you wish to contribute and don't know where to start, check out the [issues](https://github.com/azohra/strapped.sh/issues)
section for inspiration.

<!-- ### Using the compiler to generate new straps -->

# License

Strapped.sh is licensed under the [MIT](https://github.com/azohra/strapped.sh/blob/master/LICENSE) license.

---

Made with :heart: by Azohra