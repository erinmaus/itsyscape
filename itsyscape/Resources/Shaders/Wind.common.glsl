#include "Resources/Shaders/Quaternion.common.glsl"
#include "Resources/Shaders/Bump.common.glsl"

#ifndef SCAPE_WIND_DO_NOT_DEFINE_UNIFORMS
uniform vec3 scape_WindDirection;
uniform float scape_WindSpeed;
uniform vec3 scape_WindPattern;
uniform float scape_WindMaxDistance;
#endif

void transformWorldPositionByWave(float time, float windSpeed, vec3 windDirection, vec3 windPattern, vec3 anchorPosition, inout vec3 worldPosition)
{
	if (windSpeed <= 0.0)
	{
		return;
	}

	float windDelta = time * windSpeed;
	vec2 windDeltaCoordinate = windDirection.xz * vec2(windDelta) + worldPosition.xz;
	float windMu = (sin((windDeltaCoordinate.x + windDeltaCoordinate.y) / windPattern.x) * sin((windDeltaCoordinate.x + windDeltaCoordinate.y) / windPattern.y) * sin((windDeltaCoordinate.x + windDeltaCoordinate.y) / windPattern.z) + 1.0) / 2.0;
	
	float anchorWorldDistance = length(anchorPosition - worldPosition);
	worldPosition.y += anchorWorldDistance * windMu;
}

void transformWorldPositionByWind(float time, float windSpeed, vec3 windDirection, vec3 windPattern, vec3 anchorPosition, inout vec3 worldPosition, inout vec3 normal)
{
	if (windSpeed <= 0.0)
	{
		return;
	}

	vec4 windRotation = normalize(quaternionLookAt(vec3(0.0), vec3(windDirection.x, 1.0, windDirection.z), vec3(0.0, 1.0, 0.0)));
	float windDelta = time * windSpeed + length(worldPosition) * windSpeed;
	float windMu = (sin(windDelta / windPattern.x) * sin(windDelta / windPattern.y) * sin(windDelta / windPattern.z) + 1.0) / 2.0;
	vec4 currentWindRotation = slerp(vec4(vec3(0.0), 1.0), windRotation, windMu);

	vec4 relativePosition = vec4(worldPosition - anchorPosition, 1.0);
	vec4 transformedRelativePosition = quaternionTransformVector(currentWindRotation, relativePosition);

	worldPosition = transformedRelativePosition.xyz + anchorPosition;
	normal = normalize(quaternionTransformVector(currentWindRotation, vec4(normal, 0.0))).xyz;
}

void transformWorldPositionByBump(Image image, vec2 textureCoordinate, float forceMultiplier, vec3 anchorPosition, inout vec3 position)
{
	if (textureCoordinate.x < 0.0 && textureCoordinate.x > 1.0 && textureCoordinate.y < 0.0 && textureCoordinate.y > 1.0)
	{
		return;
	}

	vec3 normal;
	float force;

	vec4 bumpSample = Texel(image, textureCoordinate);
	normal = bumpSample.xyz;
	force = bumpSample.w;

	if (length(normal) == 0.0)
	{
		return;
	}

	vec4 targetRotation = normalize(quaternionLookAt(vec3(0.0), vec3(-normal.x, 1.0, normal.y), vec3(0.0, 1.0, 0.0)));
	vec4 relativeRotation = slerp(vec4(vec3(0.0), 1.0), targetRotation, force * forceMultiplier);

	vec4 relativePosition = vec4(position - anchorPosition, 0.0);
	vec4 transformedRelativePosition = quaternionTransformVector(relativeRotation, relativePosition);

	position = transformedRelativePosition.xyz + anchorPosition;
}
