from datetime import datetime
from uuid import uuid4


def get_fake_crc_number() -> str:
    return uuid4().hex.upper()


def get_today_isoformat() -> str:
    today = datetime.utcnow()
    return today.isoformat()


def get_today_date() -> str:
    today = datetime.utcnow()
    return datetime.strftime(today, "%Y-%m-%d %H:%M")


def get_timestamp() -> int:
    now = datetime.utcnow()
    return round(datetime.timestamp(now))


def get_str_timestamp() -> str:
    return str(get_timestamp())
