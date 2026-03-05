#include "Resources/Shaders/Math.common.glsl"

float calculateCameraRange(vec3 cameraEye, vec3 cameraTarget)
{
	float x = distance(cameraEye, cameraTarget);
	x += (1 - step(0.1, x)) * 25;
	x = clamp(x, 1, 100);

	const float a = 0.008;
	const float b = 0.13;
	const float c = 4.6;

	return a * (x * x) + b * x + c;
}

float calculateXZLightFalloff(vec3 worldPosition, vec3 cameraEye, vec3 cameraTarget, mat4 viewMatrix)
{
	float cameraRange = calculateCameraRange(cameraEye, cameraTarget);
	vec4 viewPosition = viewMatrix * vec4(worldPosition, 1.0);
	vec4 cameraCenter = viewMatrix * vec4(cameraTarget, 1.0);
	float zDistance = distance(viewPosition.xz, cameraCenter.xz);

	float value = zDistance / cameraRange;
	value *= value;

	float falloff = clamp(1.0 - value, 0.0, 1.0);
	return falloff;
}

float calculateYLightFalloff(vec3 worldPosition, vec3 cameraEye, vec3 cameraTarget)
{
	float distanceFromCameraTargetY = abs(worldPosition.y - cameraTarget.y);
	float distanceFromEyeTarget = max(distance(cameraEye, cameraTarget), 25.0);
	float distanceScale = 10.0 / pow(distanceFromEyeTarget, 0.92);

	float value = distanceScale * log2(max(distanceFromCameraTargetY - 0.25, 0.1));

	float falloff = clamp(1.0 - value, 0.0, 1.0);
	falloff *= falloff;

	return falloff;
}

float calculatePointLightFalloff(vec3 worldPosition, vec3 cameraEye, vec3 cameraTarget, mat4 viewMatrix)
{
	float falloff = calculateXZLightFalloff(worldPosition, cameraEye, cameraTarget, viewMatrix);
	return mix(0.25, 1.0, falloff);
}

float calculateDirectionalLightFalloff(vec3 worldPosition, vec3 cameraEye, vec3 cameraTarget, mat4 viewMatrix)
{
	float falloff = calculateXZLightFalloff(worldPosition, cameraEye, cameraTarget, viewMatrix);
	return mix(0.5, 1.0, falloff);
}

float calculateAmbientLightFalloff(vec3 worldPosition, vec3 cameraEye, vec3 cameraTarget)
{
	float falloff = calculateYLightFalloff(worldPosition, cameraEye, cameraTarget);
	return mix(0.5, 1.0, falloff);
}
