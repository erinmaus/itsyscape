#include "Resources/Shaders/Triplanar.common.glsl"
#include "Resources/Shaders/Blend.common.glsl"

#define MAX_TEXTURES 8

uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;
uniform ArrayImage scape_TriplanarTexture;
uniform ArrayImage scape_TriplanarSpecularTexture;
uniform Image scape_RainDiffuseTexture;
uniform Image scape_RainSpecularTexture;

uniform float scape_RainSpeed;
uniform float scape_TriplanarExponent[MAX_TEXTURES];
uniform float scape_TriplanarOffset[MAX_TEXTURES];
uniform float scape_TriplanarScale[MAX_TEXTURES];
uniform float scape_SpecularWeight;
uniform int scape_NumLayers;

varying vec3 frag_PretransformedPosition;
varying vec3 frag_PretransformedNormal;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	TriplanarTextureCoordinates triplanarTextureCoordinates = triplanarMap(frag_PretransformedPosition, frag_PretransformedNormal);
	TriplanarTextureCoordinates rainTextureCoordinates = triplanarMap(frag_PretransformedPosition + vec3(0.0, scape_Time * scape_RainSpeed, 0.0), frag_PretransformedNormal);
	vec3 rainWeight = triplanarWeights(frag_PretransformedNormal, 0.0, 1.0);
	rainWeight = normalize(vec3(rainWeight.x, 0.0, rainWeight.z));

	vec4 rainDiffuse = sampleTriplanar(scape_RainDiffuseTexture, rainTextureCoordinates, rainWeight, 0.125);
	vec4 rainSpecular = sampleTriplanar(scape_RainSpecularTexture, rainTextureCoordinates, rainWeight, 0.125);

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 diffuseSample = Texel(scape_DiffuseTexture, textureCoordinate);

	vec4 resultSample = vec4(0.0);
	vec4 specularSample = Texel(scape_SpecularTexture, textureCoordinate);
	for (int i = 0; i < scape_NumLayers; ++i)
	{
		vec3 weight = triplanarWeights(frag_PretransformedNormal, scape_TriplanarOffset[i], scape_TriplanarExponent[i] + 1.0);
		vec4 currentSample = sampleTriplanarArray(scape_TriplanarTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));
		vec4 currentSpecularSample = sampleTriplanarArray(scape_TriplanarSpecularTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));

		resultSample = alphaBlend(resultSample, currentSample);
		specularSample = alphaBlend(specularSample, currentSpecularSample);
	}

	resultSample = alphaBlend(resultSample, rainDiffuse);
	//specularSample = alphaBlend(specularSample, rainSpecular);

	specular = specularSample.r * specularSample.a + 0.2;
	color *= alphaBlend(diffuseSample, resultSample) * vec4(mix(vec3(specularSample), vec3(1.0), mix(1.0 - specularSample.a, 1.0, scape_SpecularWeight)), 1.0);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	TriplanarTextureCoordinates triplanarTextureCoordinates = triplanarMap(frag_PretransformedPosition, frag_PretransformedNormal);

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 diffuseSample = Texel(scape_DiffuseTexture, textureCoordinate);

#ifndef SCAPE_OUTLINE_PASS
	vec4 resultSample = vec4(1.0);
	vec4 specularSample = Texel(scape_SpecularTexture, textureCoordinate);
	for (int i = 0; i < scape_NumLayers; ++i)
	{
		vec3 weight = triplanarWeights(frag_PretransformedNormal, scape_TriplanarOffset[i], scape_TriplanarExponent[i] + 1.0);
		vec4 currentSample = sampleTriplanarArray(scape_TriplanarTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));

		alphaBlend(resultSample, currentSample);
	}

	diffuseSample *= resultSample;
#endif

	return diffuseSample;
}

#pragma option SCAPE_LIGHT_MODEL_V2
