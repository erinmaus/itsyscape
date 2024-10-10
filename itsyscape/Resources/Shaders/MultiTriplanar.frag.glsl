#include "Resources/Shaders/Triplanar.common.glsl"

#define MAX_TEXTURES 8

uniform ArrayImage scape_DiffuseTexture;

uniform float scape_TriplanarExponent[MAX_TEXTURES];
uniform float scape_TriplanarOffset[MAX_TEXTURES];
uniform float scape_TriplanarScale[MAX_TEXTURES];
uniform int scape_NumLayers;

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
