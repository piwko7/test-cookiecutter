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
	pipenv run isort --check app/
	pipenv run black --check .
	pipenv run mypy . --install-types --non-interactive

format:
	pipenv run isort app/
	pipenv run black .

test: test-app test-functions

test-app:
	docker-compose run app pytest --random-order

check-vulnerabilities:
	pipenv run bandit -r -c pyproject.toml .

update-pre-commit:
	pre-commit autoupdate

check-vulnerabilities:
	pipenv run bandit -r -c pyproject.toml .

create-symlinks-app:
	cd app && ls -al && ln -s ../shared ./shared
