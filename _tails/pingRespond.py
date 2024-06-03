import time
import os

documents_path = os.path.join(os.path.expanduser('~'), 'Documents')
ping_path = os.path.join(documents_path, 'upRail', 'PING.uprail')


def respond_to_ping():
    try:
        with open(ping_path, 'r') as file:
            content = file.read()

        if content == '0':
            content = '1'
            with open(ping_path, 'w') as file:
                file.write(content)
    except FileNotFoundError:
        print("PING_ERROR file_not_found")


def monitor_ping():
    while True:
        respond_to_ping()
        time.sleep(1)
