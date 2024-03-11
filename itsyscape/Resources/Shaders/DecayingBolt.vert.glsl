varying highp vec2 frag_ScreenCoord;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;

	vec3 normalizedCoordinates = projectedPosition.xyz / projectedPosition.w;
	frag_ScreenCoord = normalizedCoordinates.xy * vec2(0.5) + vec2(0.5);
}
