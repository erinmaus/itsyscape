#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Deferred/Base.vert.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

attribute vec3 VertexNormal;
attribute vec2 VertexTexture;

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec4 frag_Color;
varying vec2 frag_Texture;

vec4 performTransform(mat4 modelViewProjection, vec4 vertexPosition);

vec4 position(mat4 modelViewProjection, vec4 vertexPosition)
{
	frag_Position = (TransformMatrix * vertexPosition).xyz;
	frag_Normal = normalize(NormalMatrix * VertexNormal);
	frag_Color = VertexColor;
	frag_Texture = VertexTexture;

	return performTransform(modelViewProjection, vertexPosition);
}
