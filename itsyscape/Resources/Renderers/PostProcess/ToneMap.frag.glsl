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

void applyHSLCurve(in HSLCurve curve, inout vec3 color)
{
	vec3 delta = (color - curve.min) / (curve.max - curve.min);
	if (delta.x >= 0.0 && delta.x <= 1.0)
	{
		color = interpolateQuadratic(curve.start, curve.middle, curve.end, delta);
	}
}

void applyRGBCurve(in RGBCurve curve, inout vec3 color)
{
	color = interpolateQuadratic(curve.start, curve.middle, curve.end, color);	
}

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec3 sampleColor = Texel(image, textureCoordinate).rgb * color.rgb;

	vec3 currentHSLColor = rgbToHSL(sampleColor);
	for (int i = 0; i < scape_HSLCurveCount; ++i)
	{
		applyHSLCurve(scape_HSLCurves[i], currentHSLColor);
	}

	vec3 currentRGBColor = hslToRGB(currentHSLColor);
	for (int i = 0; i < scape_RGBCurveCount; ++i)
	{
		applyRGBCurve(scape_RGBCurves[i], currentRGBColor);
	}

	return vec4(currentRGBColor, 1.0);
}
