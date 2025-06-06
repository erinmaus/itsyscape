#define SCAPE_TONE_MAP_MAX_CURVES 16

uniform int scape_RGBCurveCount;
uniform struct RGBCurve {
	vec3 start, middle, end;
} scape_RGBCurves[SCAPE_TONE_MAP_MAX_CURVES];

uniform int scape_HSLCurveCount;
uniform struct HSLCurve
{
	vec3 min;
	vec3 max;
	vec3 start, middle, end;
} scape_HSLCurves[SCAPE_TONE_MAP_MAX_CURVES];

#include "Resources/Shaders/Color.common.glsl"
#include "Resources/Shaders/Curve.common.glsl"

const float EPSILON = 1e-3;
const float UPPER_EPSILON = EPSILON + 1.0;
const float LOWER_EPSILON = -EPSILON;

void applyHSLCurve(in HSLCurve curve, inout vec3 color)
{
	vec3 delta = (color - curve.min) / (curve.max - curve.min);
	if (delta.x >= LOWER_EPSILON && delta.x <= UPPER_EPSILON &&
		delta.y >= LOWER_EPSILON && delta.y <= UPPER_EPSILON &&
		delta.z >= LOWER_EPSILON && delta.z <= UPPER_EPSILON)
	{
		color = interpolateQuadratic(curve.start, curve.middle, curve.end, clamp(delta, vec3(0.0), vec3(1.0)));
	}
}

void applyRGBCurve(in RGBCurve curve, inout vec3 color)
{
	color = interpolateQuadratic(curve.start, curve.middle, curve.end, color);	
}

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 sampleColor = Texel(image, textureCoordinate) * color;

	vec3 currentHSLColor = rgbToHSL(sampleColor.rgb);
	for (int i = 0; i < scape_HSLCurveCount; ++i)
	{
		applyHSLCurve(scape_HSLCurves[i], currentHSLColor);
	}

	vec3 currentRGBColor = hslToRGB(currentHSLColor);
	for (int i = 0; i < scape_RGBCurveCount; ++i)
	{
		applyRGBCurve(scape_RGBCurves[i], currentRGBColor);
	}

	return vec4(currentRGBColor, sampleColor.a);
}
