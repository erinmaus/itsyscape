#ifdef GL_ES
precision highp float;
#endif

#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Deferred/Base.frag.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

#include "Resources/Shaders/RendererPass.common.glsl"
#include "Resources/Shaders/GBuffer.common.glsl"

uniform float scape_OutlineThreshold;
uniform vec4 scape_OutlineColor;

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec4 frag_Color;
varying vec2 frag_Texture;


#ifdef SCAPE_LIGHT_MODEL_V2
void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular);
#else
vec4 performEffect(vec4 color, vec2 textureCoordinate);
#endif

void effect()
{
#ifdef SCAPE_LIGHT_MODEL_V2
	vec4 diffuse = frag_Color;
	vec3 normal = frag_Normal;
	vec3 position = frag_Position;
	float specular = 0.0;
	performAdvancedEffect(frag_Texture, diffuse, position, normal, specular);
#else
	vec3 normal = frag_Normal;
	float specular = 0.0;
	vec3 position = frag_Position;
	vec4 diffuse = performEffect(frag_Color, frag_Texture);
#endif

	normal *= step(vec3(0.001), normal);
	normal = normalize(normal);

	if (diffuse.a < 250.0 / 255.0)
	{
		discard;
	}
	else
	{
		diffuse.a = 1.0;
	}

	love_Canvases[0] = diffuse;
	love_Canvases[1] = vec4(encodeGBufferNormal(normal), 0.0, 1.0);
	love_Canvases[2] = vec4(specular, scape_OutlineColor.r, (scape_OutlineThreshold + 1.0) / 2.0, 1.0);
}
