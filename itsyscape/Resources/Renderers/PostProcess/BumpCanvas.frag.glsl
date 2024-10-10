#include "Resources/Shaders/Bump.common.glsl"

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec3 normal;
	float force;

	calculateBumpNormal(image, textureCoordinate, vec2(1.0) / vec2(textureSize(image, 0)), 0.0, normal, force);
	return vec4(normal, force);
}
