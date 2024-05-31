#ifdef GL_ES
precision highp float;
#extension GL_EXT_clip_cull_distance : enable
#endif

#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Outline/Base.vert.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

uniform mat4 scape_WorldMatrix;
uniform mat4 scape_NormalMatrix;
uniform vec4 scape_ClipPlane;

attribute vec3 VertexNormal;
attribute vec2 VertexTexture;

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec2 frag_Texture;
varying vec4 frag_Color;

void performTransform(
	mat4 modelViewProjection,
	vec4 vertexPosition,
	out vec3 localPosition,
	out vec4 projectedPosition);

vec4 position(mat4 modelViewProjection, vec4 vertexPosition)
{
	frag_Normal = normalize(mat3(scape_NormalMatrix) * VertexNormal);
	frag_Texture = VertexTexture;
	frag_Color = ConstantColor;

	vec3 localPosition = vec3(0.0);
	vec4 projectedPosition = vec4(0.0);
	performTransform(
		modelViewProjection,
		vertexPosition,
		localPosition,
		projectedPosition);

	vec4 worldPosition = scape_WorldMatrix * vec4(localPosition, 1.0);
	frag_Position = worldPosition.xyz;

	gl_ClipDistance[0] = -dot(worldPosition, scape_ClipPlane);

	return projectedPosition;
}
