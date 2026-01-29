#include "Resources/Shaders/GBuffer.common.glsl"

uniform float scape_SoftDepth;

uniform Image scape_DepthTexture;

varying vec2 frag_ScreenPosition;
uniform float scape_Specular;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	float depth = Texel(scape_DepthTexture, frag_ScreenPosition).r;
	vec3 referencePosition = worldPositionFromGBufferDepth(depth, frag_ScreenPosition, scape_InverseProjectionMatrix, scape_InverseViewMatrix);
	float d = distance(referencePosition, position);

	color.a *= smoothstep(0.5, 2, d);
	specular = scape_Specular;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	return color;
}

#pragma option SCAPE_LIGHT_MODEL_V2
