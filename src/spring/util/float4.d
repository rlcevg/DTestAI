module spring.util.float4;

auto SQUARE = (float x) => x * x;

union SFloat4 {
	float[4] a = [0, 0, 0, 0];
	struct Sxyzw {
		float x;
		float y;
		float z;
		float w;
	}
	Sxyzw s;
	alias s this;

nothrow @nogc:
	inout(float*) ptr() inout return { return a.ptr; }

	this(float _x, float _y, float _z, float _w = 0) {
		s.x = _x;
		s.y = _y;
		s.z = _z;
		s.w = _w;
	}

	this(in float[3] xyz) {
		s.x = xyz[0];
		s.y = xyz[1];
		s.z = xyz[2];
		s.w = 0;
	}

	this(in float* xyz) {
		s.x = xyz[0];
		s.y = xyz[1];
		s.z = xyz[2];
		s.w = 0;
	}

	deprecated("Use this.ptr")
	void loadInto(out float[3] xyz) const {
		xyz[0] = s.x;
		xyz[1] = s.y;
		xyz[2] = s.z;
	}

	float sqDistance2(in SFloat4 other) const {
		return SQUARE(other.x - x) + SQUARE(other.z - z);
	}
}
