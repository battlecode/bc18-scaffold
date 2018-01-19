%module bc
/// GENERATED SWIG, DO NOT EDIT
%feature("autodoc", "1");
%{
#include "bc.h"

#ifdef __GNUC__
    #define unlikely(expr)  __builtin_expect(!!(expr),  0)
#else
    #define unlikely(expr) (expr)
#endif
%}

// swig library file that improves output for code using stdint
%include "stdint.i"
// used for throwing exceptions
%include "exception.i"
// used to tell swig to not generate pointer types for arguments
// passed by pointer
%include "typemaps.i"

// This code is inserted around every method call.
%exception {
    $action
    if (unlikely(bc_has_err())) {
        char *result;
        int8_t error = bc_get_last_err(&result);
        SWIG_exception(error, result);
    }
}
%{
typedef uint8_t magicbool;
%}
typedef uint8_t magicbool;

// We generate code with the prefix "bc_".
// This will strip it out.
#ifdef SWIGJAVA
// good enums
%include "enums.swg"
%rename("%(lowercamelcase)s", %$isfunction) "";
%rename("%(strip:[bc_])s", %$isclass) "";
%rename("%(strip:[bc_])s", %$isenum) "";
%rename("toString", match$name="debug") "";
%rename("size", match$name="len") "";
%rename("get", match$name="index") "";
%rename("equals", match$name="eq") "";

// booleans don't have a stable API so we have to make our own type.
// copied blindly from java.swg
%typemap(jni) magicbool, const bool & "jboolean"
%typemap(jtype) magicbool, const bool & "boolean"
%typemap(jstype) magicbool, const bool & "boolean"
%typemap(jboxtype) magicbool, const bool & "Boolean"

// we don't rename enums because it will make things inconsistent:
//   MapLocation x = new MapLocation(Planet.EARTH, 0, 1);
//   System.out.println(x);
// -> MapLocation { planet: Earth, x: 0, y: 1 }
// %rename("%(uppercase)s", %$isenumitem) "";
#else
%rename("%(strip:[bc_])s") "";
#endif

// Free newly allocated char pointers with the following code
%typemap(newfree) char * "bc_free_string($1);";

%pragma(java) jniclassimports=%{
import java.lang.*; // For Exception
import java.io.*;
import java.net.*;
%}
%pragma(java) jniclasscode=%{
    static {
        System.out.println("-- Starting battlecode java engine, vroom vroom! --");

        URL main = bcJNI.class.getResource("bcJNI.class");
        if (!"file".equalsIgnoreCase(main.getProtocol()))
            throw new IllegalStateException("Battlecode engine has to be left as loose class files - no jars please. Sorry.");
        File path = new File(main.getPath());
        File parent = path.getParentFile();

        System.out.println("-- Note: you may get a warning about stack guards, please ignore it. --");

        String os = System.getProperty("os.name").toLowerCase();
        try {
            if (os.indexOf("win") >= 0) {
                String lib = new File(parent, "libbattlecode-java-win32.dll").getAbsolutePath();
                System.out.println("Loading windows library: "+lib);
                System.load(lib);
            } else if (os.indexOf("mac") >= 0) {
                String lib = new File(parent, "libbattlecode-java-darwin.so").getAbsolutePath();
                System.out.println("Loading mac library: "+lib);
                System.load(lib);
            } else if (os.indexOf("nux") >= 0) {
                String lib = new File(parent, "libbattlecode-java-linux.so").getAbsolutePath();
                System.out.println("Loading linux library: "+lib);
                System.load(lib);
            } else {
                throw new Exception("Unknown operating system (good job, please install linux now): " + os);
            }
        } catch (Exception e) {
            System.err.println("Native code library failed to load. Does the file just printed exist?");
            System.err.println("Error: "+e);
            System.exit(1);
        }
        System.out.println("-- Engine loaded. --");
    }
%}

/// The planets in the Battlecode world.
#ifdef SWIGJAVA
%javaconst(1);
#endif
typedef enum bc_Planet {
    Earth = 0,
    Mars = 1,
} bc_Planet;

%newobject bc_Planet_other;
bc_Planet bc_Planet_other(bc_Planet this);

%newobject bc_Planet_debug;
char* bc_Planet_debug(bc_Planet this);

%newobject bc_Planet_eq;
magicbool bc_Planet_eq(bc_Planet this, bc_Planet other);

%newobject bc_Planet_from_json;
bc_Planet bc_Planet_from_json(char* s);

%newobject bc_Planet_to_json;
char* bc_Planet_to_json(bc_Planet this);


/// A direction from one MapLocation to another.
/// 
/// Directions for each of the cardinals (north, south, east, west), and each
/// of the diagonals (northwest, southwest, northeast, southeast). There is
/// also a "center" direction, representing no direction.
/// 
/// Coordinates increase in the north and east directions.
#ifdef SWIGJAVA
%javaconst(1);
#endif
typedef enum bc_Direction {
    North = 0,
    Northeast = 1,
    East = 2,
    Southeast = 3,
    South = 4,
    Southwest = 5,
    West = 6,
    Northwest = 7,
    Center = 8,
} bc_Direction;

%newobject bc_Direction_dx;
int32_t bc_Direction_dx(bc_Direction this);

%newobject bc_Direction_dy;
int32_t bc_Direction_dy(bc_Direction this);

%newobject bc_Direction_is_diagonal;
magicbool bc_Direction_is_diagonal(bc_Direction this);

%newobject bc_Direction_opposite;
bc_Direction bc_Direction_opposite(bc_Direction this);

%newobject bc_Direction_rotate_left;
bc_Direction bc_Direction_rotate_left(bc_Direction this);

%newobject bc_Direction_rotate_right;
bc_Direction bc_Direction_rotate_right(bc_Direction this);

%newobject bc_Direction_from_json;
bc_Direction bc_Direction_from_json(char* s);

%newobject bc_Direction_to_json;
char* bc_Direction_to_json(bc_Direction this);


typedef struct bc_MapLocation {} bc_MapLocation;
%apply bc_MapLocation* INPUT { bc_MapLocation* a };
%extend bc_MapLocation {
    bc_MapLocation(bc_Planet planet, int32_t x, int32_t y);
    ~bc_MapLocation();
    %newobject add;
    bc_MapLocation* add(bc_Direction direction);
    %newobject subtract;
    bc_MapLocation* subtract(bc_Direction direction);
    %newobject add_multiple;
    bc_MapLocation* add_multiple(bc_Direction direction, int32_t multiple);
    %newobject translate;
    bc_MapLocation* translate(int32_t dx, int32_t dy);
    %newobject distance_squared_to;
    uint32_t distance_squared_to(bc_MapLocation* o);
    %newobject direction_to;
    bc_Direction direction_to(bc_MapLocation* o);
    %newobject is_adjacent_to;
    magicbool is_adjacent_to(bc_MapLocation* o);
    %newobject is_within_range;
    magicbool is_within_range(uint32_t range, bc_MapLocation* o);
    %newobject debug;
    char* debug();
    %newobject clone;
    bc_MapLocation* clone();
    %newobject eq;
    magicbool eq(bc_MapLocation* other);
    %newobject to_json;
    char* to_json();

    bc_Planet planet;

    int32_t x;

    int32_t y;
}
%newobject bc_MapLocation_from_json;
bc_MapLocation* bc_MapLocation_from_json(char* s);


typedef struct bc_VecMapLocation {} bc_VecMapLocation;
%apply bc_VecMapLocation* INPUT { bc_VecMapLocation* a };
%extend bc_VecMapLocation {
    bc_VecMapLocation();
    ~bc_VecMapLocation();
    %newobject debug;
    char* debug();
    %newobject clone;
    bc_VecMapLocation* clone();
    %newobject len;
    uintptr_t len();
    %newobject index;
    bc_MapLocation* index(uintptr_t index);
}

typedef struct bc_Veci32 {} bc_Veci32;
%apply bc_Veci32* INPUT { bc_Veci32* a };
%extend bc_Veci32 {
    bc_Veci32();
    ~bc_Veci32();
    %newobject debug;
    char* debug();
    %newobject clone;
    bc_Veci32* clone();
    %newobject len;
    uintptr_t len();
    %newobject index;
    int32_t index(uintptr_t index);
}

typedef struct bc_Location {} bc_Location;
%apply bc_Location* INPUT { bc_Location* a };
%extend bc_Location {
    bc_Location();
    ~bc_Location();
    %newobject is_on_map;
    magicbool is_on_map();
    %newobject is_on_planet;
    magicbool is_on_planet(bc_Planet planet);
    %newobject map_location;
    bc_MapLocation* map_location();
    %newobject is_in_garrison;
    magicbool is_in_garrison();
    %newobject structure;
    uint16_t structure();
    %newobject is_in_space;
    magicbool is_in_space();
    %newobject is_adjacent_to;
    magicbool is_adjacent_to(bc_Location* o);
    %newobject is_within_range;
    magicbool is_within_range(uint32_t range, bc_Location* o);
    %newobject debug;
    char* debug();
    %newobject clone;
    bc_Location* clone();
    %newobject eq;
    magicbool eq(bc_Location* other);
    %newobject to_json;
    char* to_json();
}
%newobject bc_Location_new_on_map;
bc_Location* bc_Location_new_on_map(bc_MapLocation* map_location);

%newobject bc_Location_new_in_garrison;
bc_Location* bc_Location_new_in_garrison(uint16_t id);

%newobject bc_Location_new_in_space;
bc_Location* bc_Location_new_in_space();

%newobject bc_Location_from_json;
bc_Location* bc_Location_from_json(char* s);


/// 
#ifdef SWIGJAVA
%javaconst(1);
#endif
typedef enum bc_Team {
    Red = 0,
    Blue = 1,
} bc_Team;

%newobject bc_Team_from_json;
bc_Team bc_Team_from_json(char* s);

%newobject bc_Team_to_json;
char* bc_Team_to_json(bc_Team this);


typedef struct bc_Player {} bc_Player;
%apply bc_Player* INPUT { bc_Player* a };
%extend bc_Player {
    bc_Player(bc_Team team, bc_Planet planet);
    ~bc_Player();
    %newobject debug;
    char* debug();
    %newobject clone;
    bc_Player* clone();
    %newobject eq;
    magicbool eq(bc_Player* other);
    %newobject to_json;
    char* to_json();

    bc_Team team;

    bc_Planet planet;
}
%newobject bc_Player_from_json;
bc_Player* bc_Player_from_json(char* s);


typedef struct bc_VecUnitID {} bc_VecUnitID;
%apply bc_VecUnitID* INPUT { bc_VecUnitID* a };
%extend bc_VecUnitID {
    bc_VecUnitID();
    ~bc_VecUnitID();
    %newobject debug;
    char* debug();
    %newobject clone;
    bc_VecUnitID* clone();
    %newobject len;
    uintptr_t len();
    %newobject index;
    uint16_t index(uintptr_t index);
}

/// The different unit types, which include factories, rockets, and the robots.
#ifdef SWIGJAVA
%javaconst(1);
#endif
typedef enum bc_UnitType {
    Worker = 0,
    Knight = 1,
    Ranger = 2,
    Mage = 3,
    Healer = 4,
    Factory = 5,
    Rocket = 6,
} bc_UnitType;

%newobject bc_UnitType_from_json;
bc_UnitType bc_UnitType_from_json(char* s);

%newobject bc_UnitType_to_json;
char* bc_UnitType_to_json(bc_UnitType this);

%newobject bc_UnitType_factory_cost;
uint32_t bc_UnitType_factory_cost(bc_UnitType this);

%newobject bc_UnitType_blueprint_cost;
uint32_t bc_UnitType_blueprint_cost(bc_UnitType this);

%newobject bc_UnitType_replicate_cost;
uint32_t bc_UnitType_replicate_cost(bc_UnitType this);

%newobject bc_UnitType_value;
uint32_t bc_UnitType_value(bc_UnitType this);


typedef struct bc_VecUnitType {} bc_VecUnitType;
%apply bc_VecUnitType* INPUT { bc_VecUnitType* a };
%extend bc_VecUnitType {
    bc_VecUnitType();
    ~bc_VecUnitType();
    %newobject debug;
    char* debug();
    %newobject clone;
    bc_VecUnitType* clone();
    %newobject len;
    uintptr_t len();
    %newobject index;
    bc_UnitType index(uintptr_t index);
}

typedef struct bc_Unit {} bc_Unit;
%apply bc_Unit* INPUT { bc_Unit* a };
%extend bc_Unit {
    bc_Unit();
    ~bc_Unit();
    %newobject debug;
    char* debug();
    %newobject clone;
    bc_Unit* clone();
    %newobject to_json;
    char* to_json();
    %newobject eq;
    magicbool eq(bc_Unit* other);
    %newobject id;
    uint16_t id();
    %newobject team;
    bc_Team team();
    %newobject research_level;
    uintptr_t research_level();
    %newobject unit_type;
    bc_UnitType unit_type();
    %newobject location;
    bc_Location* location();
    %newobject health;
    uint32_t health();
    %newobject max_health;
    uint32_t max_health();
    %newobject vision_range;
    uint32_t vision_range();
    %newobject damage;
    int32_t damage();
    %newobject attack_range;
    uint32_t attack_range();
    %newobject movement_heat;
    uint32_t movement_heat();
    %newobject attack_heat;
    uint32_t attack_heat();
    %newobject movement_cooldown;
    uint32_t movement_cooldown();
    %newobject attack_cooldown;
    uint32_t attack_cooldown();
    %newobject is_ability_unlocked;
    uint8_t is_ability_unlocked();
    %newobject ability_heat;
    uint32_t ability_heat();
    %newobject ability_cooldown;
    uint32_t ability_cooldown();
    %newobject ability_range;
    uint32_t ability_range();
    %newobject worker_has_acted;
    uint8_t worker_has_acted();
    %newobject worker_build_health;
    uint32_t worker_build_health();
    %newobject worker_repair_health;
    uint32_t worker_repair_health();
    %newobject worker_harvest_amount;
    uint32_t worker_harvest_amount();
    %newobject knight_defense;
    uint32_t knight_defense();
    %newobject ranger_cannot_attack_range;
    uint32_t ranger_cannot_attack_range();
    %newobject ranger_max_countdown;
    uint32_t ranger_max_countdown();
    %newobject ranger_is_sniping;
    uint8_t ranger_is_sniping();
    %newobject ranger_target_location;
    bc_MapLocation* ranger_target_location();
    %newobject ranger_countdown;
    uint32_t ranger_countdown();
    %newobject healer_self_heal_amount;
    uint32_t healer_self_heal_amount();
    %newobject structure_is_built;
    uint8_t structure_is_built();
    %newobject structure_max_capacity;
    uintptr_t structure_max_capacity();
    %newobject structure_garrison;
    bc_VecUnitID* structure_garrison();
    %newobject is_factory_producing;
    uint8_t is_factory_producing();
    %newobject factory_unit_type;
    bc_UnitType factory_unit_type();
    %newobject factory_rounds_left;
    uint32_t factory_rounds_left();
    %newobject factory_max_rounds_left;
    uint32_t factory_max_rounds_left();
    %newobject rocket_is_used;
    uint8_t rocket_is_used();
    %newobject rocket_blast_damage;
    int32_t rocket_blast_damage();
    %newobject rocket_travel_time_decrease;
    uint32_t rocket_travel_time_decrease();
}
%newobject bc_Unit_from_json;
bc_Unit* bc_Unit_from_json(char* s);


typedef struct bc_VecUnit {} bc_VecUnit;
%apply bc_VecUnit* INPUT { bc_VecUnit* a };
%extend bc_VecUnit {
    bc_VecUnit();
    ~bc_VecUnit();
    %newobject debug;
    char* debug();
    %newobject clone;
    bc_VecUnit* clone();
    %newobject len;
    uintptr_t len();
    %newobject index;
    bc_Unit* index(uintptr_t index);
}

typedef struct bc_PlanetMap {} bc_PlanetMap;
%apply bc_PlanetMap* INPUT { bc_PlanetMap* a };
%extend bc_PlanetMap {
    bc_PlanetMap();
    ~bc_PlanetMap();
    %newobject validate;
    magicbool validate();
    %newobject on_map;
    magicbool on_map(bc_MapLocation* location);
    %newobject is_passable_terrain_at;
    uint8_t is_passable_terrain_at(bc_MapLocation* location);
    %newobject initial_karbonite_at;
    uint32_t initial_karbonite_at(bc_MapLocation* location);
    %newobject clone;
    bc_PlanetMap* clone();
    %newobject to_json;
    char* to_json();

    bc_Planet planet;

    uintptr_t height;

    uintptr_t width;

    bc_VecUnit* initial_units;
}
%newobject bc_PlanetMap_from_json;
bc_PlanetMap* bc_PlanetMap_from_json(char* s);


typedef struct bc_Delta {} bc_Delta;
%apply bc_Delta* INPUT { bc_Delta* a };
%extend bc_Delta {
    bc_Delta();
    ~bc_Delta();
    %newobject to_json;
    char* to_json();
}
%newobject bc_Delta_from_json;
bc_Delta* bc_Delta_from_json(char* s);


typedef struct bc_StartGameMessage {} bc_StartGameMessage;
%apply bc_StartGameMessage* INPUT { bc_StartGameMessage* a };
%extend bc_StartGameMessage {
    bc_StartGameMessage();
    ~bc_StartGameMessage();
    %newobject to_json;
    char* to_json();
}
%newobject bc_StartGameMessage_from_json;
bc_StartGameMessage* bc_StartGameMessage_from_json(char* s);


typedef struct bc_TurnMessage {} bc_TurnMessage;
%apply bc_TurnMessage* INPUT { bc_TurnMessage* a };
%extend bc_TurnMessage {
    bc_TurnMessage();
    ~bc_TurnMessage();
    %newobject to_json;
    char* to_json();
}
%newobject bc_TurnMessage_from_json;
bc_TurnMessage* bc_TurnMessage_from_json(char* s);


typedef struct bc_StartTurnMessage {} bc_StartTurnMessage;
%apply bc_StartTurnMessage* INPUT { bc_StartTurnMessage* a };
%extend bc_StartTurnMessage {
    bc_StartTurnMessage();
    ~bc_StartTurnMessage();
    %newobject to_json;
    char* to_json();

    int32_t time_left_ms;

    uint32_t round;
}
%newobject bc_StartTurnMessage_from_json;
bc_StartTurnMessage* bc_StartTurnMessage_from_json(char* s);


typedef struct bc_ViewerMessage {} bc_ViewerMessage;
%apply bc_ViewerMessage* INPUT { bc_ViewerMessage* a };
%extend bc_ViewerMessage {
    bc_ViewerMessage();
    ~bc_ViewerMessage();
    %newobject to_json;
    char* to_json();
}
%newobject bc_ViewerMessage_from_json;
bc_ViewerMessage* bc_ViewerMessage_from_json(char* s);


typedef struct bc_ViewerKeyframe {} bc_ViewerKeyframe;
%apply bc_ViewerKeyframe* INPUT { bc_ViewerKeyframe* a };
%extend bc_ViewerKeyframe {
    bc_ViewerKeyframe();
    ~bc_ViewerKeyframe();
    %newobject to_json;
    char* to_json();
}
%newobject bc_ViewerKeyframe_from_json;
bc_ViewerKeyframe* bc_ViewerKeyframe_from_json(char* s);


typedef struct bc_ErrorMessage {} bc_ErrorMessage;
%apply bc_ErrorMessage* INPUT { bc_ErrorMessage* a };
%extend bc_ErrorMessage {
    bc_ErrorMessage();
    ~bc_ErrorMessage();
    %newobject to_json;
    char* to_json();
    %newobject debug;
    char* debug();

    char* error;
}
%newobject bc_ErrorMessage_from_json;
bc_ErrorMessage* bc_ErrorMessage_from_json(char* s);


typedef struct bc_ReceivedMessaTurnMessage {} bc_ReceivedMessaTurnMessage;
%apply bc_ReceivedMessaTurnMessage* INPUT { bc_ReceivedMessaTurnMessage* a };
%extend bc_ReceivedMessaTurnMessage {
    bc_ReceivedMessaTurnMessage();
    ~bc_ReceivedMessaTurnMessage();
    %newobject to_json;
    char* to_json();
    %newobject debug;
    char* debug();
}
%newobject bc_ReceivedMessaTurnMessage_from_json;
bc_ReceivedMessaTurnMessage* bc_ReceivedMessaTurnMessage_from_json(char* s);


typedef struct bc_SentMessage {} bc_SentMessage;
%apply bc_SentMessage* INPUT { bc_SentMessage* a };
%extend bc_SentMessage {
    bc_SentMessage();
    ~bc_SentMessage();
    %newobject to_json;
    char* to_json();
    %newobject debug;
    char* debug();

    char* client_id;

    bc_TurnMessage* turn_message;
}
%newobject bc_SentMessage_from_json;
bc_SentMessage* bc_SentMessage_from_json(char* s);


typedef struct bc_TurnApplication {} bc_TurnApplication;
%apply bc_TurnApplication* INPUT { bc_TurnApplication* a };
%extend bc_TurnApplication {
    bc_TurnApplication();
    ~bc_TurnApplication();

    bc_StartTurnMessage* start_turn;

    int32_t start_turn_error;

    bc_ViewerMessage* viewer;
}

typedef struct bc_InitialTurnApplication {} bc_InitialTurnApplication;
%apply bc_InitialTurnApplication* INPUT { bc_InitialTurnApplication* a };
%extend bc_InitialTurnApplication {
    bc_InitialTurnApplication();
    ~bc_InitialTurnApplication();

    bc_StartTurnMessage* start_turn;

    bc_ViewerKeyframe* viewer;
}

typedef struct bc_AsteroidStrike {} bc_AsteroidStrike;
%apply bc_AsteroidStrike* INPUT { bc_AsteroidStrike* a };
%extend bc_AsteroidStrike {
    bc_AsteroidStrike(uint32_t karbonite, bc_MapLocation* location);
    ~bc_AsteroidStrike();
    %newobject clone;
    bc_AsteroidStrike* clone();
    %newobject debug;
    char* debug();
    %newobject to_json;
    char* to_json();
    %newobject eq;
    magicbool eq(bc_AsteroidStrike* other);

    uint32_t karbonite;

    bc_MapLocation* location;
}
%newobject bc_AsteroidStrike_from_json;
bc_AsteroidStrike* bc_AsteroidStrike_from_json(char* s);


typedef struct bc_AsteroidPattern {} bc_AsteroidPattern;
%apply bc_AsteroidPattern* INPUT { bc_AsteroidPattern* a };
%extend bc_AsteroidPattern {
    bc_AsteroidPattern(uint16_t seed, bc_PlanetMap* mars_map);
    ~bc_AsteroidPattern();
    %newobject validate;
    magicbool validate();
    %newobject has_asteroid;
    magicbool has_asteroid(uint32_t round);
    %newobject asteroid;
    bc_AsteroidStrike* asteroid(uint32_t round);
    %newobject clone;
    bc_AsteroidPattern* clone();
    %newobject debug;
    char* debug();
    %newobject to_json;
    char* to_json();
}
%newobject bc_AsteroidPattern_from_json;
bc_AsteroidPattern* bc_AsteroidPattern_from_json(char* s);


typedef struct bc_OrbitPattern {} bc_OrbitPattern;
%apply bc_OrbitPattern* INPUT { bc_OrbitPattern* a };
%extend bc_OrbitPattern {
    bc_OrbitPattern(uint32_t amplitude, uint32_t period, uint32_t center);
    ~bc_OrbitPattern();
    %newobject validate;
    magicbool validate();
    %newobject duration;
    uint32_t duration(uint32_t round);
    %newobject to_json;
    char* to_json();

    uint32_t amplitude;

    uint32_t period;

    uint32_t center;
}
%newobject bc_OrbitPattern_from_json;
bc_OrbitPattern* bc_OrbitPattern_from_json(char* s);


typedef struct bc_GameMap {} bc_GameMap;
%apply bc_GameMap* INPUT { bc_GameMap* a };
%extend bc_GameMap {
    bc_GameMap();
    ~bc_GameMap();
    %newobject validate;
    void validate();
    %newobject clone;
    bc_GameMap* clone();
    %newobject to_json;
    char* to_json();

    uint16_t seed;

    bc_PlanetMap* earth_map;

    bc_PlanetMap* mars_map;

    bc_AsteroidPattern* asteroids;

    bc_OrbitPattern* orbit;
}
%newobject bc_GameMap_test_map;
bc_GameMap* bc_GameMap_test_map();

%newobject bc_GameMap_parse_text_map;
bc_GameMap* bc_GameMap_parse_text_map(char* map);

%newobject bc_GameMap_from_json;
bc_GameMap* bc_GameMap_from_json(char* s);


%newobject max_level;
uintptr_t max_level(bc_UnitType branch);
%newobject cost_of;
uint32_t cost_of(bc_UnitType branch, uintptr_t level);
typedef struct bc_ResearchInfo {} bc_ResearchInfo;
%apply bc_ResearchInfo* INPUT { bc_ResearchInfo* a };
%extend bc_ResearchInfo {
    bc_ResearchInfo();
    ~bc_ResearchInfo();
    %newobject get_level;
    uintptr_t get_level(bc_UnitType branch);
    %newobject queue;
    bc_VecUnitType* queue();
    %newobject has_next_in_queue;
    magicbool has_next_in_queue();
    %newobject next_in_queue;
    bc_UnitType next_in_queue();
    %newobject rounds_left;
    uint32_t rounds_left();
    %newobject to_json;
    char* to_json();
}
%newobject bc_ResearchInfo_from_json;
bc_ResearchInfo* bc_ResearchInfo_from_json(char* s);


typedef struct bc_RocketLanding {} bc_RocketLanding;
%apply bc_RocketLanding* INPUT { bc_RocketLanding* a };
%extend bc_RocketLanding {
    bc_RocketLanding(uint16_t rocket_id, bc_MapLocation* destination);
    ~bc_RocketLanding();
    %newobject clone;
    bc_RocketLanding* clone();
    %newobject debug;
    char* debug();
    %newobject to_json;
    char* to_json();
    %newobject eq;
    magicbool eq(bc_RocketLanding* other);

    uint16_t rocket_id;

    bc_MapLocation* destination;
}
%newobject bc_RocketLanding_from_json;
bc_RocketLanding* bc_RocketLanding_from_json(char* s);


typedef struct bc_VecRocketLanding {} bc_VecRocketLanding;
%apply bc_VecRocketLanding* INPUT { bc_VecRocketLanding* a };
%extend bc_VecRocketLanding {
    bc_VecRocketLanding();
    ~bc_VecRocketLanding();
    %newobject debug;
    char* debug();
    %newobject clone;
    bc_VecRocketLanding* clone();
    %newobject len;
    uintptr_t len();
    %newobject index;
    bc_RocketLanding* index(uintptr_t index);
}

typedef struct bc_RocketLandingInfo {} bc_RocketLandingInfo;
%apply bc_RocketLandingInfo* INPUT { bc_RocketLandingInfo* a };
%extend bc_RocketLandingInfo {
    bc_RocketLandingInfo();
    ~bc_RocketLandingInfo();
    %newobject landings_on;
    bc_VecRocketLanding* landings_on(uint32_t round);
    %newobject clone;
    bc_RocketLandingInfo* clone();
    %newobject debug;
    char* debug();
    %newobject to_json;
    char* to_json();
    %newobject eq;
    magicbool eq(bc_RocketLandingInfo* other);
}
%newobject bc_RocketLandingInfo_from_json;
bc_RocketLandingInfo* bc_RocketLandingInfo_from_json(char* s);


typedef struct bc_GameController {} bc_GameController;
%apply bc_GameController* INPUT { bc_GameController* a };
%extend bc_GameController {
    bc_GameController();
    ~bc_GameController();
    %newobject next_turn;
    void next_turn();
    %newobject get_time_left_ms;
    int32_t get_time_left_ms();
    %newobject round;
    uint32_t round();
    %newobject planet;
    bc_Planet planet();
    %newobject team;
    bc_Team team();
    %newobject starting_map;
    bc_PlanetMap* starting_map(bc_Planet planet);
    %newobject karbonite;
    uint32_t karbonite();
    %newobject unit;
    bc_Unit* unit(uint16_t id);
    %newobject units;
    bc_VecUnit* units();
    %newobject my_units;
    bc_VecUnit* my_units();
    %newobject units_in_space;
    bc_VecUnit* units_in_space();
    %newobject karbonite_at;
    uint32_t karbonite_at(bc_MapLocation* location);
    %newobject all_locations_within;
    bc_VecMapLocation* all_locations_within(bc_MapLocation* location, uint32_t radius_squared);
    %newobject can_sense_location;
    magicbool can_sense_location(bc_MapLocation* location);
    %newobject can_sense_unit;
    magicbool can_sense_unit(uint16_t id);
    %newobject sense_nearby_units;
    bc_VecUnit* sense_nearby_units(bc_MapLocation* location, uint32_t radius);
    %newobject sense_nearby_units_by_team;
    bc_VecUnit* sense_nearby_units_by_team(bc_MapLocation* location, uint32_t radius, bc_Team team);
    %newobject sense_nearby_units_by_type;
    bc_VecUnit* sense_nearby_units_by_type(bc_MapLocation* location, uint32_t radius, bc_UnitType unit_type);
    %newobject has_unit_at_location;
    magicbool has_unit_at_location(bc_MapLocation* location);
    %newobject sense_unit_at_location;
    bc_Unit* sense_unit_at_location(bc_MapLocation* location);
    %newobject asteroid_pattern;
    bc_AsteroidPattern* asteroid_pattern();
    %newobject orbit_pattern;
    bc_OrbitPattern* orbit_pattern();
    %newobject current_duration_of_flight;
    uint32_t current_duration_of_flight();
    %newobject get_team_array;
    bc_Veci32* get_team_array(bc_Planet planet);
    %newobject write_team_array;
    void write_team_array(uintptr_t index, int32_t value);
    %newobject disintegrate_unit;
    void disintegrate_unit(uint16_t unit_id);
    %newobject is_occupiable;
    uint8_t is_occupiable(bc_MapLocation* location);
    %newobject can_move;
    magicbool can_move(uint16_t robot_id, bc_Direction direction);
    %newobject is_move_ready;
    magicbool is_move_ready(uint16_t robot_id);
    %newobject move_robot;
    void move_robot(uint16_t robot_id, bc_Direction direction);
    %newobject can_attack;
    magicbool can_attack(uint16_t robot_id, uint16_t target_unit_id);
    %newobject is_attack_ready;
    magicbool is_attack_ready(uint16_t robot_id);
    %newobject attack;
    void attack(uint16_t robot_id, uint16_t target_unit_id);
    %newobject research_info;
    bc_ResearchInfo* research_info();
    %newobject reset_research;
    uint8_t reset_research();
    %newobject queue_research;
    uint8_t queue_research(bc_UnitType branch);
    %newobject can_harvest;
    magicbool can_harvest(uint16_t worker_id, bc_Direction direction);
    %newobject harvest;
    void harvest(uint16_t worker_id, bc_Direction direction);
    %newobject can_blueprint;
    magicbool can_blueprint(uint16_t worker_id, bc_UnitType unit_type, bc_Direction direction);
    %newobject blueprint;
    void blueprint(uint16_t worker_id, bc_UnitType structure_type, bc_Direction direction);
    %newobject can_build;
    magicbool can_build(uint16_t worker_id, uint16_t blueprint_id);
    %newobject build;
    void build(uint16_t worker_id, uint16_t blueprint_id);
    %newobject can_repair;
    magicbool can_repair(uint16_t worker_id, uint16_t structure_id);
    %newobject repair;
    void repair(uint16_t worker_id, uint16_t structure_id);
    %newobject can_replicate;
    magicbool can_replicate(uint16_t worker_id, bc_Direction direction);
    %newobject replicate;
    void replicate(uint16_t worker_id, bc_Direction direction);
    %newobject can_javelin;
    magicbool can_javelin(uint16_t knight_id, uint16_t target_unit_id);
    %newobject is_javelin_ready;
    magicbool is_javelin_ready(uint16_t knight_id);
    %newobject javelin;
    void javelin(uint16_t knight_id, uint16_t target_unit_id);
    %newobject can_begin_snipe;
    magicbool can_begin_snipe(uint16_t ranger_id, bc_MapLocation* location);
    %newobject is_begin_snipe_ready;
    magicbool is_begin_snipe_ready(uint16_t ranger_id);
    %newobject begin_snipe;
    void begin_snipe(uint16_t ranger_id, bc_MapLocation* location);
    %newobject can_blink;
    magicbool can_blink(uint16_t mage_id, bc_MapLocation* location);
    %newobject is_blink_ready;
    magicbool is_blink_ready(uint16_t mage_id);
    %newobject blink;
    void blink(uint16_t mage_id, bc_MapLocation* location);
    %newobject can_heal;
    magicbool can_heal(uint16_t healer_id, uint16_t target_robot_id);
    %newobject is_heal_ready;
    magicbool is_heal_ready(uint16_t healer_id);
    %newobject heal;
    void heal(uint16_t healer_id, uint16_t target_robot_id);
    %newobject can_overcharge;
    magicbool can_overcharge(uint16_t healer_id, uint16_t target_robot_id);
    %newobject is_overcharge_ready;
    magicbool is_overcharge_ready(uint16_t healer_id);
    %newobject overcharge;
    void overcharge(uint16_t healer_id, uint16_t target_robot_id);
    %newobject can_load;
    magicbool can_load(uint16_t structure_id, uint16_t robot_id);
    %newobject load;
    void load(uint16_t structure_id, uint16_t robot_id);
    %newobject can_unload;
    magicbool can_unload(uint16_t structure_id, bc_Direction direction);
    %newobject unload;
    void unload(uint16_t structure_id, bc_Direction direction);
    %newobject can_produce_robot;
    magicbool can_produce_robot(uint16_t factory_id, bc_UnitType robot_type);
    %newobject produce_robot;
    void produce_robot(uint16_t factory_id, bc_UnitType robot_type);
    %newobject rocket_landings;
    bc_RocketLandingInfo* rocket_landings();
    %newobject can_launch_rocket;
    magicbool can_launch_rocket(uint16_t rocket_id, bc_MapLocation* destination);
    %newobject launch_rocket;
    void launch_rocket(uint16_t rocket_id, bc_MapLocation* location);
    %newobject start_game;
    bc_StartGameMessage* start_game(bc_Player* player);
    %newobject apply_turn;
    bc_TurnApplication* apply_turn(bc_TurnMessage* turn, int32_t time_left_ms);
    %newobject initial_start_turn_message;
    bc_InitialTurnApplication* initial_start_turn_message(int32_t time_left_ms);
    %newobject is_over;
    magicbool is_over();
    %newobject winning_team;
    bc_Team winning_team();
    %newobject manager_viewer_message;
    char* manager_viewer_message();
    %newobject print_game_ansi;
    void print_game_ansi();
    %newobject manager_karbonite;
    uint32_t manager_karbonite(bc_Team team);
}
%newobject bc_GameController_new_manager;
bc_GameController* bc_GameController_new_manager(bc_GameMap* map);


