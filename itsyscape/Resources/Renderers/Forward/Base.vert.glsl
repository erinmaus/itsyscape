#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Forward/Base.vert.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

attribute vec3 VertexNormal;

varying vec3 frag_Position;
varying vec3 frag_Normal;

void performTransform(
	mat4 modelViewProjection,
	vec4 vertexPosition,
	out vec3 worldPosition,
	out vec4 projectedPosition);

vec4 position(mat4 modelViewProjection, vec4 vertexPosition)
{
	vec3 worldPosition = vec3(0);
	vec4 projectedPosition = vec4(0);
	performTransform(
		modelViewProjection,
		vertexPosition,
		worldPosition,
		projectedPosition);

	frag_Position = worldPosition;
	frag_Normal = normalize(NormalMatrix * VertexNormal);

	return projectedPosition;
}
