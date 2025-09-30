#include "Resources/Shaders/Triplanar.common.glsl"

uniform Image scape_DiffuseTexture;

uniform float scape_TriplanarExponent;
uniform float scape_TriplanarOffset;
uniform float scape_TriplanarScale;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	TriplanarTextureCoordinates triPlanarTextureCoordinates = triplanarMap(frag_Position, frag_Normal);
	vec3 weight = triplanarWeights(frag_Normal, scape_TriplanarOffset, scape_TriplanarExponent + 1.0);

	vec4 diffuseSample = sampleTriplanar(scape_DiffuseTexture, triPlanarTextureCoordinates, weight, scape_TriplanarScale + 1.0);
	return diffuseSample * color;
}
