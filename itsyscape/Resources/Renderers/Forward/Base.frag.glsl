#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Forward/Base.frag.glsl
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
///////////////////////////////////////////////////////////////////////////////
//
// Based on code from Tom Dalling:
// https://www.tomdalling.com/blog/modern-opengl/08-even-more-lighting-directional-lights-spotlights-multiple-lights/
//
///////////////////////////////////////////////////////////////////////////////

#define SCAPE_MAX_LIGHTS 16

varying vec3 frag_Position;
varying vec3 frag_Normal;

uniform int scape_NumLights;

uniform struct Light {
	vec4 position;
	vec3 color;
	float attenuation;
	float ambientCoefficient;
	float coneAngle;
	vec3 coneDirection;
} scape_Lights[SCAPE_MAX_LIGHTS];

vec3 scapeApplyLight(
	Light light,
	vec3 position,
	vec3 normal,
	vec3 color)
{
	vec3 direction;
	float attenuation = 1.0;
	if (light.position.w == 0.0)
	{
		direction = normalize(light.position.xyz);
		attenuation = 1.0;
	}
	else
	{
		vec3 lightSurfaceDifference = light.position.xyz - position;
		direction = normalize(lightSurfaceDifference);
		float lightSurfaceDistance = length(lightSurfaceDifference);
		attenuation = light.attenuation / lightSurfaceDistance;

		float dot = dot(-direction, normalize(light.coneDirection));
		float lightToSurfaceAngle = degrees(acos(dot));
		if (lightToSurfaceAngle > light.coneAngle)
		{
			attenuation = 0.0;
		}
	}

	vec3 ambient = light.ambientCoefficient * color * light.color;
	float diffuseCoefficient = max(0.0, dot(normal, direction));
	vec3 diffuse = diffuseCoefficient * color * light.color;

	return attenuation * diffuse + ambient;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate);

vec4 effect(
	vec4 color,
	Image texture,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	vec4 diffuse = performEffect(color, textureCoordinate);

	vec3 result = vec3(0.0);
	for (int i = 0; i < scape_NumLights; ++i)
	{
		result += scapeApplyLight(
			scape_Lights[i],
			frag_Position,
			frag_Normal,
			diffuseColor);
	}

	return vec4(result, textureSample.a * color.a);
}
