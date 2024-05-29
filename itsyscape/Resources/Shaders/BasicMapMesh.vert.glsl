#line 1

uniform float scape_Time;
attribute vec4 VertexTileBounds;
attribute vec4 VertexTextureLayer;

varying highp vec4 frag_TileBounds;
varying highp vec4 frag_TextureLayer;

#define SCAPE_MAX_NUM_POINTS 3
const vec3 scape_Curve[SCAPE_MAX_NUM_POINTS] = vec3[](
	// vec3(0.0, 0.0, 0.0),
	// vec3(0.0, 0.0, 8.0),
	// vec3(0.0, 0.0, 24.0),
	// vec3(32.0, 0.0, 64.0),
	// vec3(),
	vec3(cos(0.0) * 16, 0.0, sin(0.0) * 32),
	vec3(cos(3.14 / 2) * 16, 8.0, sin(3.14 / 2) * 32),
	vec3(cos(3.14 * 1.5) * 16, -8.0, sin(3.14 * 1.5) * 32)
	// vec3(55.0, 4.0, 32.0),
	// vec3(11.0, 8.0, 51.0),
	// vec3(11.0, 8.0, 51.0),
	// vec3(47.0, 12.0, 80.0)
);

const float scape_Min = 0.0;
const float scape_Max = 128.0;

vec3[SCAPE_MAX_NUM_POINTS] getDerivative(vec3 curve[SCAPE_MAX_NUM_POINTS], int numPoints)
{
	float degree = float(numPoints) - 1.0;

	vec3 result[SCAPE_MAX_NUM_POINTS];
	for (int i = 0; i < SCAPE_MAX_NUM_POINTS; ++i)
	{
		result[i] = vec3(0.0);
	}

	for (int i = 0; i < numPoints - 1; ++i)
	{
		result[i] = (curve[i + 1] - curve[i]) * degree;
	}

	return result;
}

vec3 evaluate(vec3 curve[SCAPE_MAX_NUM_POINTS], int numPoints, float t)
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

mat4 rotate(vec3 axis, float angle)
{
	axis = normalize(axis);
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;

	return mat4(
		oc * axis.x * axis.x + c,
		oc * axis.x * axis.y - axis.z * s,
		oc * axis.z * axis.x + axis.y * s,
		0.0,

		oc * axis.x * axis.y + axis.z * s,
		oc * axis.y * axis.y + c,
		oc * axis.y * axis.z - axis.x * s,
		0.0,

		oc * axis.z * axis.x - axis.y * s,
		oc * axis.y * axis.z + axis.x * s,
		oc * axis.z * axis.z + c,
		0.0,

		0.0,
		0.0,
		0.0,
		1.0
	);
}

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	float t = (position.z - scape_Min) / (scape_Max - scape_Min);
	vec3[SCAPE_MAX_NUM_POINTS] curve = scape_Curve;
	curve[1].x += sin(scape_Time) * 5.0;
	curve[2].y += sin(scape_Time * 0.25) * 32.0;
	vec3[SCAPE_MAX_NUM_POINTS] tangents = getDerivative(curve, SCAPE_MAX_NUM_POINTS);
	vec3 tangent1 = normalize(evaluate(tangents, SCAPE_MAX_NUM_POINTS - 1, t));
	vec3 tangent2 = normalize(evaluate(tangents, SCAPE_MAX_NUM_POINTS - 1, t + 0.01));
	vec4 curvePosition = vec4(evaluate(curve, SCAPE_MAX_NUM_POINTS, t), 0.0);
	vec3 position1 = normalize(evaluate(curve, SCAPE_MAX_NUM_POINTS, t));
	vec3 position2 = normalize(evaluate(curve, SCAPE_MAX_NUM_POINTS, t + 0.01));
	// vec3 tangent1 = normalize(evaluate(scape_Curve, SCAPE_MAX_NUM_POINTS, t));
	// vec3 tangent2 = normalize(evaluate(scape_Curve, SCAPE_MAX_NUM_POINTS, t + 0.1));
	vec3 axis = normalize(cross(tangent2, tangent1));
	// vec3 axis = normalize(tangent1);
	// vec3 axis = cross(c, tangent1);
	// vec3 axis = cross(tangent1, tangent2);

	float d = dot(tangent1, vec3(0.0, 0.0, 1.0));
	float angle = acos(d);
	mat4 rotation = rotate(axis, angle);

	// vec4 warpedPosition = rotation * (position - curvePosition) + curvePosition;
	//vec4 warpedPosition = rotation * (position - vec4(32.0, 0.0, 32.0, 0.0)) + vec4(32.0, 0.0, 32.0, 0.0);
	//vec4 warpedPosition = rotation * (position - curvePosition) + curvePosition;
	// vec4 warpedPosition = rotation * position;
	vec4 warpedPosition = position;
	// vec4 warpedPosition = (position - vec4(32.0, 0.0, 32.0, 0.0)) + curvePosition;
	// vec4 warpedPosition =  + curvePosition;
	// vec4 warpedPosition = rotation * position + curvePosition;
	//vec4 warpedPosition = rotation * (position - vec4(32.0, 0.0, 32.0, 0.0)) + vec4(32.0, 0.0, 32.0, 0.0);
	//vec4 warpedPosition = position + vec4(axis, 0.0);

	// vec4 warpedPosition = (position - vec4(scape_Curve[0], 0.0)) + curvePosition;
	// vec4 warpedPosition = position + vec4(0.0, length(tangent1), 0.0, 0.0);
	// vec4 warpedPosition = vec4(tangent1, 1.0) * length(position);
	// vec4 warpedPosition = position + vec4(tangent1, 0.0);

	localPosition = warpedPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * warpedPosition;
	frag_TileBounds = VertexTileBounds;
	frag_TextureLayer = VertexTextureLayer;
	// frag_Color = vec4(length(abs(dot(axis, vec3(0.0, 1.0, 0.0)))), 0.0, 0.0, 1.0);
	//frag_Color = vec4(abs(d), 0.0, 0.0, 1.0);
}
