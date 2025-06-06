#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Deferred/CopyDepth.frag.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	gl_FragDepth = Texel(image, textureCoordinate).r;
    return vec4(0.0);
}
