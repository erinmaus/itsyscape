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

uniform Image scape_NormalTexture;
uniform Image scape_SpecularOutlineTexture;

#define SCAPE_MAX_NUM_LIGHTS 64

uniform vec3 scape_LightDirection[SCAPE_MAX_NUM_LIGHTS];
uniform vec3 scape_LightColor[SCAPE_MAX_NUM_LIGHTS];
uniform int scape_NumLights;

uniform vec3 scape_CameraEye;
uniform vec3 scape_CameraTarget;

vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	vec3 normal = decodeGBufferNormal(Texel(scape_NormalTexture, textureCoordinate).xy);
	vec4 specularSample = Texel(scape_SpecularOutlineTexture, textureCoordinate);
	vec3 cameraToTarget = normalize(scape_CameraEye - scape_CameraTarget);
	float specular = specularSample.r;
	float alpha = specularSample.a;

	vec3 result;
	for (int i = 0; i < scape_NumLights; ++i)
	{
		float lightDotSurface = max(dot(scape_LightDirection[i], normal), 0.0);

		float exponent = pow(abs(dot(normal, cameraToTarget)), 3.0);
		float specularCoefficient = (pow(5.0, exponent * pow(specular, 2.5)) - 1.0) / 4.0;

		result += lightDotSurface * scape_LightColor[i] + vec3(specularCoefficient) * vec3(pow(length(scape_LightColor[i]), 1.5));
	}

	return vec4(result, alpha);
}
