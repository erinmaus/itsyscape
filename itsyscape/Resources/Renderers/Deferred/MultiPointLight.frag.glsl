#include "Resources/Shaders/GBuffer.common.glsl"

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
		vec3 lightSurfaceDifference = scape_LightPosition[i] - position;
		float attenuation = clamp(1.0 - length(lightSurfaceDifference) / scape_LightAttenuation[i], 0.0, 1.0);

		result += attenuation * attenuation * scape_LightColor[i];
	}

	return vec4(result, alpha);
}
