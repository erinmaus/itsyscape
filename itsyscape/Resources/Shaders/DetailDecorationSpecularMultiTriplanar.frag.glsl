#define SCAPE_WALL_HACK_DO_NOT_CLAMP_TO_XZ

#include "Resources/Shaders/Triplanar.common.glsl"

#define MAX_TEXTURES 8

uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;
uniform ArrayImage scape_TriplanarTexture;
uniform ArrayImage scape_TriplanarSpecularTexture;

uniform float scape_TriplanarExponent[MAX_TEXTURES];
uniform float scape_TriplanarOffset[MAX_TEXTURES];
uniform float scape_TriplanarScale[MAX_TEXTURES];
uniform float scape_SpecularWeight;
uniform int scape_NumLayers;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	TriplanarTextureCoordinates triplanarTextureCoordinates = triplanarMap(frag_Position, frag_Normal);

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 diffuseSample = Texel(scape_DiffuseTexture, textureCoordinate);

	vec4 resultSample = vec4(1.0);
	vec4 specularSample = Texel(scape_SpecularTexture, textureCoordinate);
	for (int i = 0; i < scape_NumLayers; ++i)
	{
		vec3 weight = triplanarWeights(frag_Normal, scape_TriplanarOffset[i], scape_TriplanarExponent[i] + 1.0);
		vec4 currentSample = sampleTriplanarArray(scape_TriplanarTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));
		vec4 currentSpecularSample = sampleTriplanarArray(scape_TriplanarSpecularTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));

		resultSample.rgb *= vec3(1.0 - currentSample.a);
		resultSample.rgb += vec3(currentSample.a) * currentSample.rgb;
		resultSample.a *= 1.0 - currentSample.a;
		resultSample.a += currentSample.a;

		specularSample.rgb *= vec3(1.0 - currentSpecularSample.a);
		specularSample.rgb += vec3(currentSpecularSample.a) * currentSpecularSample.rgb;
		specularSample.a *= 1.0 - currentSpecularSample.a;
		specularSample.a += currentSpecularSample.a;
	}

	specular = specularSample.r * specularSample.a + 0.2;
	color *= diffuseSample * resultSample * vec4(mix(vec3(specularSample), vec3(1.0), mix(1.0 - specularSample.a, 1.0, scape_SpecularWeight)), 1.0);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	TriplanarTextureCoordinates triplanarTextureCoordinates = triplanarMap(frag_Position, frag_Normal);

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 diffuseSample = Texel(scape_DiffuseTexture, textureCoordinate);

#ifndef SCAPE_OUTLINE_PASS
	vec4 resultSample = vec4(1.0);
	vec4 specularSample = Texel(scape_SpecularTexture, textureCoordinate);
	for (int i = 0; i < scape_NumLayers; ++i)
	{
		vec3 weight = triplanarWeights(frag_Normal, scape_TriplanarOffset[i], scape_TriplanarExponent[i] + 1.0);
		vec4 currentSample = sampleTriplanarArray(scape_TriplanarTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));
		vec4 currentSpecularSample = sampleTriplanarArray(scape_TriplanarSpecularTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));

		resultSample.rgb *= vec3(1.0 - currentSample.a);
		resultSample.rgb += vec3(currentSample.a) * currentSample.rgb;
		resultSample.a *= 1.0 - currentSample.a;
		resultSample.a += currentSample.a;
	}

	diffuseSample *= resultSample;
#endif

	return diffuseSample;
}

#pragma option SCAPE_LIGHT_MODEL_V2
