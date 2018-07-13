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

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec4 frag_Color;
varying vec2 frag_Texture;

vec4 performEffect(vec4 color, vec2 textureCoordinate);

void effect()
{
	vec4 diffuse = performEffect(frag_Color, frag_Texture);
	if (diffuse.a < 254.0 / 255.0)
	{
		discard;
	}

	love_Canvases[0] = vec4(diffuse.rgb, 1.0);
	//love_Canvases[0] = vec4((frag_Normal + 1.0) / 2.0, 1);
	//love_Canvases[0] = vec4((frag_Position - 10) / 10, 1.0);
	love_Canvases[1] = vec4(frag_Position, 1.0);
	love_Canvases[2] = vec4(frag_Normal, 1.0);
}
