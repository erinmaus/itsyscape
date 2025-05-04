attribute vec3 ParticlePosition;

varying vec3 frag_ParticlePosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;

	frag_ParticlePosition = (scape_WorldMatrix * vec4(ParticlePosition, 1.0)).xyz;
}
