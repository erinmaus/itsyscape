#ifdef GL_ES
precision highp float;
#endif

#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Mobile/Base.vert.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////

#include "Resources/Shaders/RendererPass.common.glsl"
#include "Resources/Shaders/Lights.common.glsl"

attribute vec3 VertexNormal;
attribute vec2 VertexTexture;

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec2 frag_Texture;
varying vec3 frag_LightFalloff;

void performTransform(
	mat4 modelViewProjection,
	vec4 vertexPosition,
	out vec3 localPosition,
	out vec4 projectedPosition);

vec4 position(mat4 modelViewProjection, vec4 vertexPosition)
{
	vec3 localPosition = vec3(0.0);
	vec4 projectedPosition = vec4(0.0);

	frag_Normal = normalize(mat3(scape_NormalMatrix) * VertexNormal);
	frag_Texture = VertexTexture;

	performTransform(
		getWorldViewProjection(),
		vertexPosition,
		localPosition,
		projectedPosition);

	vec4 worldPosition = scape_WorldMatrix * vec4(localPosition, 1.0);
	frag_Position = worldPosition.xyz;

	float directionalFalloff = calculateDirectionalLightFalloff(worldPosition.xyz, scape_CameraEye, scape_CameraTarget, scape_ViewMatrix);
	float ambientFalloff = calculateAmbientLightFalloff(worldPosition.xyz, scape_CameraEye, scape_CameraTarget);
	float pointFalloff = calculatePointLightFalloff(worldPosition.xyz, scape_CameraEye, scape_CameraTarget, scape_ViewMatrix);

	frag_LightFalloff = vec3(
		directionalFalloff,
		directionalFalloff * ambientFalloff,
		pointFalloff);

#ifndef GL_ES
	gl_ClipDistance[0] = -dot(worldPosition, scape_ClipPlane);
#endif

	return projectedPosition;
}
