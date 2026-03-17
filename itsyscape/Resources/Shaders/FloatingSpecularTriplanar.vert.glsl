#define MAX_NUM_PATTERNS 32

uniform int scape_NumPatterns;
uniform vec3 scape_Pattern[MAX_NUM_PATTERNS];

attribute float FeatureIndex;

varying vec3 frag_ModelPosition;
varying vec3 frag_ModelNormal;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	int index = int(FeatureIndex);
	index %= scape_NumPatterns;

	float offset = scape_Pattern[index].x;
	float scale = scape_Pattern[index].y;
	float distance = scape_Pattern[index].z;

	float delta = sin(scape_Time * scale + offset);
	position.y -= delta * distance;

	frag_ModelPosition = position.xyz;
	frag_ModelNormal = VertexNormal;

	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;
}
