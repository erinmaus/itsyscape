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

vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
    vec4 source = Texel(image, textureCoordinate);
    vec4 destination = Texel(scape_ColorTexture, textureCoordinate);

    vec3 blendedColor = destination.rgb * (1.0 - source.a) + (source.rgb * destination.rgb * source.a);
    return vec4(blendedColor, destination.a);
}
