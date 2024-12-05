#include "Resources/Shaders/RendererPass.common.glsl"

attribute vec3 VertexNormal;
attribute vec2 VertexTexture;

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec2 frag_Texture;
varying vec4 frag_Color;

void performTransform(
	mat4 modelViewProjection,
	vec4 vertexPosition,
	out vec3 localPosition,
	out vec4 projectedPosition);

vec4 position(mat4 modelViewProjection, vec4 vertexPosition)
{
	frag_Normal = VertexNormal;
	frag_Texture = VertexTexture;
	frag_Color = ConstantColor;

	vec3 localPosition = vec3(0.0);
	vec4 projectedPosition = vec4(0.0);
	performTransform(
		getWorldViewProjection(),
		vertexPosition,
		localPosition,
		projectedPosition);

	vec4 worldPosition = scape_WorldMatrix * vec4(localPosition, 1.0);
	frag_Position = worldPosition.xyz;

	return projectedPosition;
}

#include "Resources/Shaders/WhirlpoolWater.vert.glsl"
