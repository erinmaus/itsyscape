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

uniform vec3 scape_LightDirection;
uniform vec3 scape_LightColor;

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
	float specular = specularSample.r;
	float alpha = specularSample.a;
	float lightDotSurface = max(dot(scape_LightDirection, normal), 0.0);

	vec3 cameraToTarget = normalize(scape_CameraEye - scape_CameraTarget);
	float exponent = pow(abs(dot(normal, cameraToTarget)), 3);
	float specularCoefficient = (pow(5.0, exponent * pow(specular, 2.5)) - 1.0) / 4.0;

	vec3 result = lightDotSurface * scape_LightColor + vec3(specularCoefficient) * vec3(pow(length(scape_LightColor), 1.5));
	return vec4(result, alpha);
}
