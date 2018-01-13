import bc.*;

public class Vector {

    double x;
    double y;

    Vector(double x, double y) {
        this.x = x;
        this.y = y;
    }

    double dist(Vector o) {
        return Math.sqrt(((x - o.x) * (x - o.x)) + ((y - o.y) * (y - o.y)));
    }

    Vector times(double k) {
        return new Vector(k * x, k * y);
    }

    static Vector fromLoc(MapLocation l) {
        return new Vector(l.getX(), l.getY());
    }

    static Vector fromLoc(Location l) {
        return fromLoc(l.mapLocation());
    }

}
