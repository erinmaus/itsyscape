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

#include "Resources/Shaders/RendererPass.common.glsl"

#define SCAPE_ALPHA_DISCARD_THRESHOLD 0.5
#define SCAPE_BLACK_DISCARD_THRESHOLD 128.0 / 255.0

uniform Image scape_OutlineDiffuseTexture;
uniform vec2 scape_OutlineDiffuseTextureSize;

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec2 frag_Texture;
varying vec4 frag_Color;

vec4 performEffect(vec4 color, vec2 textureCoordinate);

void effect()
{
	vec2 textureScale = vec2(1.0) / scape_OutlineDiffuseTextureSize;
	vec2 from = frag_Texture * scape_OutlineDiffuseTextureSize;
	vec2 dx = dFdx(from);
	vec2 dy = dFdx(from);

	float startX = floor(min(from.x, dx.x));
	float stopX = floor(max(from.x, dx.x));
	float startY = floor(min(from.y, dx.y));
	float stopY = floor(max(from.y, dx.y));

	vec4 reference = performEffect(frag_Color, frag_Texture);

	float min = length(reference);
	vec4 diffuse = reference;
	// for (float x = startX; x < stopX; x += 1.0)
	// {
	// 	for (float y = startY; y < stopY; y += 1.0)
	// 	{
	// 		vec4 sample = performEffect(frag_Color, vec2(x, y) * textureScale);
	// 		float sampleLength = length(sample);

	// 		if (sampleLength < min)
	// 		{
	// 			min = sampleLength;
	// 			diffuse = sample;
	// 		}
	// 	}
	// } 
	//diffuse = vec4(vec3(length(vec2(stopX, stopY) - vec2(startX, startY)), 0.0, 0.0), 1.0);
	//diffuse = vec4((stopX - startX) * textureScale.x, 

	if (diffuse.a < SCAPE_ALPHA_DISCARD_THRESHOLD)
	{
		discard;
	}

	//diffuse.rgb = vec3(1 - (step(diffuse.r, SCAPE_BLACK_DISCARD_THRESHOLD) * step(diffuse.g, SCAPE_BLACK_DISCARD_THRESHOLD) * step(diffuse.b, SCAPE_BLACK_DISCARD_THRESHOLD)));
	if (diffuse.r < SCAPE_BLACK_DISCARD_THRESHOLD || diffuse.g < SCAPE_BLACK_DISCARD_THRESHOLD || diffuse.b < SCAPE_BLACK_DISCARD_THRESHOLD)
	{
		//diffuse.rgb = vec3(0.0);
	}

	diffuse.a = 1.0;

	love_Canvases[0] = diffuse;
}
