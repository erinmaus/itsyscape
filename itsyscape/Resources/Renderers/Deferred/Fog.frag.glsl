#include "Resources/Shaders/GBuffer.common.glsl"

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Deferred/Fog.frag.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

uniform mat4 scape_InverseViewMatrix;
uniform mat4 scape_InverseProjectionMatrix;

uniform Image scape_SpecularOutlineTexture;
uniform Image scape_DepthTexture;

uniform vec2 scape_FogParameters;
uniform vec3 scape_FogColor;
uniform vec3 scape_CameraEye;

vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	float alpha = Texel(scape_SpecularOutlineTexture, textureCoordinate).a;
	float depth = Texel(scape_DepthTexture, textureCoordinate).r;
	vec3 position = worldPositionFromGBufferDepth(depth, textureCoordinate, scape_InverseProjectionMatrix, scape_InverseViewMatrix) - scape_CameraEye;
	float l = length(position);
	float near = scape_FogParameters.x;
	float far = scape_FogParameters.y;

	float factor = 0.0;
	if (near <= far)
	{
		factor = 1.0 - clamp((far - l) / (far - near), 0.0, 1.0);
	}
	else
	{
		factor = clamp((near - l) / (near - far), 0.0, 1.0);
	}

	return vec4(scape_FogColor * factor * alpha, factor * alpha);
}
