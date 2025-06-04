attribute vec3 ParticlePosition;

varying vec3 frag_ParticlePosition;
varying vec3 frag_LocalPosition;
varying vec2 frag_ScreenPosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;

	frag_LocalPosition = localPosition;
	frag_ParticlePosition = (scape_WorldMatrix * vec4(ParticlePosition, 1.0)).xyz;

	vec2 screenPosition = projectedPosition.xy / projectedPosition.w;
	screenPosition += vec2(1.0);
	screenPosition /= vec2(2.0);

	frag_ScreenPosition = screenPosition;
}
