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

uniform Image scape_SpecularOutlineTexture;

uniform vec3 scape_LightColor;
uniform float scape_LightAmbientCoefficient;

vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	float alpha = Texel(scape_SpecularOutlineTexture, textureCoordinate).a;
	vec3 result = scape_LightColor * vec3(scape_LightAmbientCoefficient);
	return vec4(result, alpha);
}
