run:
	docker-compose up -d

stop:
	docker-compose down

build: purge
	docker-compose build

purge:
	docker-compose down -v --remove-orphans

logs:
	docker-compose logs -tf

pre-deps:
	pip install pipenv

install: pre-deps
	pipenv sync --dev

update-deps: pre-deps
	pipenv update --dev

lint:
	pipenv run flake8 .
	pipenv run isort --check shared/
	pipenv run isort --check azure_functions/
	pipenv run black --check .
	pipenv run mypy . --install-types --non-interactive

lint-app:
	pipenv run flake8 .
	pipenv run isort --check app/
	pipenv run isort --check azure_functions/
	pipenv run black --check .
	pipenv run mypy . --install-types --non-interactive

lint-fxapp:
	pipenv run flake8 .
	pipenv run isort --check shared/
	pipenv run isort --check azure_functions/
	pipenv run black --check .
	pipenv run mypy . --install-types --non-interactive

format:
	pipenv run isort app/
	pipenv run isort azure_functions/
	pipenv run black .

test: test-app test-functions

test-app:
	docker-compose run app pytest --random-order

test-functions:
	docker-compose run functions pytest home/site/wwwroot/tests --ignore=home/site/wwwroot/tests/smoke_tests

check-vulnerabilities:
	pipenv run bandit -r -c pyproject.toml .

update-pre-commit:
	pre-commit autoupdate

check-vulnerabilities-sarif:
	pipenv run bandit -r -c pyproject.toml --format sarif --output bandit-report.sarif .

create-symlinks-app:
	cd app && ls -al && ln -s ../shared ./shared

create-symlinks-functions:
	cd azure_functions && ls -al && ln -s ../shared ./shared

functions-list:
	scripts/functions_list.sh -a bifrost-fxapp -f ./azure_functions -o .helm/_values/functions_list.yaml
