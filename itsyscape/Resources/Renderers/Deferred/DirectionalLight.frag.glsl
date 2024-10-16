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

uniform Image scape_NormalSpecularTexture;
uniform Image scape_ColorTexture;

uniform vec3 scape_LightDirection;
uniform vec3 scape_LightColor;

vec4 effect(
	vec4 color,
	Image texture,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	vec3 normal = Texel(scape_NormalSpecularTexture, textureCoordinate).xyz;
	float lightDotSurface = max(dot(scape_LightDirection, normal), 0.0);

	vec3 result = lightDotSurface * scape_LightColor;
	float alpha = Texel(scape_ColorTexture, textureCoordinate).a;
	return vec4(result, alpha);
}
