#include "Resources/Shaders/RendererPass.common.glsl"

attribute vec2 VertexTexture;

varying vec2 frag_Texture;

vec4 position(mat4 modelViewProjection, vec4 vertexPosition)
{
	frag_Texture = VertexTexture;

	return getWorldViewProjection() * vertexPosition;
}
