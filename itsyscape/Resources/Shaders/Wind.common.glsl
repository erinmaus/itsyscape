#include "Resources/Shaders/Quaternion.common.glsl"

#ifndef SCAPE_WIND_DO_NOT_DEFINE_UNIFORMS
uniform vec3 scape_WindDirection;
uniform float scape_WindSpeed;
uniform vec3 scape_WindPattern;
uniform float scape_WindMaxDistance;
#endif

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

	vec4 relativePosition = vec4(worldPosition - anchorPosition, 0.0);
	vec4 transformedRelativePosition = quaternionTransformVector(currentWindRotation, relativePosition);

	worldPosition = transformedRelativePosition.xyz + anchorPosition;
	normal = normalize(quaternionTransformVector(currentWindRotation, vec4(normal, 0.0))).xyz;
}
