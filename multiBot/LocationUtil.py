import battlecode as bc

cross_directions = [
    bc.Direction.Northeast,
    bc.Direction.Northwest,
    bc.Direction.Southeast,
    bc.Direction.Southwest
]


def is_empty(gc, planet_map, map_loc):
    return (planet_map.on_map(map_loc)
            and planet_map.is_passable_terrain_at(map_loc)
            and len(gc.sense_nearby_units(map_loc, 0)) == 0)


def find_empty_loc_near(gc, planet_map, loc):
    for d in bc.Direction:
        near_loc = loc.add(d)
        if is_empty(gc, planet_map, near_loc):
            return near_loc
    return None
