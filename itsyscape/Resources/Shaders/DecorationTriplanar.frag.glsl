#define SCAPE_WALL_HACK_DO_NOT_CLAMP_TO_XZ

#include "Resources/Shaders/Triplanar.common.glsl"
#include "Resources/Shaders/WallHack.common.glsl"

uniform Image scape_DiffuseTexture;

uniform float scape_TriplanarExponent;
uniform float scape_TriplanarOffset;
uniform float scape_TriplanarScale;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	float alpha = getWallHackAlpha(frag_Position);
	TriplanarTextureCoordinates triPlanarTextureCoordinates = triplanarMap(frag_Position, frag_Normal);
	vec3 weight = triplanarWeights(frag_Normal, scape_TriplanarOffset, scape_TriplanarExponent + 1.0);

	vec4 texture = sampleTriplanar(scape_DiffuseTexture, triPlanarTextureCoordinates, weight, scape_TriplanarScale + 1.0);
	return texture * color * vec4(vec3(1.0), alpha);
}
