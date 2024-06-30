varying vec3 frag_LocalPosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	frag_LocalPosition = position.xyz;
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;
}
