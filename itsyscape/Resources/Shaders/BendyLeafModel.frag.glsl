#define SCAPE_WALL_HACK_DO_NOT_CLAMP_TO_XZ
#include "Resources/Shaders/WallHack.common.glsl"

uniform Image scape_DiffuseTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 textureSample = Texel(scape_DiffuseTexture, textureCoordinate) * color;
	float alpha = getWallHackAlpha(frag_Position);
	return vec4(textureSample.rgb, textureSample.a * alpha);
}
