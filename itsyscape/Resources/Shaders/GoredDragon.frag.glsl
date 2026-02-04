#include "Resources/Shaders/Blend.common.glsl"
#include "Resources/Shaders/Math.common.glsl"
#include "Resources/Shaders/Noise.common.glsl"
#include "Resources/Shaders/Triplanar.common.glsl"

#define SCAPE_WALL_HACK_DO_NOT_CLAMP_TO_XZ
#include "Resources/Shaders/WallHack.common.glsl"

#define MAX_TEXTURES 8
#define NOISE_THRESHOLD_OUTLINE_BUFFER 0.0025
#define WIGGLE 1.0 / 512.0

uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;
uniform ArrayImage scape_TriplanarTexture;
uniform ArrayImage scape_TriplanarSpecularTexture;

uniform vec3 scape_NoiseOffset;
uniform vec3 scape_NoiseScale;
uniform float scape_NoiseThreshold;
uniform float scape_Wiggle;

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

	textureCoordinate.s += mix(-WIGGLE, WIGGLE, sin((scape_Time + scape_Wiggle) * SCAPE_PI / 2.0) * cos(textureCoordinate.s * SCAPE_PI * 2.0));
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 diffuseSample = Texel(scape_DiffuseTexture, textureCoordinate);
	vec4 specularSample = Texel(scape_SpecularTexture, textureCoordinate);

	vec4 resultSample = vec4(0.0);
	vec4 specularResultSample = vec4(0.0);
	for (int i = 0; i < scape_NumLayers; ++i)
	{
		vec3 weight = triplanarWeights(frag_PretransformedNormal, scape_TriplanarOffset[i], scape_TriplanarExponent[i] + 1.0);
		vec4 currentSample = sampleTriplanarArray(scape_TriplanarTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));
		vec4 currentSpecularSample = sampleTriplanarArray(scape_TriplanarSpecularTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));

		resultSample = alphaBlend(resultSample, currentSample);
		specularResultSample = alphaBlend(specularResultSample, currentSpecularSample);
	}

	float alpha = abs((snoise((frag_PretransformedPosition + scape_NoiseOffset) / scape_NoiseScale) + 1.0) / 2.0);
	alpha = step(scape_NoiseThreshold, alpha);

	resultSample.a *= alpha;
	specularResultSample.a *= alpha;

	diffuseSample *= color;

	specular = alphaBlend(specularSample, specularResultSample).r + 0.2;
	color = alphaBlend(diffuseSample, resultSample);

	color.a *= getWallHackAlpha(frag_Position);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.s += mix(-WIGGLE, WIGGLE, sin((scape_Time + scape_Wiggle) * SCAPE_PI / 2.0) * cos(textureCoordinate.s * SCAPE_PI * 2.0));
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 diffuseSample = Texel(scape_DiffuseTexture, textureCoordinate);

	TriplanarTextureCoordinates triplanarTextureCoordinates = triplanarMap(frag_PretransformedPosition, frag_PretransformedNormal);
	float alpha = abs((snoise((frag_PretransformedPosition + scape_NoiseOffset) / scape_NoiseScale) + 1.0) / 2.0);

	float wallHackAlpha = getWallHackAlpha(frag_Position);

#ifndef SCAPE_OUTLINE_PASS
	alpha = step(scape_NoiseThreshold, alpha);

	vec4 resultSample = vec4(1.0);
	for (int i = 0; i < scape_NumLayers; ++i)
	{
		vec3 weight = triplanarWeights(frag_PretransformedNormal, scape_TriplanarOffset[i], scape_TriplanarExponent[i] + 1.0);
		vec4 currentSample = sampleTriplanarArray(scape_TriplanarTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));

		alphaBlend(resultSample, currentSample);
	}

	resultSample.a *= alpha;

	diffuseSample *= color;
	diffuseSample = alphaBlend(diffuseSample, resultSample);
#else
	if (alpha > scape_NoiseThreshold - NOISE_THRESHOLD_OUTLINE_BUFFER && alpha < scape_NoiseThreshold + NOISE_THRESHOLD_OUTLINE_BUFFER)
	{
		return vec4(vec3(0.0), wallHackAlpha);
	}
	else if (alpha > scape_NoiseThreshold)
	{
		return vec4(vec3(1.0), wallHackAlpha);
	}
#endif

	diffuseSample.a *= wallHackAlpha;

	return diffuseSample;
}

#pragma option SCAPE_LIGHT_MODEL_V2
