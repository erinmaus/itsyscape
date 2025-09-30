varying vec3 frag_ModelPosition;
varying vec3 frag_ModelNormal;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	frag_ModelPosition = position.xyz;
	frag_ModelNormal = VertexNormal;

	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;

}
