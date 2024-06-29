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

uniform Image scape_ColorTexture;
uniform Image scape_PositionTexture;
uniform Image scape_SpecularTexture;

uniform vec3 scape_LightColor;
uniform float scape_LightAmbientCoefficient;

vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	float fullLitCoefficient = Texel(scape_SpecularTexture, textureCoordinate).g;
	vec3 result = scape_LightColor * clamp(scape_LightAmbientCoefficient + fullLitCoefficient, 0.0, 1.0);
	float alpha = Texel(scape_PositionTexture, textureCoordinate).a;
	return vec4(result, alpha);
}
