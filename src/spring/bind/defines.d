module spring.bind.defines;

enum FRAMES_PER_SEC = 30;
enum SQUARE_SIZE = 8;

enum UnitFacing {
	UNIT_NO_FACING    = -1,  // UNIT_COMMAND_BUILD_NO_FACING
	UNIT_FACING_SOUTH = 0,  // z++
	UNIT_FACING_EAST  = 1,  // x++
	UNIT_FACING_NORTH = 2,  // z--
	UNIT_FACING_WEST  = 3,  // x--
}
