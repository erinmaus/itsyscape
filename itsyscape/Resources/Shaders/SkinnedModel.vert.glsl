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
	vec4 weightedBonePosition = vec4(0);
	weightedBonePosition += scape_Bones[int(VertexBoneIndex.x) - 1]  * position * VertexBoneWeight.x;
	weightedBonePosition += scape_Bones[int(VertexBoneIndex.y) - 1]  * position * VertexBoneWeight.y;
	weightedBonePosition += scape_Bones[int(VertexBoneIndex.z) - 1]  * position * VertexBoneWeight.z;
	weightedBonePosition += scape_Bones[int(VertexBoneIndex.w) - 1]  * position * VertexBoneWeight.w;

	localPosition = weightedBonePosition.xyz;
	projectedPosition = modelViewProjectionMatrix * weightedBonePosition;
}
