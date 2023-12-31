import shutil

TERMINATOR = "\x1b[0m"
WARNING = "\x1b[1;33m [WARNING]:"
INFO = "\x1b[1;33m [INFO]:"
HINT = "\x1b[3;33m"
SUCCESS = "\x1b[1;32m [SUCCESS]:"


def copy_dotenv():
    shutil.copyfile("app/.env.example", "app/.env")


def print_post_gen_message():
    print(
        "Please replace cookiecutter.project_name and "
        "cookiecutter.python_version in .ci/pipeline.yaml with proper values"
    )


def main():
    copy_dotenv()
    print_post_gen_message()


if __name__ == "__main__":
    main()
