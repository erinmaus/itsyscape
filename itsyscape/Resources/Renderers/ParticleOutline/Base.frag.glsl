#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/AlphaMask/Base.frag.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

#include "Resources/Shaders/RendererPass.common.glsl"

#define SCAPE_ALPHA_DISCARD_THRESHOLD 0.1
#define SCAPE_PARTICLE_OUTLINE_PASS 1

uniform float scape_AlphaMask;

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec2 frag_Texture;
varying vec4 frag_Color;

vec4 performEffect(vec4 color, vec2 textureCoordinate);

void effect()
{
	vec4 diffuse = performEffect(frag_Color, frag_Texture);

	if (diffuse.a < SCAPE_ALPHA_DISCARD_THRESHOLD)
	{
		discard;
	}

	love_Canvases[0] = vec4(0.0, 0.0, 0.0, 1.0);
}
