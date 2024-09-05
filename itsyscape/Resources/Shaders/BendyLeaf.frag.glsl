#define SCAPE_SPECULAR_BUMP_PERFORM_FUNC specularPerformAdvancedEffect
#include "Resources/Shaders/SpecularBump.common.glsl"

#define SCAPE_WALL_HACK_DO_NOT_CLAMP_TO_XZ
#include "Resources/Shaders/WallHack.common.glsl"

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	specularPerformAdvancedEffect(textureCoordinate, color, position, normal, specular);
	color.a *= getWallHackAlpha(frag_Position);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 sample = Texel(scape_DiffuseTexture, textureCoordinate) * color;
	float alpha = getWallHackAlpha(frag_Position);

	return vec4(sample.rgb, sample.a * alpha);
}
