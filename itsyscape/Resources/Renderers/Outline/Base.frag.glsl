#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Outline/Base.frag.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

#define SCAPE_ALPHA_DISCARD_THRESHOLD 1.0 / 128.0
#define SCAPE_BLACK_DISCARD_THRESHOLD 27.0 / 255.0

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

	diffuse.rgb = vec3(step(diffuse.r, SCAPE_BLACK_DISCARD_THRESHOLD) * step(diffuse.r, SCAPE_BLACK_DISCARD_THRESHOLD) * step(diffuse.b, SCAPE_BLACK_DISCARD_THRESHOLD));
	diffuse.a = 1.0;

	love_Canvases[0] = diffuse;
}
