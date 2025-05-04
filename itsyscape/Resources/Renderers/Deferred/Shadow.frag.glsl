#include "Resources/Shaders/GBuffer.common.glsl"

#define SCAPE_MAX_CASCADES 8

uniform mat4 scape_InverseViewMatrix;
uniform mat4 scape_InverseProjectionMatrix;

uniform ArrayImage scape_ShadowMap;
uniform Image scape_DepthTexture;
uniform Image scape_NormalTexture;
uniform Image scape_SpecularOutlineTexture;
uniform vec2 scape_TexelSize;
uniform vec3 scape_LightDirection;
uniform mat4 scape_CascadeLightSpaceMatrices[SCAPE_MAX_CASCADES];
uniform vec2 scape_CascadePlanes[SCAPE_MAX_CASCADES];
uniform int scape_NumCascades;
uniform float scape_ShadowAlpha;
uniform mat4 scape_View;

#define SCAPE_PCF_BLUR_START -2
#define SCAPE_PCF_BLUR_END 2

float calculatePCF(int cascadeIndex, vec3 position, float bias)
{
	float layer = float(cascadeIndex);

	float result = 0.0;
	float numSamples = 0.0;
	for (int i = SCAPE_PCF_BLUR_START; i <= SCAPE_PCF_BLUR_END; ++i)
	{
		for (int j = SCAPE_PCF_BLUR_START; j <= SCAPE_PCF_BLUR_END; ++j)
		{
			float x = float(i);
			float y = float(j);
			float comparison = position.z - bias;

			float s = position.x + x * scape_TexelSize.x;
			float t = position.y + y * scape_TexelSize.y;

			float target = Texel(scape_ShadowMap, vec3(s, t, layer)).r;

			result += step(target, comparison);
			numSamples += 1.0;
		}
	}

	return result /= numSamples;
}

vec4 effect(
	vec4 color,
	Image depthTexture,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	float depth = Texel(scape_DepthTexture, textureCoordinate).r;
	vec3 positionSample = worldPositionFromGBufferDepth(depth, textureCoordinate, scape_InverseProjectionMatrix, scape_InverseViewMatrix);
	vec3 worldPosition = positionSample.xyz;
	vec3 viewPosition = (scape_View * vec4(worldPosition, 1.0)).xyz;

	int cascadeIndex = 0;
	for (int i = 0; i < scape_NumCascades; ++i)
	{
		float near = scape_CascadePlanes[i].x;
		if (viewPosition.z >= near)
		{
			cascadeIndex = i;
		}
	}

	vec3 normal = normalize(decodeGBufferNormal(Texel(scape_NormalTexture, textureCoordinate).xy));
	vec4 lightPosition = scape_CascadeLightSpaceMatrices[cascadeIndex] * vec4(worldPosition, 1.0);
	vec3 projectedLightPosition = lightPosition.xyz / lightPosition.w;
	projectedLightPosition = (projectedLightPosition + vec3(1.0)) / vec3(2.0);

	float delta = float(cascadeIndex) / ((float(scape_NumCascades - 1) + step(float(scape_NumCascades), 1.0)));
	float bias = max(0.05 * (1.0 - dot(normal, scape_LightDirection)), 0.05) / (scape_CascadePlanes[cascadeIndex].y * mix(0.125, 0.05, delta));

	if (projectedLightPosition.z < 0.0 || projectedLightPosition.z > 1.0)
	{
		return vec4(0.0);
	}

	float sceneAlpha = Texel(scape_SpecularOutlineTexture, textureCoordinate, 1.0).a;
	float shadow = calculatePCF(cascadeIndex, projectedLightPosition, bias);
	return vec4(vec3(0.0), scape_ShadowAlpha * shadow * sceneAlpha);
}
