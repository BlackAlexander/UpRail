import os
import time

from genetic import run_genetic

documents_path = os.path.join(os.path.expanduser('~'), 'Documents')
comm_path = os.path.join(documents_path, 'upRail', 'COMM.uprail')


def restore_test_comm():
    content = "1\nrestricted\nCFR"
    with open(comm_path, 'w') as file:
        file.write(content)
    print('comm restored')


def respond_to_comm():
    try:
        with open(comm_path, 'r') as file:
            content = file.read()
        content = content.split('\n')
        first_line = content[0]
        if first_line == '1':
            plan = content[1]
            unit = content[2]
            content = "2\nloading"
            with open(comm_path, 'w') as file:
                file.write(content)
            if len(plan) > 0 and len(unit) > 0:
                run_genetic(plan, unit)
        else:
            pass

    except FileNotFoundError:
        print("COMM_ERROR file_not_found")


def monitor_comm():
    while True:
        respond_to_comm()
        time.sleep(1)
