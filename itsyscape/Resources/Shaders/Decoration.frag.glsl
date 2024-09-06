#pragma option SCAPE_LIGHT_MODEL_V2

#include "Resources/Shaders/SpecularBump.common.glsl"

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}

#pragma option SCAPE_REFLECTION_PASS_CUSTOM_REFLECTION_PROPERTIES

void getReflectionProperties(vec2 textureCoordinate, inout float reflectionPower, inout float reflectionDistance, inout float roughness)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	roughness = 1.0 - Texel(scape_DiffuseTexture, textureCoordinate).r;
}
