#pragma option SCAPE_LIGHT_MODEL_V2
#define SCAPE_SPECULAR_BUMP_DISABLE_BUMP

#include "Resources/Shaders/SpecularBump.common.glsl"

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
