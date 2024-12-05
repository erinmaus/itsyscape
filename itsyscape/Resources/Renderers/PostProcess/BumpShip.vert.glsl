#include "Resources/Shaders/RendererPass.common.glsl"

vec4 position(mat4 modelViewProjection, vec4 vertexPosition)
{
	return getWorldViewProjection() * vertexPosition;
}
