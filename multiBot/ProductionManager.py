from collections import namedtuple
import battlecode as bc
from LocationUtil import is_empty, cross_directions, find_empty_loc_near
from HashableMapLocation import HashableMapLocation
from functools import reduce
from Pathfinder import a_star_search


Project = namedtuple('Project', ['karbonite', 'is_in_progress'])


class ProductionManager:
    def __init__(self, gc):
        self.gc = gc
        self.factories = []
        self.idle_workers = []
        self.projects = dict()

    def available_karbonite(self):
        return self.gc.karbonite() - reduce(
            lambda x, y: x + (y.karbonite if y.is_in_progress else 0),
            self.projects.values(),
            0
        )

    def update(self):
        print('--- Production manager update')
        print(f'Karbonite: {self.gc.karbonite()}')
        print(f'Available karbonite: {self.available_karbonite()}')
        print(f'Projects: {self.projects}')

        self.update_projects()
        self.update_units()
        self.manage_build()

    def update_projects(self):
        for f in self.factories:
            loc = HashableMapLocation(f.location.map_location())
            if loc in self.projects:
                self.projects.pop(loc)

    def update_units(self):
        for unit in self.gc.my_units():
            if unit.unit_type == bc.UnitType.Factory:
                self.factories.append(unit)
            elif unit.unit_type == bc.UnitType.Worker and unit.location.is_on_map():
                self.idle_workers.append(unit)

    def manage_build(self):
        self.produce_units()
        self.build_projects()
        self.manage_workers()

    def produce_units(self):
        for f in self.factories:
            if self.gc.can_produce_robot(f.id, bc.UnitType.Ranger):
                self.gc.produce_robot(f.id, bc.UnitType.Ranger)

    def build_projects(self):
        while self.should_build_factory():
            print('Creating factory build project')
            next_loc = self.get_next_build_loc()
            if next_loc is not None:
                self.projects[HashableMapLocation(next_loc)] = Project(
                    bc.UnitType.Factory.blueprint_cost(),
                    False
                )
            else:
                print('No available spcae for build found')
                break

    def manage_workers(self):
        if len(self.idle_workers) == 0:
            print('No workers found')
            return

        # Assign a worker to each project
        print('Managing workers')
        for p_loc, project in self.projects.items():
            worker = min(self.idle_workers,
                         key=lambda w: w.location.map_location().distance_squared_to(p_loc.map_location)
                         )
            print(f'Closest worker to project {p_loc} is {worker.location.map_location()}')
            self.idle_workers.remove(worker)
            # Send this worker to build
            worker_loc = worker.location.map_location()
            if worker_loc.is_adjacent_to(p_loc.map_location):
                print('Worker is close enough')
                # Worker is close enough and can build
                if project.is_in_progress:
                    building = self.gc.sense_nearby_units(p_loc.map_location, 1)
                    if self.gc.can_build(worker.id, building.id):
                        self.gc.build(worker.id, building.id)
                else:
                    d = worker_loc.direction_to(p_loc.map_location)
                    if (self.gc.karbonite() > bc.UnitType.Factory.blueprint_cost()
                            and self.gc.can_blueprint(worker.id, bc.UnitType.Factory, d)):
                        self.gc.blueprint(worker.id, bc.UnitType.Factory, d)
                        self.projects[p_loc] = Project(project.karbonite, False)
            else:
                # Worker is too far, move it closer
                print('Worker is too far')
                loc_near = find_empty_loc_near(self.gc, self.gc.starting_map(bc.Planet.Earth), p_loc.map_location)
                if loc_near is not None:
                    print(f'Try to move worker from {worker.location.map_location()} to {loc_near}')
                    path_to_loc = list(a_star_search(
                        self.gc,
                        self.gc.starting_map(bc.Planet.Earth),
                        worker_loc,
                        p_loc.map_location
                    ))
                    if path_to_loc is not None and len(path_to_loc) > 1:
                        print(f'Path found {path_to_loc}')
                        next_node = path_to_loc[1]
                        next_dir = worker_loc.direction_to(bc.MapLocation(self.gc.planet(), next_node[0], next_node[1]))
                        if self.gc.can_move(worker.id, next_dir):
                            print('Worker move')
                            self.gc.move_robot(worker.id, next_dir)

        for worker in self.idle_workers:
            # TODO Find some work for idle workers
            pass

    def get_next_build_loc(self):
        # No factories yet, find a neraby place
        if len(self.factories) == 0:
            for w in self.idle_workers:
                for d in bc.Direction:
                    new_loc = w.location.map_location().add(d)
                    if is_empty(self.gc, self.gc.starting_map(bc.Planet.Earth), new_loc):
                        return new_loc
        # Find a place close to other factories
        else:
            for f in self.factories:
                for d in cross_directions:
                    new_loc = f.location.map_location().add(d)
                    if is_empty(self.gc, self.gc.starting_map(bc.Planet.Earth), new_loc):
                        return new_loc

        return None

    def should_build_factory(self):
        return len(self.projects) == 0 and self.available_karbonite() >= bc.UnitType.Factory.blueprint_cost()
