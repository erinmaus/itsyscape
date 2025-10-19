uniform float scape_Time;
uniform float scape_Scale;

#include "Resources/Shaders/Noise.common.glsl"

vec4 position(mat4 modelViewProjection, vec4 localPosition)
{
	vec4 transformedPosition = vec4(
		localPosition.x + snoise(vec2(localPosition.x, scape_Time)) * scape_Scale,
		localPosition.y + snoise(vec2(localPosition.y, scape_Time)) * scape_Scale,
		localPosition.z,
		localPosition.w);

	return modelViewProjection * transformedPosition;
}
