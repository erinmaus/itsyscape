uniform Image scape_DiffuseTexture;
uniform highp float scape_Offset;

#define SCAPE_WALL_HACK_DO_NOT_CLAMP_TO_XZ
#include "Resources/Shaders/WallHack.common.glsl"

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	textureCoordinate.t += mix(-(1.0 / 128.0), (1.0 / 128.0), sin((scape_Time + scape_Offset) * 3.14 / 2.0) * cos(textureCoordinate.t * 3.14 * 2.0));
    textureCoordinate.s = mod(textureCoordinate.s, 1.0);

    vec4 result = Texel(scape_DiffuseTexture, textureCoordinate) * color;
	result.a *= getWallHackAlpha(frag_Position);

	return result;
}
