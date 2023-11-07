import sys

import yaml


def load_mandatory_config():
    if len(sys.argv) > 1:
        folder = sys.argv[1]
    else:
        folder = ""
    if folder == "azure_functions":
        from azure_functions.config import Settings
    elif folder == "app":
        from app.config import Settings
    else:
        raise Exception(f"Not recognized argument {folder}")
    settings_variables = Settings.__dict__["__fields__"].items()
    for key, options in settings_variables:
        default_value = options.default
        if default_value or default_value == "":
            continue
        config_mandatory.append(key.upper())
    return config_mandatory


def load_config(parent: str, file_name: str, config_list: list):
    with open(file_name, "r") as file:
        data = yaml.safe_load(file)
    if data is not None and data.get("environments"):
        if parent != "":
            subdata = data[parent]
        else:
            subdata = data
        for key in subdata["environments"].get("plain", []):
            config_list.append(key)
        for key in subdata["environments"].get("secret", []):
            config_list.append(key)
    return config_list


if __name__ == "__main__":
    config_mandatory = []
    config_setted: list = []
    missing_keys = []
    parent = sys.argv[2]
    config_mandatory = load_mandatory_config()
    if parent.endswith(".yaml") or parent.endswith(".yml"):
        start_key = 2
        parent = ""
    else:
        for key in range(3, len(sys.argv)):
            config_setted = load_config("", sys.argv[key], config_setted)
            config_setted = [*set(config_setted)]
        start_key = 3
    for key in range(start_key, len(sys.argv)):
        config_setted = load_config(parent, sys.argv[key], config_setted)
        config_setted = [*set(config_setted)]
    for value in config_mandatory:
        if value not in config_setted:
            missing_keys.append(value)
    if missing_keys:
        raise Exception(f"Missing keys {missing_keys}")
