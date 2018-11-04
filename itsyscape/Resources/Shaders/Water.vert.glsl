#line 1

uniform float scape_Time;
uniform vec3 scape_TimeScale;
uniform float scape_YOffset;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	float offset1 = sin(scape_Time * scape_TimeScale.z + position.x) * scape_YOffset;
	float offset2 = sin(scape_Time * scape_TimeScale.z + position.z) * scape_YOffset;

	localPosition = position.xyz;
	localPosition.y += offset1 + offset2;

	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);
}
