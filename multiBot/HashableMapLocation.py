class HashableMapLocation:
    def __init__(self, map_location):
        self.map_location = map_location

    def __eq__(self, other):
        return self.map_location.__eq__(other.map_location)

    def __hash__(self):
        return self.map_location.x << 16 | self.map_location.y
