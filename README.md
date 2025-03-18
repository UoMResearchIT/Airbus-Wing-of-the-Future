# Galaxy Show and Tell

This repository serves as an example for RSEs to self host Galaxy. The repository contains a `docker-compose.yml` file that can be used to start a Galaxy instance with a few tools pre-installed.

Some guides are given below to help you get started!

If you are interested in some context for this repo some slides [are available](https://uomresearchit.github.io/Galaxy-Show-And-Tell/).

## Tutorials

[Tutorial: From bootstrap to workflows! Getting started with Galaxy](docs/getting-started.md)

## How to guides

[How to: Add tools to your Galaxy](docs/add-tools.md)

[How to: Add public workflows your Galaxy](docs/add-workflows.md)

## Useful resources 

The best introductions to Galaxy are given by the Galaxy project itself. You may choose to start your Galaxy journey by reading the following:
[Introduction to Galaxy Analyses](https://training.galaxyproject.org/training-material/topics/introduction/)

If you are an RSE looking to develop tooling for Galaxy then generic documentation can be found at: [Developing Galaxy Tools](https://training.galaxyproject.org/training-material/topics/dev/#st-tooldev)

You could also explore the Galaxy training material for coaching Galaxy administrators, however, this is not necessary to get started and the techniques may not necessarily apply to a self-hosted instance (the Galaxy Training Network assume deployment through Ansible, we use Docker Compose).
https://training.galaxyproject.org/training-material/topics/admin/

## Technical reference

The `.env` file is self documented via the `env.template` file. 
