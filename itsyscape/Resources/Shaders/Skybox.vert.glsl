void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;

	vec4 transformedPosition = scape_ProjectionMatrix * mat4(transpose(mat3(scape_ViewMatrix))) * position;
	projectedPosition = transformedPosition.xyww;
}
