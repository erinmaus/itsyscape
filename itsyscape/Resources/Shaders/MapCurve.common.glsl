#include "Resources/Shaders/Quaternion.common.glsl"

#ifndef SCAPE_MAX_NUM_POINTS
	#define SCAPE_MAX_NUM_POINTS 64
#endif

#ifndef SCAPE_MAX_NUM_POINTS_SINGLE_CURVE
	#define SCAPE_MAX_NUM_POINTS_SINGLE_CURVE 16
#endif

#ifndef SCAPE_MAX_NUM_CURVES
	#define SCAPE_MAX_NUM_CURVES 8
#endif

uniform vec2 scape_MapSize;

uniform vec4 scape_CurveTranslations[SCAPE_MAX_NUM_POINTS];
uniform vec4 scape_CurveRotations[SCAPE_MAX_NUM_POINTS];

uniform struct Curve {
	vec3 axis;
	ivec4 offset; // x = start, y = count
	vec4 size; // xy = (min x, min z), zw = (max x, max z)
} scape_Curves[SCAPE_MAX_NUM_CURVES];

uniform int scape_NumCurves;

vec4[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] getEmptyCurve()
{
	vec4 result[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE];
	for (int i = 0; i < SCAPE_MAX_NUM_POINTS_SINGLE_CURVE; ++i)
	{
		result[i] = vec4(0.0);
	}

	return result;
}

vec4[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] getTranslationCurve(int index)
{
	vec4[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] result = getEmptyCurve();

	index = clamp(index, 0, min(SCAPE_MAX_NUM_CURVES, scape_NumCurves));

	ivec2 offset = scape_Curves[index].offset.xy;
	int start = max(offset.x, 0);
	int end = clamp(offset.x + min(offset.y, SCAPE_MAX_NUM_POINTS_SINGLE_CURVE), 0, SCAPE_MAX_NUM_POINTS);

	int outputIndex = 0;
	for (int i = start; i < end; ++i)
	{
		result[outputIndex] = scape_CurveTranslations[i];
		++outputIndex;
	}

	return result;
}

vec4[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] getRotationCurve(int index)
{
	vec4[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] result = getEmptyCurve();

	index = clamp(index, 0, min(SCAPE_MAX_NUM_CURVES, scape_NumCurves));

	ivec2 offset = scape_Curves[index].offset.zw;
	int start = max(offset.x, 0);
	int end = clamp(offset.x + min(offset.y, SCAPE_MAX_NUM_POINTS_SINGLE_CURVE), 0, SCAPE_MAX_NUM_POINTS);

	int outputIndex = 0;
	for (int i = start; i < end; ++i)
	{
		result[outputIndex] = scape_CurveRotations[i];
		++outputIndex;
	}

	return result;
}

vec4[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] getCurveDerivative(vec4 curve[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE], int numPoints)
{
	float degree = float(numPoints) - 1.0;

	vec4 result[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] = getEmptyCurve();
	for (int i = 0; i < numPoints - 1; ++i)
	{
		result[i] = (curve[i + 1] - curve[i]) * degree;
	}

	return result;
}

vec4 lerpCurve(vec4 curve[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE], int numPoints, float t)
{
	for (int step = 1; step < numPoints; ++step)
	{
		for (int i = 0; i < numPoints - step; ++i)
		{
			curve[i] = curve[i] * (1.0 - t) + curve[i + 1] * t;
		}
	}

	return curve[0];
}

vec4 slerpCurve(vec4 curve[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE], int numPoints, float t)
{
	for (int step = 1; step < numPoints; ++step)
	{
		for (int i = 0; i < numPoints - step; ++i)
		{
			curve[i] = normalize(slerp(normalize(curve[i]), normalize(curve[i + 1]), t));
		}
	}

	return curve[0];
}

vec4 transformPointByCurve(int index, vec3 point)
{
	Curve curve = scape_Curves[index];

	vec3 curveMin = vec3(curve.size.x, 0.0, curve.size.y);
	vec3 curveMax = vec3(curve.size.z, 0.0, curve.size.w);
	vec3 planarPoint = vec3(point.x, 0.0, point.z);

	vec3 relative = (planarPoint - curveMin) / (curveMax - curveMin) * curve.axis;
	float t = max(relative.x, relative.z);
	if (t < 0.0 || t > 1.0)
	{
		return vec4(point, 1.0);
	}

	int numPoints = curve.offset.y;
	int numRotations = curve.offset.w;
	vec4[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] translationCurve = getTranslationCurve(index);
	vec4[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] rotationCurve = getRotationCurve(index);
	vec4[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] tangentCurve = getCurveDerivative(translationCurve, numPoints);
	vec4 position = lerpCurve(translationCurve, numPoints, t);
	vec4 rotation = slerpCurve(rotationCurve, numRotations, t);
	vec3 direction = normalize(lerpCurve(tangentCurve, numPoints - 1, t)).xyz;

	vec3 oppositeAxis = normalize(cross(vec3(0.0, 1.0, 0.0), curve.axis));
	vec3 axis = normalize(cross(curve.axis, direction));
	vec4 orientation = vec4(axis, 1.0 + dot(curve.axis, direction));
	vec3 up = quaternionTransformVector(orientation, vec4(0.0, point.y, 0.0, 0.0)).xyz;
	//vec3 up = vec3(0.0);
	vec3 center = oppositeAxis * vec3(scape_MapSize.x / 2.0, 0.0, scape_MapSize.y / 2.0);
	vec3 relativePoint = oppositeAxis * point + up - center;
	relativePoint = quaternionTransformVector(rotation, vec4(relativePoint, 0.0)).xyz;

	return vec4(position.xyz + relativePoint, 1.0);
}

vec3 transformPointByCurves(vec3 point)
{
	for (int i = 0; i < scape_NumCurves; ++i)
	{
		point = transformPointByCurve(i, point).xyz;
	}

	return point;
}
