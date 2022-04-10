# Environment Variables
Environment variables are used by the system to set up variables that differ in the various environments using UGuide (development/production). Most of these variables are used by the frontend and backend but there are also variables such as the timezone variable (`TZ`) which are used by all containers.

## Setting environment variables
When using UGuide in production all settings for the environment variables of _all_ containers should be found in the [`.env`](.env) of the this repo. When running the backend or the frontend outside of a container the environment variables need to be set separately.

### Setting environment variables in the backend outside of a docker container
In the backend there is a [`.env.template`](learnlytics-backend/.env.template) file, this should be copied to [`.env`](learnlytics-backend/.env) and filled in. These environment variables are then used in backend when you run `./main.py`

### Setting environment variables in the frontend outside of a docker container
In the frontend the [`environments.ts`](learnlytics-frontend/src/environments/environment.ts) is used to set up the environment variables that used in the frontend. These variables are used when the frontend is run by `ng serve`.

## Adding environment variables
When adding a new environment variable there are multiple places where this environment variable must be added.

### Adding an environment variable to the backend
You need to edit the following files:
```
.env
.env.template
docker-compose.yml
learnlytics-backend/.env
learnlytics-backend/.env.template
learnlytics-backend/config.py
```
The environment must be set in the [`config.py`](learnlytics-backend/config.py) of the backend. This is done by appending
```py
INTERNAL_ENV_NAME = os.getenv("EXTERNAL_ENV_NAME")
```
to the `ProductionConfig` class with the `EXTERNAL_ENV_NAME` being the name of the variable in the `.env` file. Note that the value passed in is a string and may need to be cast such as using `== True` for booleans. The line
```sh
EXTERNAL_ENV_NAME=default_value
```
should be added to both the [`.env.template`](.env.template) file in the main repo and the [`.env.template`](learnlytics-backend/.env.template) file in the backend repo. To set the variable for your environment this should also be set in the respective `.env` file. Lastly the [docker-compose.yml](docker-compose.yml) file needs to be told that the environment variable needs to be set in the container. For the backend this done by adding
```yaml
- EXTERNAL_ENV_NAME
```
to [docker-compose.yml](docker-compose.yml) under the
```yaml
services:
	backend:
		environment:
```
level.

### Adding an environment variable to the frontend
You need to edit the following files:
```
.env
.env.template
docker-compose.yml
learnlytics-frontend/Dockerfile
learnlytics-frontend/src/environments/environment.ts
learnlytics-frontend/src/environments/environment.prod.ts.temp
```
To add a variable to the frontend for production use you should add the line
```js
internal_env_name: ${EXTERNAL_ENV_NAME},
```
to the environment object in [`environment.prod.ts.temp`](learnlytics-frontend/src/environments/environment.prod.ts.temp). To add this to the development environment that is used when running outside of a docker container add this line to [`environment.ts`](learnlytics-frontend/src/environments/environment.ts).
The [docker-compose.yml](docker-compose.yml) file needs to be told that the environment variable needs to be set in the container. Since the frontend compiles to static files which are served by the `nginx` container, the environment variables aren't set for the runtime container (there is no runtime container) instead the are set as build arguments for compiling the frontend. This is done by adding
```yaml
- EXTERNAL_ENV_NAME
```
to [docker-compose.yml](docker-compose.yml) under the
```yaml
services:
	frontend:
		build:
			args:
```
level. Since this is being used during build we also need the add the variable to the [`Dockerfile`](learnlytics-frontend/Dockerfile). This done by adding
```sh
ARG EXTERNAL_ENV_NAME
```
to [`Dockerfile`](learnlytics-frontend/Dockerfile) under the `# set working directory` comment.

## Using environment variables
Once environment variables are added to the system they can be imported and used in the system.

### Using environment variables in the backend
The environment variable can be accessed through the `current_app` object of the flask module
```py
from flask import current_app

env_var = current_app.config.get('INTERNAL_ENV_NAME')
```

### Using environment variables in the frontend
The environment variable can be accessed through the `environment` object of the environments module
```js
import { environment } from 'src/environments/environment';

const env_var = environment.internal_env_name;
```
