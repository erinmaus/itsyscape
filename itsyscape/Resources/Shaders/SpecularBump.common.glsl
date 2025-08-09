#include "Resources/Shaders/Bump.common.glsl"

#ifndef SCAPE_SPECULAR_BUMP_DO_NOT_DEFINE_TEXTURE_UNIFORMS
uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;
uniform Image scape_HeightmapTexture;
uniform float scape_BumpHeight;
#endif

#ifndef SCAPE_SPECULAR_BUMP_PERFORM_FUNC
	#define SCAPE_SPECULAR_BUMP_PERFORM_FUNC performAdvancedEffect
#endif

void SCAPE_SPECULAR_BUMP_PERFORM_FUNC(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	vec4 specularSample = Texel(scape_SpecularTexture, textureCoordinate);
	vec4 colorSample = Texel(scape_DiffuseTexture, textureCoordinate);

#ifndef SCAPE_SPECULAR_BUMP_DISABLE_BUMP
	float height;
	vec3 preTransformedNormal;
	calculateBumpNormal(scape_HeightmapTexture, textureCoordinate, vec2(1.0) / vec2(textureSize(scape_HeightmapTexture, 0)), scape_BumpHeight, preTransformedNormal, height);

	// Currently we can cheat calculating the tangent and bitangent since this is only applied to flat models where the normal is (0, [-/+]1, 0).
	vec3 currentTangent = normal.yxz;
	vec3 currentBitangent = normal.xzy;
	vec3 currentNormal = normal;
	mat3 tbn = mat3(currentTangent, currentBitangent, currentNormal);

	normal = normalize(tbn * preTransformedNormal);
#endif

	specular = specularSample.r * specularSample.a;

#ifdef SCAPE_SPECULAR_DISABLE_EXTRA_SPECULAR_BLENDING
	color = colorSample * color;
#else
	color = colorSample * color * vec4(mix(vec3(specular), vec3(1.0), 1.0 - specularSample.a), 1.0);
#endif
}	
