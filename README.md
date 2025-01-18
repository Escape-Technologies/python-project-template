# pytemplate ![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Escape-Technologies/python-project-template) [![CI](https://github.com/Escape-Technologies/python-project-template/actions/workflows/ci.yaml/badge.svg)](https://github.com/Escape-Technologies/python-project-template/actions/workflows/ci.yaml) [![CD](https://github.com/Escape-Technologies/python-project-template/actions/workflows/cd.yaml/badge.svg)](https://github.com/Escape-Technologies/python-project-template/actions/workflows/cd.yaml)

Run `make`

Source your `.venv`: `source .venv/bin/activate`

If you wish, rename all `app` (including folder names) by the name of your project.

Make sure you can run the `app-cli` command that should display "Hello World!"

______________________________________________________________________

## Environment

In order to use the workflows, you need to have the following environment variables set [Github Environment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment):

### Code coverage

`CODECOV_TOKEN`: The token for the [Codecov](https://codecov.io) service. This is used to upload the coverage report.

### PyPi

`PYPI_TOKEN`: The token used to push your package on Pypi.

### DockerHub

`DOCKERHUB_USERNAME`: Your DockerHub username.
`DOCKERHUB_TOKEN`: A token used to log on DockerHub.

`DOCKERHUB_REPO`: The repository where your image will be published.

### Bump all dependencies

```python
poetry self add poetry-plugin-sembump
poetry bump -D
```
