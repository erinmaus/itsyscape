#include "Resources/Shaders/Math.common.glsl"

float calculateCameraRange(vec3 cameraEye, vec3 cameraTarget)
{
	float realDistance = distance(cameraEye, cameraTarget);
	float additionalDistance = (1 - step(0.1, realDistance)) * 50;
	return (realDistance + additionalDistance) / 2.0;
}

float calculateXZLightFalloff(vec3 worldPosition, vec3 cameraEye, vec3 cameraTarget, mat4 viewMatrix)
{
	float cameraRange = calculateCameraRange(cameraEye, cameraTarget);
	vec4 viewPosition = viewMatrix * vec4(worldPosition, 1.0);
	vec4 cameraCenter = viewMatrix * vec4(cameraTarget, 1.0);
	float zDistance = distance(viewPosition.xz, cameraCenter.xz);

	float value = zDistance / cameraRange;
	value *= value;

	return clamp(1.0 - value, 0.0, 1.0);
}

float calculateYLightFalloff(vec3 worldPosition, vec3 cameraEye, vec3 cameraTarget)
{
	float distanceFromCameraTargetY = abs(worldPosition.y - cameraTarget.y);
	float distanceFromEyeTarget = max(distance(cameraEye, cameraTarget), 25.0);
	float distanceScale = 10.0 / pow(distanceFromEyeTarget, 0.92);
	float value = distanceScale * log2(max(distanceFromCameraTargetY - 0.25, 0.1));
	return clamp(1.0 - value, 0.0, 1.0) * 0.5 + 0.5;
}
