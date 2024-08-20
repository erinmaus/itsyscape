#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Deferred/DirectionalLight.frag.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

uniform Image scape_PositionTexture;
uniform Image scape_NormalOutlineTexture;
uniform Image scape_SpecularTexture;
uniform Image scape_ColorTexture;

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
	vec3 normal = Texel(scape_NormalOutlineTexture, textureCoordinate).xyz;
	vec3 position = Texel(scape_PositionTexture, textureCoordinate).xyz;
	float specular = Texel(scape_SpecularTexture, textureCoordinate).r;
	float lightDotSurface = max(dot(scape_LightDirection, normal), 0.0);

	vec3 cameraToTarget = normalize(scape_CameraEye - scape_CameraTarget);
	float exponent = pow(abs(dot(normal, cameraToTarget)), 3);
	float specularCoefficient = (pow(5.0, exponent * pow(specular, 2.5)) - 1.0) / 4.0;

	vec3 result = lightDotSurface * scape_LightColor + vec3(specularCoefficient) * vec3(pow(length(scape_LightColor), 1.5));
	float alpha = Texel(scape_PositionTexture, textureCoordinate).w;
	return vec4(result, alpha);
}
