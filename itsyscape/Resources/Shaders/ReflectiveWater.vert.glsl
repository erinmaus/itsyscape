uniform highp vec4 scape_TimeScale;
uniform highp float scape_YOffset;

const float PI = 3.1415926535;

float calculateWaveHeight(vec3 position)
{
	float offset1 = sin(scape_Time * PI + position.x / scape_TimeScale.w * PI * scape_TimeScale.z) * scape_YOffset;
	float offset2 = sin(scape_Time * PI + position.z / scape_TimeScale.w * PI * scape_TimeScale.z) * scape_YOffset;

	return offset1 + offset2;
}

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	localPosition.y += calculateWaveHeight(position.xyz);

	float top = calculateWaveHeight(localPosition - vec3(0.0, 0.0, -1.0));
	float bottom = calculateWaveHeight(localPosition - vec3(0.0, 0.0, 1.0));
	float left = calculateWaveHeight(localPosition - vec3(-1.0, 0.0, 0.0));
	float right = calculateWaveHeight(localPosition - vec3(1.0, 0.0, 0.0));
	frag_Normal = normalize(vec3(2.0 * (left - right), 4.0, 2.0 * (top - bottom)));

	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);
}
