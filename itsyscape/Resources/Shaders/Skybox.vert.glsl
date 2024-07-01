void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	position *= vec4(vec3(0.25), 1.0);

	localPosition = position.xyz;

	vec4 transformedPosition = scape_ProjectionMatrix * mat4(transpose(mat3(scape_ViewMatrix))) * position;
	projectedPosition = transformedPosition.xyww;
}
