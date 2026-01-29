varying vec2 frag_ScreenPosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;

	vec2 screenPosition = projectedPosition.xy / projectedPosition.w;
	screenPosition += vec2(1.0);
	screenPosition /= vec2(2.0);

	frag_ScreenPosition = screenPosition;
}
