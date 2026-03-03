#include "Resources/Shaders/Math.common.glsl"

float calculateAmbientLightFalloff(vec3 worldPosition, vec3 cameraEye, vec3 cameraTarget)
{
	float distanceFromCameraTargetY = abs(worldPosition.y - cameraTarget.y);
	float distanceFromEyeTarget = max(distance(cameraEye, cameraTarget), 25.0);
	float distanceScale = 10.0 / pow(distanceFromEyeTarget, 0.92);
	float value = distanceScale * log2(max(distanceFromCameraTargetY - 0.25, 0.1));
	return clamp(1.0 - value, 0.0, 1.0) * 0.5 + 0.5;
}

float calculateDirectionalLightFalloff(vec3 worldPosition, vec3 cameraEye, vec3 cameraTarget)
{
	float distanceFromCameraTarget = distance(worldPosition.xz, cameraTarget.xz);
	float distanceFromEyeTarget = max(distance(cameraEye, cameraTarget), 25.0);
	float distanceScale = 0.4 / pow(distanceFromEyeTarget, 0.25);
	float xzValue = distanceScale * log2(max(distanceFromCameraTarget - 0.25, 0.1));
	xzValue = clamp(1.0 - xzValue, 0.0, 1.0) * 0.5 + 0.5;
	float yValue = calculateAmbientLightFalloff(worldPosition, cameraEye, cameraTarget);
	return xzValue * yValue;
}
