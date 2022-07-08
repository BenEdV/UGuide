# UGuide

This is the repository for the UGuide project. UGuide uses [Docker](https://www.docker.com) to run multiple containers of the different services.

- [nginx](https://nginx.org) Serves the frontend web application and backend/learninglocker APIs through a single endpoint
- [backend](https://github.com/BenEdV/UGuide_backend) aggregates statistics and parsing data from other sources
- [frontend](https://github.com/BenEdV/UGuide_frontend) dashboards showing the statistics giving students and teachers insight in their learning progress
- [postgres](https://www.postgresql.org) the database for the backend, contains data for users, permissions, activity content, constructs, etc.
- [learninglocker](https://docs.learninglocker.net/welcome/) an open source LRS which we use for receiving and storing [xAPI statements](https://xapi.com/statements/)
- [mongo](https://www.mongodb.com) the database learninglocker uses to store statements. It is also accessed directly by the backend to allow faster and more complex queries

# Installation
## Git clone
```sh
git clone git@github.com:BenEdV/UGuide.git --recurse-submodules
```
The UGuide repo is structured in [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules). This command will clone the entire UGuide codebase including the Backend, and Frontend submodule repositories.

## Set up development environment
See [Setting up development environment](https://github.com/BenEdV/UGuide/wiki/Setting-up-development-environment) for a guide on setting up UGuide for development purposes.

## Common issues
The [Common Issues](https://github.com/BenEdV/UGuide/wiki/Common-Issues) wiki page contains a list of issues developers may face while developing for UGuide.
