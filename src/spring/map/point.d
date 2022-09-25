module spring.map.point;

import spring.bind.callback;
import spring.util.float4;
import spring.util.color4;
static import std.conv;

struct SPoint {
	mixin TEntity;

	SFloat4 getPosition() const {
		SFloat4 posF3_out;
		gCallback.Map_Point_getPosition(gSkirmishAIId, id, posF3_out.ptr);
		return posF3_out;
	}

	SColor4 getColor() const {
		short[3] colorS3_out;
		gCallback.Map_Point_getColor(gSkirmishAIId, id, colorS3_out.ptr);
		return SColor4(colorS3_out);
	}

	string getLabel() const {
		return std.conv.to!string(gCallback.Map_Point_getLabel(gSkirmishAIId, _id));
	}
}
