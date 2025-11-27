#pragma option SCAPE_LIGHT_MODEL_V2

uniform Image scape_PolygonMaskTexture;
varying vec2 frag_RelativeTexture;

#define SCAPE_SPECULAR_BUMP_DISABLE_BUMP
#define SCAPE_SPECULAR_DISABLE_EXTRA_SPECULAR_BLENDING
#define SCAPE_SPECULAR_BUMP_PERFORM_FUNC applySpecularEffect
#include "Resources/Shaders/SpecularBump.common.glsl"

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	float polygonMaskAlpha = Texel(scape_PolygonMaskTexture, frag_RelativeTexture).r;
	color.a *= polygonMaskAlpha;

	applySpecularEffect(textureCoordinate, color, position, normal, specular);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	float polygonMaskAlpha = Texel(scape_PolygonMaskTexture, frag_RelativeTexture).r;
	color.a *= polygonMaskAlpha;

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}

#pragma option SCAPE_REFLECTION_PASS_CUSTOM_REFLECTION_PROPERTIES

void getReflectionProperties(vec2 textureCoordinate, inout float reflectionPower, inout float reflectionDistance, inout float roughness)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	roughness = 1.0 - Texel(scape_DiffuseTexture, textureCoordinate).r;
}
