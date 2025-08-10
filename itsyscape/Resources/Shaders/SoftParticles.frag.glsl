#include "Resources/Shaders/GBuffer.common.glsl"

uniform float scape_SoftDepth;

uniform Image scape_DiffuseTexture;
uniform Image scape_DepthTexture;

uniform vec2 scape_MapSize;

varying vec3 frag_ParticlePosition;
varying vec3 frag_LocalPosition;
varying vec2 frag_ScreenPosition;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	float depth = Texel(scape_DepthTexture, frag_ScreenPosition).r;
	vec3 referencePosition = worldPositionFromGBufferDepth(depth, frag_ScreenPosition, scape_InverseProjectionMatrix, scape_InverseViewMatrix);
	float d = distance(referencePosition, position);

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 sample = Texel(scape_DiffuseTexture, textureCoordinate);

	color *= sample;
	color.a *= smoothstep(0.25, 1.0, d);

	position = frag_ParticlePosition;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 result = Texel(scape_DiffuseTexture, textureCoordinate) * color;

#ifdef SCAPE_PARTICLE_OUTLINE_PASS
	result.a = 0;
#endif

	return result;
}

float getParticleOutlinePassAlpha()
{
	return 0.0;
}

#pragma option SCAPE_PARTICLE_OUTLINE_PASS_CUSTOM_ALPHA
#pragma option SCAPE_LIGHT_MODEL_V2
