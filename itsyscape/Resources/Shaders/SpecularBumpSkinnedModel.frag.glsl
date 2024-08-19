#pragma option SCAPE_LIGHT_MODEL_V2

#include "Resources/Shaders/Bump.common.glsl"

uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;
uniform Image scape_HeightmapTexture;
uniform float scape_BumpHeight;

noperspective varying mat3 frag_NormalMatrix;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	vec4 specularSample = Texel(scape_SpecularTexture, textureCoordinate);
	vec4 colorSample = Texel(scape_DiffuseTexture, textureCoordinate);

	float height;
	vec3 preTransformedNormal;
	calculateBumpNormal(scape_HeightmapTexture, textureCoordinate, vec2(1.0) / vec2(textureSize(scape_HeightmapTexture, 0)), scape_BumpHeight, preTransformedNormal, height);

	normal = normalize(frag_NormalMatrix * preTransformedNormal);

	specular = specularSample.r * specularSample.a;
	color = colorSample * color;
}	

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
