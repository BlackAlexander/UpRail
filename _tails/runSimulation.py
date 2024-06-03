import os

documents_path = os.path.join(os.path.expanduser('~'), 'Documents')

unit_mass = 0
unit_power = 0
unit_brake = 0
unit_length = 0
weight_center = 0

start_distance = 0
plan_length = 0

map_left_node = []
map_right_node = []
map_y = [0] * 100
map_angle = [0] * 100
map_is_node = [False] * 100

map_speed_max = [0] * 100
map_speed_min = [0] * 100
map_grip = [0] * 100
map_friction = [0] * 100

nodes = []
cars = []


def compute_weight_center(cars_array):
    if unit_mass == 0:
        return len(cars_array) * 22 / 2
    moment_sum = 0
    for i in range(len(cars_array)):
        current_car_center = i * 22 + (20 / 2)
        current_car_moment = current_car_center * cars_array[i][0]
        moment_sum += current_car_moment
    return moment_sum / unit_mass


def fill_unit_data(file_content):
    global map_grip, unit_mass, unit_power, unit_brake, unit_length, weight_center, cars
    unit_grip = min(100, max(int(file_content[1][12:]), 0))
    map_grip = [unit_grip] * 100
    cars_count = int(file_content[8][6:])
    for i in range(cars_count):
        car_line = file_content[9 + i].split(' ')
        car_mass = int(car_line[0])
        car_type = str(car_line[1])
        car_traction = float(car_line[2])
        car_brake = float(car_line[3])
        new_car = [car_mass, car_type, car_traction, car_brake]
        unit_mass += car_mass
        unit_power += car_traction
        unit_brake += car_brake
        cars.append(new_car)
    unit_length = cars_count*22
    weight_center = compute_weight_center(cars)
    print(weight_center)


def fill_plan_data(file_content):
    global start_distance, plan_length, map_left_node, map_right_node, map_y, map_angle, map_is_node
    global map_speed_max, map_speed_min, map_grip, map_friction, nodes, cars
    pass


def run_simulation(plan, unit):
    plan_path = os.path.join(documents_path, 'upRail/plans', plan + '.upmap')
    unit_path = os.path.join(documents_path, 'upRail/units', unit + '.uptrain')
    try:
        with open(plan_path, 'r') as file:
            content = file.read().split('\n')
            fill_plan_data(content)
    except FileNotFoundError:
        print("SIM_ERROR file not found")
    try:
        with open(unit_path, 'r') as file:
            content = file.read().split('\n')
            fill_unit_data(content)
    except FileNotFoundError:
        print("SIM_ERROR file not found")
