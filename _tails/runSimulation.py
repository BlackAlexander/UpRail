import math
import os

from physics import get_next_position

documents_path = os.path.join(os.path.expanduser('~'), 'Documents')

gravity = 9.8
low_efficiency_obstruction: 1
low_efficiency_timer: 1000

unit_mass = 0
unit_power = 0
unit_brake = 0
unit_length = 0
weight_center = 0

start_distance = 0
plan_length = 0

map_left = [0] * 1001  # closest node to the left
map_right = [1000] * 1001  # closest node to the right
map_y = [0.0] * 1001  # y to given point x
map_angle = [0.0] * 1001  # angle (rad) of point (x, y(x))
map_is_node = [False] * 1001  # is or is not node in original map

map_speed_max = [9999] * 1001
map_speed_min = [0] * 1001
map_grip = [100] * 1001
map_friction = [0] * 1001

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
    for i in range(0, 1001):
        map_grip[i] = min(map_grip[i], unit_grip)
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


def compute_distance_projection(D, xA, yA, xB, yB):
    distance_ab = math.sqrt(math.pow(xB - xA, 2) + math.pow(yB - yA, 2))
    r = D / distance_ab
    x_n = xA + r * (xB - xA)
    y_n = yA + r * (yB - yA)
    return [x_n, y_n]


def compute_distance_TP(xA, yA, xB, yB):
    return math.sqrt(math.pow(xB - xA, 2) + math.pow(yB - yA, 2))


def walk_track_right(Dist, x_a, y_a):
    if Dist < 0:
        return walk_track_left(abs(Dist), x_a, y_a)
    right_x = map_right[int(x_a)]
    right_y = map_y[int(right_x)]
    left_distance = Dist
    while left_distance > 0:
        to_node = compute_distance_TP(x_a, y_a, right_x, right_y)
        if left_distance <= to_node:
            return compute_distance_projection(left_distance, x_a, y_a, right_x, right_y)
        else:
            left_distance -= to_node
            x_a = right_x
            y_a = right_y
            if x_a >= 1000:
                return [x_a, y_a]
            right_x = map_right[x_a]
            right_y = map_y[right_x]
    return 0


def walk_track_left(Dist, x_a, y_a):
    left_x = map_left[int(x_a)]
    left_y = map_y[int(left_x)]
    left_distance = Dist
    while left_distance > 0:
        to_node = compute_distance_TP(x_a, y_a, left_x, left_y)
        if left_distance <= to_node:
            return compute_distance_projection(left_distance, x_a, y_a, left_x, left_y)
        else:
            left_distance -= to_node
            x_a = left_x
            y_a = left_y
            if x_a <= 0:
                return [x_a, y_a]
            left_x = map_left[x_a]
            left_y = map_y[left_x]
    return 0


def fill_plan_data(file_content):
    global start_distance, plan_length, map_left, map_right, map_y, map_angle, map_is_node
    global map_speed_max, map_speed_min, map_grip, map_friction, nodes, cars
    nodes_count = int(file_content[2][7:])
    for i in range(nodes_count):
        node_line = file_content[3 + i].split(' ')
        node_x = int(node_line[0])
        node_y = int(node_line[1])
        map_is_node[node_x] = True
        nodes.append([node_x, node_y])
    speed_count = int(file_content[nodes_count + 3][7:])
    grip_count = int(file_content[nodes_count + 4 + speed_count][6:])
    friction_count = int(file_content[nodes_count + 5 + speed_count + grip_count][12:])
    for i in range(speed_count):
        node_line = file_content[4 + nodes_count + i].split(' ')
        speed_limit = min(9999, max(int(node_line[0]), 0))
        speed_left = min(1000, max(int(node_line[1]), 0))
        speed_right = min(1000, max(int(node_line[2]), 0))
        speed_type = str(node_line[3])
        for j in range(speed_left, speed_right + 1):
            if speed_type == "max":
                map_speed_max[j] = min(map_speed_max[j], speed_limit)
            elif speed_type == "min":
                map_speed_min[j] = max(map_speed_max[j], speed_limit)
    for i in range(grip_count):
        node_line = file_content[5 + nodes_count + speed_count + i].split(' ')
        grip_limit = min(100, max(int(node_line[0]), 0))
        grip_left = min(1000, max(int(node_line[1]), 0))
        grip_right = min(1000, max(int(node_line[2]), 0))
        for j in range(grip_left, grip_right + 1):
            map_grip[j] = min(map_grip[j], grip_limit)
    for i in range(friction_count):
        node_line = file_content[6 + nodes_count + speed_count + grip_count + i].split(' ')
        friction_limit = min(100, max(int(node_line[0]), 0))
        friction_left = min(1000, max(int(node_line[1]), 0))
        friction_right = min(1000, max(int(node_line[2]), 0))
        for j in range(friction_left, friction_right + 1):
            map_friction[j] = max(map_friction[j], friction_limit)
    plan_length = 0
    for i in range(len(nodes) - 1):
        xa = nodes[i][0]
        xb = nodes[i+1][0]
        ya = nodes[i][1]
        yb = nodes[i+1][1]
        current_length = math.sqrt((xb-xa)*(xb-xa)+(yb-ya)*(yb-ya))
        plan_length += current_length

    map_y[0] = nodes[0][1]
    map_left[0] = -1
    map_right[0] = nodes[1][0]
    map_angle[0] = 0
    map_y[1000] = nodes[len(nodes) - 1][1]
    map_left[1000] = nodes[len(nodes) - 2][0]
    map_right[1000] = 1001
    map_angle[1000] = 0

    last_aux_node = 0
    next_aux_node = 1
    for i in range(1, 1000):
        map_left[i] = nodes[last_aux_node][0]
        if nodes[next_aux_node][0] == i:
            map_y[i] = nodes[next_aux_node][1]
            last_aux_node += 1
            next_aux_node += 1
        map_right[i] = nodes[next_aux_node][0]

    for i in range(1, 1000):
        if not map_is_node[i]:
            lx = map_left[i]
            rx = map_right[i]
            ly = map_y[lx]
            ry = map_y[rx]
            t = (i - lx) / (rx - lx)
            map_y[i] = ly + t * (ry - ly)

    for i in range(1, 1000):
        lx = i - 1
        ly = map_y[lx]
        rx = i + 1
        ry = map_y[rx]
        map_angle[i] = math.atan2((ry-ly), (rx-lx))

    start_distance = walk_track_right(unit_length, nodes[0][0], nodes[0][1])[0]


def extrapolate_data(left_value, right_value, ms):
    ms = ms % 1000
    result = left_value + (right_value - left_value) * (ms / 1000)
    return result


def output(simdata):
    sim_path = os.path.join(documents_path, 'upRail', 'SIM.uprail')
    with open(sim_path, 'w') as file:
        file.write(str(len(simdata)) + '\n')
        for i in range(len(simdata)):
            file.write(' '.join(map(str, simdata[i])))
            file.write('\n')


def answer_sim_request(success):
    comm_path = os.path.join(documents_path, 'upRail', 'COMM.uprail')
    try:
        with open(comm_path, 'w') as file:
            if success:
                file.write("3\ndone")
            else:
                file.write("4\nfail")

    except FileNotFoundError:
        print("COMM_ERROR file_not_found")




def run_input(ABinput, case):
    """
    :param ABinput: array with values from -100 (brake) to 100 (accelerate)
    :return: list of positions
    """

    last_position = start_distance
    last_speed = 0

    positions = [last_position]

    simdata = []

    index = 0

    for AB in ABinput:
        position_y = extrapolate_data(map_y[int(last_position)], map_y[int(last_position) + 1], (last_position % 1) * 1000)
        current_wc = walk_track_left(weight_center, last_position, position_y)[0]

        # Find precise angle
        theta = extrapolate_data(map_angle[int(current_wc)], map_angle[int(current_wc) + 1], (current_wc % 1) * 1000)

        # Run physics
        run = get_next_position(unit_mass, gravity, theta, AB, unit_power*1000, unit_brake, map_grip[int(current_wc)], map_friction[int(current_wc)], last_speed, last_position)

        # Extract data
        delta_x = run[0]
        acceleration = run[1]
        new_position = walk_track_right(delta_x, last_position, position_y)[0]
        # new_position = last_position + delta_x
        new_speed = delta_x

        # Finish successfully
        if new_position >= 1000:
            new_position = 1000
            positions.append(new_position)
            simdata.append([index, round(new_position, 2), AB, round(acceleration, 2), round(delta_x, 2)])
            if case == "fitness":
                return positions
            elif case == "print":
                output(simdata)
                answer_sim_request(True)
                return

        # Too slow
        if len(positions) > low_efficiency_timer and new_position < (low_efficiency_timer * low_efficiency_obstruction):
            if case == "fitness":
                return positions
            elif case == "print":
                output(simdata)
                answer_sim_request(False)
                return

        # Can't run outside map
        if new_position <= start_distance:
            new_position = last_position
            new_speed = last_speed

        # Prepare for next run
        positions.append(new_position)
        last_position = new_position
        last_speed = new_speed

        simdata.append([index, round(last_position, 2), AB, round(acceleration, 2), round(delta_x, 2)])
        index += 1

    if case == "fitness":
        return positions
    elif case == "print":
        output(simdata)
        answer_sim_request(True)


def run_simulation(plan, unit):
    print("Running " + unit + " on " + plan)
    plan_path = os.path.join(documents_path, 'upRail/plans', plan + '.upmap')
    unit_path = os.path.join(documents_path, 'upRail/units', unit + '.uptrain')
    env_path = os.path.join(documents_path, 'upRail', 'Environment.uprail')
    try:
        with open(unit_path, 'r') as file:
            content = file.read().split('\n')
            fill_unit_data(content)
    except FileNotFoundError:
        print("SIM_ERROR file not found")
    try:
        with open(plan_path, 'r') as file:
            content = file.read().split('\n')
            fill_plan_data(content)
    except FileNotFoundError:
        print("SIM_ERROR file not found")

    global gravity, low_efficiency_obstruction, low_efficiency_timer
    try:
        with open(env_path, 'r') as file:
            content = file.read().split('\n')
            gravity = float(content[1][22:])
            low_efficiency_obstruction = float(content[2][28:])
            low_efficiency_timer = float(content[3][22:])
    except FileNotFoundError:
        print("SIM_ERROR file not found")

    #  No speed restrictions means full acceleration is optimal solution
    for i in range(0, 999):
        if map_speed_max == 9999:
            run_input([100] * 10000, "print")
            return

    run_input([100]*1000, "print")
