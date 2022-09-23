#line 1

attribute vec4 VertexTileBounds;
attribute vec4 VertexTextureLayer;

varying vec4 frag_TileBounds;
varying vec4 frag_TextureLayer;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;
	frag_TileBounds = VertexTileBounds;
	frag_TextureLayer = VertexTextureLayer;
}
