# nanostore-cookiecutter-fastapi


Internal Nanostore [cookiecutter](https://github.com/audreyr/cookiecutter) template for jumpstarting FastAPI projects quickly.

## Quick Start

1. Install [cookiecutter](https://github.com/audreyr/cookiecutter)

    ```
    pip install cookiecutter
    ```

1. Scaffold project

    ```
    cookiecutter git@github.com:netguru/nanostore-cookiecutter-fastapi.git
    ```

1. Enter your project details

    Values in squared brackets (`[]`) are default values. If you don't provide your own, project will be populated with those values. You can accept default value by pressing `Enter`.

    ```
    project_name:
    project_slug:
    python_version [3.11]:
    ```

1. Update and install dependencies

    ```
    make update-deps
    ```

1. Init git repo and add remote origin

    ```
    git init
    pre-commit install
    git remote add origin <remote-origin-url>
    git add .
    git commit -m 'Initial commit'
    git push origin master
    ```

1. Set up pre-commit

    ```
    pre-commit install
    pre-commit run --all-files
    ```

1. Build project and run it with docker-compose

    ```
    make run
    ```

    You should be able to access sample page at http://localhost:8000/


## What to do on your own:

Please replace cookiecutter.project_name and cookiecutter.python_version in `.ci/pipeline.yaml` with proper values.
