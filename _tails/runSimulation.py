import os

documents_path = os.path.join(os.path.expanduser('~'), 'Documents')


def run_simulation(plan, unit):
    plan = "twenty up"
    unit = "CFR"
    plan_path = os.path.join(documents_path, 'upRail/plans', plan + '.upmap')
    unit_path = os.path.join(documents_path, 'upRail/units', unit + '.uptrain')
    try:
        with open(plan_path, 'r') as file:
            content = file.read().split('\n')
            print(content)
    except FileNotFoundError:
        print("SIM_ERROR file not found")
    try:
        with open(unit_path, 'r') as file:
            content = file.read().split('\n')
            print(content)
    except FileNotFoundError:
        print("SIM_ERROR file not found")
