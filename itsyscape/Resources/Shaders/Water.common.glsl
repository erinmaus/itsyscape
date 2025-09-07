#include "Resources/Shaders/Math.common.glsl"

float calculateOldWaveHeight(vec3 position, vec2 timeScale, float time, float maxHeight)
{
	float offset1 = sin(time * SCAPE_PI + position.x * SCAPE_PI * timeScale.x) * maxHeight;
	float offset2 = sin(time * SCAPE_PI + position.z * SCAPE_PI * timeScale.x) * maxHeight;

	return position.y + offset1 + offset2;
}

vec3 calculateOldWaveNormal(vec3 localPosition, vec3 offset, vec2 timeScale, float time, float maxHeight)
{
	float top = calculateOldWaveHeight(localPosition - vec3(0.0, 0.0, -1.0) * offset, timeScale, time, maxHeight);
	float bottom = calculateOldWaveHeight(localPosition - vec3(0.0, 0.0, 1.0) * offset, timeScale, time, maxHeight);
	float left = calculateOldWaveHeight(localPosition - vec3(-1.0, 0.0, 0.0) * offset, timeScale, time, maxHeight);
	float right = calculateOldWaveHeight(localPosition - vec3(1.0, 0.0, 0.0) * offset, timeScale, time, maxHeight);

	return normalize(vec3(2.0 * (left - right), 4.0, 2.0 * (top - bottom)));
}
