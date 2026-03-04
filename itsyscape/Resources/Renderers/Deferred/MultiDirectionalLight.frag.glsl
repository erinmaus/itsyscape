#include "Resources/Shaders/GBuffer.common.glsl"
#include "Resources/Shaders/Lights.common.glsl"

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Deferred/DirectionalLight.frag.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

uniform Image scape_DepthTexture;
uniform Image scape_NormalTexture;
uniform Image scape_SpecularOutlineTexture;

#define SCAPE_MAX_NUM_LIGHTS 64

uniform vec3 scape_LightDirection[SCAPE_MAX_NUM_LIGHTS];
uniform vec3 scape_LightColor[SCAPE_MAX_NUM_LIGHTS];
uniform int scape_NumLights;

uniform vec3 scape_CameraForward;
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
	vec3 normal = decodeGBufferNormal(Texel(scape_NormalTexture, textureCoordinate).xy);
	vec4 specularSample = Texel(scape_SpecularOutlineTexture, textureCoordinate);
	float depth = Texel(scape_DepthTexture, textureCoordinate).r;
	vec3 position = worldPositionFromGBufferDepth(depth, textureCoordinate, scape_InverseProjectionMatrix, scape_InverseViewMatrix);
	vec3 cameraToTarget = -scape_CameraForward;
	float specular = specularSample.r;
	float alpha = specularSample.a;

	float falloffValue = calculateXZLightFalloff(position, scape_CameraEye, scape_CameraTarget, scape_ViewMatrix);
	vec3 falloff = vec3(mix(0.5, 1.0, falloffValue));

	vec3 result = vec3(0.0);
	for (int i = 0; i < scape_NumLights; ++i)
	{
		float lightDotSurface = max(dot(scape_LightDirection[i], normal), 0.0);

		float exponent = pow(abs(dot(normal, cameraToTarget)), 3.0);
		float specularCoefficient = (pow(2.0, exponent * pow(specular, 2.2)) - 1.0) / 2.0;

		result += falloff * lightDotSurface * scape_LightColor[i] + vec3(max(specularCoefficient, 0.0)) * vec3(length(scape_LightColor[i])) * falloff;
	}

	return vec4(result, alpha);
}
