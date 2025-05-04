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

#define SCAPE_MAX_NUM_LIGHTS 64

uniform vec3 scape_LightColor[SCAPE_MAX_NUM_LIGHTS];
uniform float scape_LightAmbientCoefficient[SCAPE_MAX_NUM_LIGHTS];
uniform int scape_NumLights;

vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	float alpha = Texel(scape_SpecularOutlineTexture, textureCoordinate).a;
	vec3 result = vec3(0.0);

	for (int i = 0; i < scape_NumLights; ++i)
	{
		result += scape_LightColor[i] * vec3(scape_LightAmbientCoefficient[i]);
	}

	return vec4(result, alpha);
}
