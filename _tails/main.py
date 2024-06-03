import os
import time
import threading


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


monitor_thread = threading.Thread(target=monitor_ping)
monitor_thread.daemon = True
monitor_thread.start()


def main():
    for i in range(10):
        print(f"Main program is running... {i}")
        time.sleep(2)


if __name__ == "__main__":
    main()
