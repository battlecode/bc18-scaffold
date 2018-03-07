import battlecode as bc
from PriorityQueue import PriorityQueue
import math
from LocationUtil import is_empty

directions = list(bc.Direction)


def a_star_search(gc, planet_map, start, goal):
    frontier = PriorityQueue()
    entry = (start.x, start.y)
    frontier.put(entry, 0)
    came_from = {entry: None}
    cost_so_far = {entry: 0}

    is_path_found = False

    while not frontier.empty():
        current_entry = frontier.get()
        current_ml = bc.MapLocation(gc.planet(), current_entry[0], current_entry[1])
        if current_ml == goal:
            is_path_found = True
            break

        for d in directions:
            next_ml = current_ml.add(d)
            next_entry = (next_ml.x, next_ml.y)
            new_cost = cost_so_far[current_entry] + 1
            if (is_empty(gc, planet_map, next_ml)
                    and (next_entry not in cost_so_far
                         or new_cost < cost_so_far[next_entry])):
                cost_so_far[next_entry] = new_cost
                priority = new_cost + h(goal, next_ml)
                frontier.put(next_entry, priority)
                came_from[next_entry] = current_entry

    if not is_path_found:
        return None

    node = (goal.x, goal.y)
    path = [node]
    while not (node[0] == start.x and node[1] == start.y):
        node_from = came_from[node]
        path.append(node_from)
        node = node_from

    return reversed(path)


def h(start, end):
    return math.sqrt(start.distance_squared_to(end))
