#include "Resources/Shaders/Triplanar.common.glsl"

uniform float scape_TriplanarExponent;
uniform float scape_TriplanarOffset;
uniform float scape_TriplanarScale;

varying vec3 frag_ModelPosition;
varying vec3 frag_ModelNormal;

uniform Image scape_DiffuseTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	TriplanarTextureCoordinates triPlanarTextureCoordinates = triplanarMap(frag_ModelPosition, frag_ModelNormal);
	vec3 weight = triplanarWeights(frag_ModelNormal, scape_TriplanarOffset, scape_TriplanarExponent + 1.0);

	vec4 texture = sampleTriplanar(scape_DiffuseTexture, triPlanarTextureCoordinates, weight, scape_TriplanarScale + 1.0);
	return texture * color;
}
