#include "Resources/Shaders/Triplanar.common.glsl"

#define MAX_TEXTURES 8

uniform ArrayImage scape_DiffuseTexture;
uniform ArrayImage scape_SpecularTexture;

uniform float scape_TriplanarExponent[MAX_TEXTURES];
uniform float scape_TriplanarOffset[MAX_TEXTURES];
uniform float scape_TriplanarScale[MAX_TEXTURES];
uniform int scape_NumLayers;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	TriplanarTextureCoordinates triplanarTextureCoordinates = triplanarMap(frag_Position, frag_Normal);

	vec4 resultSample = vec4(0.0);
	vec4 specularSample = vec4(0.0);
	for (int i = 0; i < scape_NumLayers; ++i)
	{
		vec3 weight = triplanarWeights(frag_Normal, scape_TriplanarOffset[i], scape_TriplanarExponent[i] + 1.0);
		vec4 currentSample = sampleTriplanarArray(scape_DiffuseTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));
		vec4 currentSpecularSample = sampleTriplanarArray(scape_SpecularTexture, triplanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));

		resultSample.rgb *= vec3(1.0 - currentSample.a);
		resultSample.rgb += vec3(currentSample.a) * currentSample.rgb;
		resultSample.a *= 1.0 - currentSample.a;
		resultSample.a += currentSample.a;

		specularSample.rgb *= vec3(1.0 - currentSample.a);
		specularSample.rgb += vec3(currentSample.a) * currentSample.rgb;
		specularSample.a *= 1.0 - currentSample.a;
		specularSample.a += currentSample.a;
	}

	specular = specularSample.r * specularSample.a + 0.2;
	color = resultSample * color * vec4(mix(vec3(specularSample), vec3(1.0), 1.0 - specularSample.a), 1.0);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	TriplanarTextureCoordinates triPlanarTextureCoordinates = triplanarMap(frag_Position, frag_Normal);

	vec4 result = vec4(0.0);
	for (int i = 0; i < scape_NumLayers; ++i)
	{
		vec3 weight = triplanarWeights(frag_Normal, scape_TriplanarOffset[i], scape_TriplanarExponent[i] + 1.0);
		vec4 currentSample = sampleTriplanarArray(scape_DiffuseTexture, triPlanarTextureCoordinates, weight, scape_TriplanarScale[i] + 1.0, float(i));
		result.rgb *= vec3(1.0 - currentSample.a);
		result.rgb += vec3(currentSample.a) * currentSample.rgb;
		result.a *= 1.0 - currentSample.a;
		result.a += currentSample.a;
	}

	return result * color;
}

#pragma option SCAPE_LIGHT_MODEL_V2
