import random

from runSimulation import run_simulation, run_input, test_full_banana, print_gene


def evaluate_gene(AB, generation):
    if len(AB) == 0:
        return 0
    if generation < 50:
        restriction_importance = 0
    else:
        restriction_importance = 100
    result = run_input(AB)
    scenario = result[0]  # 0 - too slow,  1 - good,  2 - did not reach end
    speed_fitness = result[1]  # 1 - how well were speed restrictions respected, from 0 to 100
    speed_finish = (10000 / len(AB))
    if scenario == 1:  # all was good, just check speed requirements
        return speed_finish * ((100-restriction_importance)/100) + speed_fitness * (restriction_importance / 100)
    if scenario == 2:  # didn't reach end, not enough genes
        return 0.0001
    if scenario == 0:  # too slow, probably can't get over a slope
        return 0.001


def initialize_population(pop_size, min_gene_length, max_gene_length):
    population = []
    for _ in range(pop_size):
        gene_length = random.randint(min_gene_length, max_gene_length)
        individual = [100] * gene_length
        population.append(individual)
    return population


def crossover(parent1, parent2):
    min_length = min(len(parent1), len(parent2))
    if min_length < 2:
        return parent1, parent2

    cross_point = random.randint(1, min_length - 1)
    child1 = parent1[:cross_point] + parent2[cross_point:]
    child2 = parent2[:cross_point] + parent1[cross_point:]
    return child1, child2


def mutate(individual, mutation_rate=0.01):
    for i in range(len(individual)):
        if random.random() < mutation_rate:
            individual[i] = random.randint(0, 1)*200-100
            individual[i] = max(individual[i], -100)
            individual[i] = min(individual[i], 100)

    if random.random() < mutation_rate:
        if len(individual) > 1:
            individual.pop(random.randint(0, len(individual) - 1))
    elif random.random() < mutation_rate:
        individual.append(random.randint(0, 1)*200-100)

    return individual


def select_parents(population, fitnesses):
    selected = random.choices(population, weights=fitnesses, k=len(population))
    return selected


def genetic_algorithm(pop_size, min_gene_length, max_gene_length, generations, mutation_rate):
    population = initialize_population(pop_size, min_gene_length, max_gene_length)

    best_individual = [100]*1000

    for generation in range(generations):
        fitnesses = [evaluate_gene(individual, generation) for individual in population]
        if generation % 60 == 0:
            print(str(generation/6) + "%")
            # print(sum(fitnesses) / len(fitnesses))
        # print(generation, sum(fitnesses)/len(fitnesses))

        new_population = []
        selected_parents = select_parents(population, fitnesses)

        for i in range(0, len(selected_parents), 2):
            parent1 = selected_parents[i]
            parent2 = selected_parents[i + 1] if i + 1 < len(selected_parents) else selected_parents[0]

            child1, child2 = crossover(parent1, parent2)
            new_population.append(mutate(child1, mutation_rate))
            new_population.append(mutate(child2, mutation_rate))

        population = new_population
        best_individual = max(population, key=lambda individual: evaluate_gene(individual, generation))

    return best_individual


def produce_result():
    population_size = 50  # Population size
    min_gene_length = 5  # Minimum length of each individual's gene (number of seconds)
    max_gene_length = 2000  # Maximum length of each individual's gene (number of seconds)
    generations = 600  # Number of generations to run the algorithm
    mutation_rate = 0.01  # Mutation rate

    best_AB = genetic_algorithm(population_size, min_gene_length, max_gene_length, generations, mutation_rate)
    print_gene(best_AB)
    print("-> Produced AI solution.")


def run_genetic(plan, unit):
    run_simulation(plan, unit)
    if test_full_banana():
        print_gene([100] * 10000)
        print("-> Produced generic solution.")
        return
    else:
        produce_result()
