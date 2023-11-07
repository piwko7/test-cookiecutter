import argparse
import socket


def validate_ipv4_address(ip):
    try:
        socket.inet_pton(socket.AF_INET, ip)
    except socket.error:
        raise argparse.ArgumentTypeError(f"'{ip}' is not a valid IPv4 address")
    return ip


def validate_port(port):
    port = int(port)
    if not 0 <= port <= 65000:
        raise argparse.ArgumentTypeError("Port must be between 0 and 65000")
    return port
