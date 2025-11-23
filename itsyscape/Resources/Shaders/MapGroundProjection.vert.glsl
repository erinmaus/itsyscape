uniform vec2 scape_MapOffset;
uniform vec2 scape_MapSize;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;

	frag_Texture = (position.xz - scape_MapOffset) / scape_MapSize;
}
