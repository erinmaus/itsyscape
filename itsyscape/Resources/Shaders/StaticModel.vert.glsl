void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = (scape_WorldMatrix * position).xyz;
	projectedPosition = modelViewProjectionMatrix * position;
}
