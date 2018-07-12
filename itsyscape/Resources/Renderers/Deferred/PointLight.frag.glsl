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

uniform float scape_LightAttenuation;
uniform vec3 scape_LightPosition;
uniform vec3 scape_LightColor;

vec4 effect(
	vec4 color,
	Image texture,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	vec3 position = Texel(scape_PositionTexture, textureCoordinate).xyz;

	vec3 lightSurfaceDifference = scape_LightPosition - position;
	vec3 direction = normalize(lightSurfaceDifference);
	float attenuation = scape_LightAttenuation / length(lightSurfaceDifference);

	vec3 result = attenuation * scape_LightColor;
	return vec4(result, 1.0);
}
