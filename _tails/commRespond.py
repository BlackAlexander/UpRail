import os
import time

from runSimulation import run_simulation

documents_path = os.path.join(os.path.expanduser('~'), 'Documents')
comm_path = os.path.join(documents_path, 'upRail', 'COMM.uprail')


def respond_to_comm():
    try:
        with open(comm_path, 'r') as file:
            content = file.read()

        content = content.split('\n')
        first_line = content[0]
        if first_line == '1':
            plan = content[1]
            unit = content[2]
            if len(plan) > 0 and len(unit) > 0:
                run_simulation(plan, unit)
            content = "2\nloading"
            with open(comm_path, 'w') as file:
                file.write(content)
        else:
            pass

    except FileNotFoundError:
        print("COMM_ERROR file_not_found")


def monitor_comm():
    while True:
        respond_to_comm()
        time.sleep(1)
