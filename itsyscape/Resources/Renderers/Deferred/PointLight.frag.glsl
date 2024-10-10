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

uniform float scape_LightAttenuation;
uniform vec3 scape_LightPosition;
uniform vec3 scape_LightColor;

vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	float depth = Texel(scape_DepthTexture, textureCoordinate).r;
	vec3 position = worldPositionFromGBufferDepth(depth, textureCoordinate, scape_InverseProjectionMatrix, scape_InverseViewMatrix);
	float alpha = Texel(scape_SpecularOutlineTexture, textureCoordinate).a;

	vec3 lightSurfaceDifference = scape_LightPosition - position;
	float attenuation = clamp(1.0 - length(lightSurfaceDifference) / scape_LightAttenuation, 0.0, 1.0);

	vec3 result = attenuation * attenuation * scape_LightColor;
	return vec4(result, alpha);
}
