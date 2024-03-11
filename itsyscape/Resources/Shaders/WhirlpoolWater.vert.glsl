#line 1

uniform highp float scape_Time;
uniform highp vec4 scape_TimeScale;
uniform highp float scape_YOffset;

const float PI = 3.1415926535;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	float offset1 = sin(scape_Time * PI + position.x / scape_TimeScale.w * PI * scape_TimeScale.z) * scape_YOffset;
	float offset2 = sin(scape_Time * PI + position.z / scape_TimeScale.w * PI * scape_TimeScale.z) * scape_YOffset;

	localPosition = position.xyz;
	localPosition.y += offset1 + offset2;

	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);
}
