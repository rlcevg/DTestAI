module spring.util.color4;

struct SColor4 {
	ubyte r = 0;
	ubyte g = 0;
	ubyte b = 0;
	ubyte a = 255;

	this(ubyte _r, ubyte _g, ubyte _b, ubyte _a = 255) {
		r = _r;
		g = _g;
		b = _b;
		a = _a;
	}

	this(float _r, float _g, float _b, float _a = 1.0f) {
		assert((_r <= 1.0f) && (_r >= 0.0f));
		assert((_g <= 1.0f) && (_g >= 0.0f));
		assert((_b <= 1.0f) && (_b >= 0.0f));
		assert((_a <= 1.0f) && (_a >= 0.0f));
		r = cast(ubyte)(_r * 255);
		g = cast(ubyte)(_g * 255);
		b = cast(ubyte)(_b * 255);
		a = cast(ubyte)(_a * 255);
	}

	this(in short[3] rgb) {
		r = cast(ubyte)rgb[0];
		g = cast(ubyte)rgb[1];
		b = cast(ubyte)rgb[2];
		a = 255;
	}

	void loadInto(out short[3] rgb) const {
		rgb[0] = r;
		rgb[1] = g;
		rgb[2] = b;
	}

	void loadInto(out short[4] rgba) const {
		rgba[0] = r;
		rgba[1] = g;
		rgba[2] = b;
		rgba[3] = a;
	}
}
