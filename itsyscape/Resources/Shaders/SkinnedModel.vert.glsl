#define MAX_BONES 32
uniform mat4 scape_Bones[MAX_BONES];

attribute vec4 VertexBoneIndex;
attribute vec4 VertexBoneWeight;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec4 weightedBonePosition = vec4(0.0);
	mat4 m1 = scape_Bones[int(VertexBoneIndex.x) - 1];
	mat4 m2 = scape_Bones[int(VertexBoneIndex.y) - 1];
	mat4 m3 = scape_Bones[int(VertexBoneIndex.z) - 1];
	mat4 m4 = scape_Bones[int(VertexBoneIndex.w) - 1];
	weightedBonePosition += m1 * position * VertexBoneWeight.x;
	weightedBonePosition += m2 * position * VertexBoneWeight.y;
	weightedBonePosition += m3 * position * VertexBoneWeight.z;
	weightedBonePosition += m4 * position * VertexBoneWeight.w;

	localPosition = weightedBonePosition.xyz;
	projectedPosition = modelViewProjectionMatrix * weightedBonePosition;
}
