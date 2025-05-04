#include "Resources/Shaders/Quaternion.common.glsl"

#ifndef SCAPE_MAX_NUM_CURVES
	#define SCAPE_MAX_NUM_CURVES 8
#endif

uniform vec2 scape_MapSize;

#define SCAPE_NUM_CURVE_TEXTURE_VECTORS 3.0
#define SCAPE_CURVE_TEXTURE_POSITION    0.0 / (SCAPE_NUM_CURVE_TEXTURE_VECTORS - 1.0)
#define SCAPE_CURVE_TEXTURE_NORMAL      1.0 / (SCAPE_NUM_CURVE_TEXTURE_VECTORS - 1.0)
#define SCAPE_CURVE_TEXTURE_ROTATION    2.0 / (SCAPE_NUM_CURVE_TEXTURE_VECTORS - 1.0)

uniform int scape_NumCurves;
uniform struct Curve {
	vec3 axis;
	vec4 size; // xy = (min x, min z), zw = (max x, max z)
} scape_Curves[SCAPE_MAX_NUM_CURVES];
uniform ArrayImage scape_CurveTextures;

vec3 transformPointByCurve(int index, vec3 point)
{
	Curve curve = scape_Curves[index];

	vec3 curveMin = vec3(curve.size.x, 0.0, curve.size.y);
	vec3 curveMax = vec3(curve.size.z, 0.0, curve.size.w);
	vec3 planarPoint = vec3(point.x, 0.0, point.z);

	vec3 relative = (planarPoint - curveMin) / (curveMax - curveMin) * curve.axis;
	float t = max(relative.x, relative.z);
	if (t < 0.0 || t > 1.0)
	{
		return point;
	}

	vec3 position = Texel(scape_CurveTextures, vec3(t, SCAPE_CURVE_TEXTURE_POSITION, float(index))).xyz;
	vec3 normal = Texel(scape_CurveTextures, vec3(t, SCAPE_CURVE_TEXTURE_NORMAL, float(index))).xyz;
	vec4 rotation = Texel(scape_CurveTextures, vec3(t, SCAPE_CURVE_TEXTURE_ROTATION, float(index)));

	vec3 oppositeAxis = normalize(cross(vec3(0.0, 1.0, 0.0), curve.axis));
 	vec3 up = vec3(point.y) * normal;
 	vec3 center = oppositeAxis * vec3(scape_MapSize.x / 2.0, 0.0, scape_MapSize.y / 2.0);
 	vec3 relativePoint = oppositeAxis * point - center + up;
 	relativePoint = quaternionTransformVector(rotation, vec4(relativePoint, 0.0)).xyz;

 	return position + relativePoint;
}

vec3 transformPointByCurves(vec3 point)
{
	for (int i = 0; i < scape_NumCurves; ++i)
	{
		point = transformPointByCurve(i, point);
	}

	return point;
}
