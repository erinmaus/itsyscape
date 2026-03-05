#include "Resources/Shaders/GBuffer.common.glsl"
#include "Resources/Shaders/Lights.common.glsl"

uniform Image scape_DepthTexture;
uniform Image scape_SpecularOutlineTexture;

#define SCAPE_MAX_NUM_LIGHTS 64

uniform vec3 scape_LightColor[SCAPE_MAX_NUM_LIGHTS];
uniform float scape_LightAmbientCoefficient[SCAPE_MAX_NUM_LIGHTS];
uniform int scape_NumLights;

uniform mat4 scape_ViewMatrix;
uniform mat4 scape_InverseViewMatrix;
uniform mat4 scape_InverseProjectionMatrix;
uniform vec3 scape_CameraTarget;
uniform vec3 scape_CameraEye;

vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	float alpha = Texel(scape_SpecularOutlineTexture, textureCoordinate).a;
	vec3 result = vec3(0.0);

	float depth = Texel(scape_DepthTexture, textureCoordinate).r;
	vec3 position = worldPositionFromGBufferDepth(depth, textureCoordinate, scape_InverseProjectionMatrix, scape_InverseViewMatrix);

	float yFalloff = calculateAmbientLightFalloff(position, scape_CameraEye, scape_CameraTarget);
	float xzFalloff = calculateDirectionalLightFalloff(position, scape_CameraEye, scape_CameraTarget, scape_ViewMatrix);
	float falloff = xzFalloff * yFalloff;

	for (int i = 0; i < scape_NumLights; ++i)
	{
		result += scape_LightColor[i] * vec3(scape_LightAmbientCoefficient[i]);
	}

	result *= vec3(falloff);

	return vec4(result, alpha);
}
