varying vec2 frag_ScreenPosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;

	vec4 worldPosition = scape_WorldMatrix * position;
	float yOffset = (sin(worldPosition.x) + sin(worldPosition.z)) / 2.0 * 0.5;
	localPosition.y += yOffset;

	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);

	vec2 screenPosition = projectedPosition.xy / projectedPosition.w;
	screenPosition += vec2(1.0);
	screenPosition /= vec2(2.0);

	frag_ScreenPosition = screenPosition;
}
