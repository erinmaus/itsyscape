#pragma option SCAPE_LIGHT_MODEL_V2

#include "Resources/Shaders/Triplanar.common.glsl"
#include "Resources/Shaders/WallHack.common.glsl"

uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;

uniform float scape_TriplanarExponent;
uniform float scape_TriplanarOffset;
uniform float scape_TriplanarScale;

varying vec3 frag_ModelPosition;
varying vec3 frag_ModelNormal;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	float alpha = getWallHackAlpha(frag_Position);

	TriplanarTextureCoordinates triPlanarTextureCoordinates = triplanarMap(frag_ModelPosition, frag_ModelNormal);
	vec3 weight = triplanarWeights(frag_ModelNormal, scape_TriplanarOffset, scape_TriplanarExponent + 1.0);

	vec4 colorSample = sampleTriplanar(scape_DiffuseTexture, triPlanarTextureCoordinates, weight, scape_TriplanarScale + 1.0);
	vec4 specularSample = sampleTriplanar(scape_SpecularTexture, triPlanarTextureCoordinates, weight, scape_TriplanarScale + 1.0);

	specular = specularSample.r * specularSample.a + 0.2;
	color = colorSample * color * vec4(mix(vec3(specularSample), vec3(1.0), 1.0 - specularSample.a), 1.0) * vec4(vec3(1.0), alpha);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	float alpha = getWallHackAlpha(frag_Position);

	TriplanarTextureCoordinates triPlanarTextureCoordinates = triplanarMap(frag_ModelPosition, frag_ModelNormal);
	vec3 weight = triplanarWeights(frag_ModelNormal, scape_TriplanarOffset, scape_TriplanarExponent + 1.0);

	vec4 texture = sampleTriplanar(scape_DiffuseTexture, triPlanarTextureCoordinates, weight, scape_TriplanarScale + 1.0);
	return texture * color * vec4(vec3(1.0), alpha);
}
