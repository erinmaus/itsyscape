uniform float scape_Time;
uniform float scape_Interval;
uniform float scape_Scale;

#include "Resources/Shaders/Noise.common.glsl"

vec4 position(mat4 modelViewProjection, vec4 localPosition)
{
	vec2 x = floor(vec2(localPosition.x, scape_Time) * vec2(scape_Interval)) / vec2(scape_Interval);
	vec2 y = floor(vec2(localPosition.y, scape_Time) * vec2(scape_Interval)) / vec2(scape_Interval);

	vec4 transformedPosition = vec4(
		localPosition.x + snoise(x) * scape_Scale,
		localPosition.y + snoise(y) * scape_Scale,
		localPosition.z,
		localPosition.w);

	return modelViewProjection * transformedPosition;
}
