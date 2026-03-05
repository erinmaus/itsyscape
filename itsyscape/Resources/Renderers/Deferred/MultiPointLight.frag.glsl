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

uniform mat4 scape_InverseViewMatrix;
uniform mat4 scape_InverseProjectionMatrix;

uniform Image scape_DepthTexture;
uniform Image scape_SpecularOutlineTexture;
uniform Image scape_ColorTexture;

#define SCAPE_MAX_NUM_LIGHTS 64

uniform float scape_LightAttenuation[SCAPE_MAX_NUM_LIGHTS];
uniform vec3 scape_LightPosition[SCAPE_MAX_NUM_LIGHTS];
uniform vec3 scape_LightColor[SCAPE_MAX_NUM_LIGHTS];
uniform int scape_NumLights;

uniform mat4 scape_ViewMatrix;
uniform vec3 scape_CameraTarget;
uniform vec3 scape_CameraEye;

vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	float alpha = Texel(scape_SpecularOutlineTexture, textureCoordinate).a;
	float depth = Texel(scape_DepthTexture, textureCoordinate).r;
	vec3 position = worldPositionFromGBufferDepth(depth, textureCoordinate, scape_InverseProjectionMatrix, scape_InverseViewMatrix);

	vec3 result = vec3(0.0);
	for (int i = 0; i < scape_NumLights; ++i)
	{
		float falloffValue = calculatePointLightFalloff(scape_LightPosition[i], scape_CameraEye, scape_CameraTarget, scape_ViewMatrix);
		vec3 falloff = vec3(falloffValue);

		vec3 lightSurfaceDifference = scape_LightPosition[i] - position;
		float attenuation = clamp(1.0 - length(lightSurfaceDifference) / scape_LightAttenuation[i], 0.0, 1.0);

		result += attenuation * attenuation * scape_LightColor[i] * falloff;
	}

	return vec4(result, alpha);
}
