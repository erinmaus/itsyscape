varying vec3 frag_CubeNormal;
varying vec3 frag_CubePosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	frag_CubePosition = position.xyz;
	frag_CubeNormal = normalize(VertexNormal);

	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;
}
