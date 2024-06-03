import math


def compute_force(m, g, theta, AB, t_power, b_force, ug, uf, v):
    """
    :param m: unit mass (kg)
    :param g: gravitational acceleration (m/s^2)
    :param theta: current angle (rad)
    :param AB: how strong to accelerate/decelerate (-100 - 100)
    :param t_power: unit power (in W)
    :param b_force: braking force (in N)
    :param ug: adhesion coefficient (grip) (0 - 100)
    :param uf: friction coefficient (0 - 100)
    :param v: current speed (m/s)
    :return: Result of all forces acting on unit (N)
    """
    if AB > 0:  # compute power after AB input
        tractive_input = t_power * AB / 100
    elif AB == 0:
        tractive_input = 0
    else:
        tractive_input = abs(b_force * AB / 100)

    max_tractive = ug/100 * m * g * math.cos(theta)  # adhesion limit
    v = max(v, 0.00001)  # don't divide by 0
    tractive_force = min(tractive_input / v, max_tractive)

    Gt = m * g * math.sin(theta)  # tangential weight
    Gn = m * g * math.cos(theta)  # normal weight

    result = 0  # final forces combined

    if AB > 0:  # add train power (accelerate or brake)
        result += tractive_force
    elif AB == 0:
        result += 0
    else:
        result -= tractive_force

    result -= Gt  # gravitational pull

    if result > 0:  # friction acts in the opposite direction of moving
        friction_force = Gn * uf
    elif result == 0:
        friction_force = 0
    else:
        friction_force = Gn * uf * (-1)

    result -= friction_force

    return result


def compute_acceleration(F, m):
    """
    :param F: total force (N)
    :param m: mass (kg)
    :return: a: acceleration (m/s^2)
    """
    #  Newton F = m * a
    return F/m


def get_next_position(m, g, theta, AB, t_power, b_force, ug, uf, v, old_distance):
    """
    :param m: as above
    :param g: -//-
    :param theta: -//-
    :param AB: -//-
    :param t_power: -//-
    :param b_force: -//-
    :param ug: -//-
    :param uf: -//-
    :param v: -//-
    :param old_distance: previous distance
    :return: [delta_x]
    """
    # delta t = 1 s
    force = compute_force(m, g, theta, AB, t_power, b_force, ug, uf, v)
    acceleration = compute_acceleration(force, m)
    delta_x = v + 1/2 * acceleration
    new_speed = delta_x
    new_distance = old_distance + delta_x
    new_distance = min(new_distance, 0)
    new_distance = max(new_distance, 1000)
    return delta_x
