#line 1

uniform float scape_Time;
uniform vec4 scape_TimeScale;
uniform float scape_YOffset;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	float offset1 = sin(scape_Time * radians(180) + position.x / scape_TimeScale.w * radians(180) * scape_TimeScale.z) * scape_YOffset;
	float offset2 = sin(scape_Time * radians(180) + position.z / scape_TimeScale.w * radians(180) * scape_TimeScale.z) * scape_YOffset;

	localPosition = position.xyz;
	localPosition.y += offset1 + offset2;

	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);
}
