# LearnLytics

This is the repository for the LearnLytics project, which consists of two parts. A Backend for aggregating statistics and parsing data from other sources, and a Frontend with dashboards showing the statistics giving students and teachers insight in their learning progress.

# Installation
```sh
git clone git@gitlab.com:LearnLyticsUU/LearnLytics.git --recurse-submodules
```
The LearnLytics repo is structured in [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules). This command will clone the entire LearnLytics codebase including the Backend, and Frontend submodule repositories.

# Docker Compose

LearnLytics uses [Docker Compose](https://docs.docker.com/compose/) as it deployment system. This uses containerized services that run in a virtual environment ensuring that the system runs identically on varying development and production hardware. To run the service outside of a container follow the READMEs in the respective [backend](learnlytics-backend) and [frontend](learnlytics-frontend) repositories.

# Deployment
The following commands will create containers for each service in the stack with the necessary networks and volumes to connect the services and persist the databases. The containers for the mongo database is relied on by the other containers and must be started first as other containers which depend on them will fail if the databases is not present. The backend has a busy wait for the postgres database and thus can be started simultaneously. Due to this one must first run
```sh
docker-compose up -d mongo
```
And then after waiting for the database to start in about half a minute run
```sh
docker-compose up -d
```
to start the remaining containers. The services are taken down with the following command
```sh
docker-compose down
```

## Browser access
The website is available at `https://localhost/login` on your develop machine. You can also setup a port for the unencrypted http access, this will redirect to the secure https URL.

## Rebuild
If the codebase has changed `docker-compose up -d` will still run with the latest build of the codebase. To make a new build with the new codebase run
```sh
docker-compose build
```

# Learning Locker
We use the [learning locker docker image](https://github.com/michzimny/learninglocker2-docker) created by [michzimny](https://github.com/michzimny). This is a docker image available at [dockerhub](https://hub.docker.com/r/michzimny/learninglocker2-app). Take the tag for the latest version and set `LL_TAG` in your `.env` file to this value. By the first set up you will need to initialize the learninglocker admin by running
```sh
docker-compose exec learninglocker_api node cli/dist/server createSiteAdmin [email] [organisation] [password]
```

### Updating production or testing server
First you will need to have your public ssh key added to the authorized keys of the server by another already authorized team member. Add a remote for our server with:
```
git remote add server root@learninganalytics.science.uu.nl:/srv/git/LearnLytics/LearnLytics_deployment.git
git remote add test root@intelearn.science.uu.nl:/srv/git/LearnLytics/LearnLytics.git
```
And then push to the server to have it automatically update with the new push with
```
git push server
git push test
```

### Setting up new server
The [post-receive](post-receive) file should be found in the `.git/hooks` folder of the deployment repo.
