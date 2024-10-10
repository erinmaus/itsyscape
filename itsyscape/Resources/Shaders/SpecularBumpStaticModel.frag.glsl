#pragma option SCAPE_LIGHT_MODEL_V2

#include "Resources/Shaders/Bump.common.glsl"

uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;
uniform Image scape_HeightmapTexture;
uniform float scape_BumpHeight;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	vec4 specularSample = Texel(scape_SpecularTexture, textureCoordinate);
	vec4 colorSample = Texel(scape_DiffuseTexture, textureCoordinate);

	float height;
	vec3 preTransformedNormal;
	calculateBumpNormal(scape_HeightmapTexture, textureCoordinate, vec2(1.0) / vec2(textureSize(scape_HeightmapTexture, 0)), scape_BumpHeight, preTransformedNormal, height);

	// Currently we can cheat calculating the tangent and bitangent since this is only applied to flat models where the normal is (0, [-/+]1, 0).
	vec3 currentTangent = normal.yxz;
	vec3 currentBitangent = normal.xzy;
	vec3 currentNormal = normal;
	mat3 tbn = mat3(currentTangent, currentBitangent, currentNormal);

	normal = normalize(tbn * preTransformedNormal);

	specular = specularSample.r * specularSample.a;
	color = colorSample * color * vec4(mix(vec3(specular), vec3(1.0), 1.0 - specularSample.a), 1.0);
}	

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
