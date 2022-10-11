module spring.map.line;

import spring.bind.callback;
import spring.util.float4;
import spring.util.color4;

struct SLine {
	mixin TEntity;

	SFloat4 getFirstPosition() const {
		SFloat4 posF3_out;
		gCallback.Map_Line_getFirstPosition(gSkirmishAIId, id, posF3_out.ptr);
		return posF3_out;
	}

	SFloat4 getSecondPosition() const {
		SFloat4 posF3_out;
		gCallback.Map_Line_getSecondPosition(gSkirmishAIId, id, posF3_out.ptr);
		return posF3_out;
	}

	SColor4 getColor() const {
		short[3] colorS3_out;
		gCallback.Map_Line_getColor(gSkirmishAIId, id, colorS3_out.ptr);
		return SColor4(colorS3_out);
	}
}
