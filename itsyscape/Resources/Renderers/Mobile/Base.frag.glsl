#line 1

////////////////////////////////////////////////////////////////////////////////
// Resource/Renderer/Mobile/Base.frag.glsl
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

#include "Resources/Shaders/RendererPass.common.glsl"

#define SCAPE_MAX_LIGHTS 16
#define SCAPE_MAX_FOG    4
#define SCAPE_ALPHA_DISCARD_THRESHOLD 1.0 / 128.0

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec2 frag_Texture;

uniform int scape_NumLights;
uniform int scape_NumFogs;

uniform struct Light {
	vec4 position;
	vec3 color;
	float attenuation;
	float ambientCoefficient;
	float diffuseCoefficient;
	float coneAngle;
	vec3 coneDirection;
} scape_Lights[SCAPE_MAX_LIGHTS];

uniform struct Fog {
	float near, far;
	vec3 color;
	vec3 position;
} scape_Fog[SCAPE_MAX_FOG];

#ifdef SCAPE_ENABLE_RIM_LIGHTING
void getRimLightProperties(vec3 position, inout vec3 eye, out float exponent, out float multiplier);
#endif

vec3 scapeApplyLight(
	Light light,
	vec3 position,
	vec3 normal,
	vec3 color,
	float specular)
{
	vec3 surfaceToCamera = normalize(scape_CameraEye - position);

	vec3 direction;
	float attenuation = 0.0;
	if (light.position.w == 1.0)
	{
		direction = normalize(light.position.xyz);
	}
	else
	{
		vec3 lightSurfaceDifference = light.position.xyz - position;
		direction = normalize(lightSurfaceDifference);
		float lightSurfaceDistance = length(lightSurfaceDifference);
		attenuation = clamp(1.0 - lightSurfaceDistance / light.attenuation, 0.0, 1.0);

		float dot = dot(-direction, normalize(light.coneDirection));
		float lightToSurfaceAngle = degrees(acos(dot));
		if (lightToSurfaceAngle > light.coneAngle)
		{
			attenuation = 0.0;
		}
	}

	vec3 ambientLight = light.ambientCoefficient * color * light.color;
	vec3 pointLight = attenuation * attenuation * light.color * color;
	float diffuseCoefficient = max(0.0, dot(normal, direction)) * light.position.w;
	vec3 diffuseLight = diffuseCoefficient * color * light.color;

	vec3 specularLight = vec3(0.0);
	if (light.position.w == 1.0)
	{
		vec3 cameraToTarget = normalize(scape_CameraEye - scape_CameraTarget);
		float exponent = pow(abs(dot(normal, cameraToTarget)), 3.0);
		float specularCoefficient = (pow(5.0, exponent * pow(specular, 2.5)) - 1.0) / 4.0;
		specularLight = specularCoefficient * vec3(pow(length(light.color), 1.5));
	}

#ifdef SCAPE_ENABLE_RIM_LIGHTING
	vec3 rimLightEye = surfaceToCamera;
	float rimLightExponent, rimLightMultiplier;
	getRimLightProperties(position, rimLightEye, rimLightExponent, rimLightMultiplier);

	float rimLightIntensity = max(0.0, 1.0 - (dot(rimLightEye, normal) * dot(surfaceToCamera, normal)));
	rimLightIntensity = pow(rimLightIntensity, rimLightExponent) * rimLightMultiplier;

	vec3 rimLight = color * rimLightIntensity;
#else
	vec3 rimLight = vec3(0.0);
#endif

	return pointLight + diffuseLight + specularLight + ambientLight + rimLight;
}

vec3 scapeApplyFog(
	Fog fog,
	vec3 position,
	vec3 color)
{
	vec3 relativePosition = fog.position - position.xyz;
	float length = length(relativePosition);
	float factor = 0.0;
	if (fog.near <= fog.far)
	{
		factor = 1.0 - clamp((fog.far - length) / (fog.far - fog.near), 0.0, 1.0);
	}
	else
	{
		factor = clamp((fog.near - length) / (fog.near - fog.far), 0.0, 1.0);
	}

	return mix(color, fog.color, factor);
}


#ifdef SCAPE_LIGHT_MODEL_V2
void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular);
#else
vec4 performEffect(vec4 color, vec2 textureCoordinate);
#endif

vec4 effect(
	vec4 color,
	Image texture,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
#ifdef SCAPE_LIGHT_MODEL_V2
	vec4 diffuse = color;
	vec3 normal = frag_Normal;
	vec3 position = frag_Position;
	float specular = 0.0;
	performAdvancedEffect(frag_Texture, diffuse, position, normal, specular);
#else
	vec3 normal = frag_Normal;
	float specular = 0.0;
	vec3 position = frag_Position;
	vec4 diffuse = performEffect(color, frag_Texture);
#endif

	float alpha = diffuse.a * color.a;
	if (alpha < SCAPE_ALPHA_DISCARD_THRESHOLD)
	{
		discard;
	}

	vec3 result = vec3(0.0);
	for (int i = 0; i < scape_NumLights; ++i)
	{
		result += scapeApplyLight(
			scape_Lights[i],
			position,
			normal,
			diffuse.rgb,
			specular);
	}

	for (int i = 0; i < scape_NumFogs; ++i)
	{
		result = scapeApplyFog(scape_Fog[i], frag_Position, result);
	}

	return vec4(result.rgb, diffuse.a * color.a);
}
