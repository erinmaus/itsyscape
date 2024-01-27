#define MAX_BONES 48
uniform mat4 scape_Bones[MAX_BONES];

attribute vec2 VertexTextureLayer;
attribute vec2 VertexTextureTime;

varying vec2 frag_TextureLayer;
varying vec2 frag_TextureTime;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;

	frag_TextureLayer = VertexTextureLayer;
	frag_TextureTime = VertexTextureTime;
}
