uniform Image scape_DiffuseTexture;

#include "Resources/Shaders/WallHack.common.glsl"

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	float alpha = getWallHackAlpha(frag_Position);

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color * vec4(vec3(1.0), alpha);
}
