#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Deferred/Fog.frag.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

uniform Image scape_PositionTexture;

uniform vec2 scape_FogParameters;
uniform vec3 scape_FogColor;
uniform vec3 scape_CameraEye;

vec4 effect(
	vec4 color,
	Image texture,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	float alpha = Texel(texture, textureCoordinate).a;
	vec3 position = Texel(scape_PositionTexture, textureCoordinate).xyz - scape_CameraEye;
	float length = length(position);
	float factor = 1.0 - clamp((scape_FogParameters.y - length) / (scape_FogParameters.y - scape_FogParameters.x), 0.0, 1.0);

	return vec4(scape_FogColor * factor * alpha, factor * alpha);
}
