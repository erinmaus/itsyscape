#include "Resources/Shaders/Matrix.common.glsl"

#ifndef SCAPE_MAX_NUM_POINTS
	#define SCAPE_MAX_NUM_POINTS 64
#endif

#ifndef SCAPE_MAX_NUM_POINTS_SINGLE_CURVE
	#define SCAPE_MAX_NUM_POINTS_SINGLE_CURVE 16
#endif

#ifndef SCAPE_MAX_NUM_CURVES
	#define SCAPE_MAX_NUM_CURVES 8
#endif

uniform vec3 scape_CurvePoints[SCAPE_MAX_NUM_POINTS];

uniform struct Curve {
	vec3 axis;
	ivec2 offset; // x = start, y = count
	vec4 size; // xy = (min x, min z), zw = (max x, max z)
} scape_Curves[SCAPE_MAX_NUM_CURVES];

uniform int scape_NumCurves;

vec3[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] getEmptyCurve()
{
	vec3 result[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE];
	for (int i = 0; i < SCAPE_MAX_NUM_POINTS_SINGLE_CURVE; ++i)
	{
		result[i] = vec3(0.0);
	}

	return result;
}

vec3[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] getCurve(int index)
{
	vec3[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] result = getEmptyCurve();

	index = clamp(index, 0, min(SCAPE_MAX_NUM_CURVES, scape_NumCurves));

	ivec2 offset = scape_Curves[index].offset;
	int start = max(offset.x, 0);
	int end = clamp(offset.x + min(offset.y, SCAPE_MAX_NUM_POINTS_SINGLE_CURVE), 0, SCAPE_MAX_NUM_POINTS);

	int outputIndex = 0;
	for (int i = start; i < end; ++i)
	{
		result[outputIndex] = scape_CurvePoints[i];
		++outputIndex;
	}

	return result;
}

vec3[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] getCurveDerivative(vec3 curve[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE], int numPoints)
{
	float degree = float(numPoints) - 1.0;

	vec3 result[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] = getEmptyCurve();
	for (int i = 0; i < numPoints - 1; ++i)
	{
		result[i] = (curve[i + 1] - curve[i]) * degree;
	}

	return result;
}

vec3 evaluateCurve(vec3 curve[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE], int numPoints, float t)
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

vec4 transformPointByCurve(int index, vec3 point)
{
	Curve curve = scape_Curves[index];

	vec3 curveMin = vec3(curve.size.x, 0.0, curve.size.y);
	vec3 curveMax = vec3(curve.size.z, 0.0, curve.size.w);
	vec3 planarPoint = vec3(point.x, 0.0, point.z);

	vec3 relative = (planarPoint - curveMin) / (curveMax - curveMin);
	float t = min(relative.x, relative.z);
	if (t < 0.0 || t > 1.0)
	{
		return vec4(point, 1.0);
	}

	int numPoints = curve.offset.y;
	vec3[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] currentCurve = getCurve(index);
	vec3[SCAPE_MAX_NUM_POINTS_SINGLE_CURVE] tangents = getCurveDerivative(currentCurve, numPoints);
	vec3 tangent1 = normalize(evaluateCurve(tangents, numPoints - 1, t));
	vec3 tangent2 = normalize(evaluateCurve(tangents, numPoints - 1, t + 0.01));

	vec3 axis = normalize(cross(tangent2, tangent1));
	float d = dot(tangent1, curve.axis);
	float angle = acos(d);
	mat4 rotation = rotateByAxis(axis, angle);

	return rotation * vec4(point, 1.0);
}

vec3 transformPointByCurves(vec3 point)
{
	for (int i = 0; i < scape_NumCurves; ++i)
	{
		point = transformPointByCurve(i, point).xyz;
	}

	return point;
}
