#define MAX_BONES 48
uniform mat4 scape_Bones[MAX_BONES];

attribute vec4 VertexBoneIndex;
attribute vec4 VertexBoneWeight;
attribute float VertexDirection;

varying vec2 frag_Direction;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	mat4 m1 = scape_Bones[int(VertexBoneIndex.x) - 1];
	mat4 m2 = scape_Bones[int(VertexBoneIndex.y) - 1];
	mat4 m3 = scape_Bones[int(VertexBoneIndex.z) - 1];
	mat4 m4 = scape_Bones[int(VertexBoneIndex.w) - 1];

	vec4 weightedBonePosition = vec4(0.0);
	weightedBonePosition += m1 * position * VertexBoneWeight.x;
	weightedBonePosition += m2 * position * VertexBoneWeight.y;
	weightedBonePosition += m3 * position * VertexBoneWeight.z;
	weightedBonePosition += m4 * position * VertexBoneWeight.w;

	vec3 weightedNormal = vec3(0.0);
	weightedNormal += mat3(m1) * VertexNormal * VertexBoneWeight.x;
	weightedNormal += mat3(m2) * VertexNormal * VertexBoneWeight.y;
	weightedNormal += mat3(m3) * VertexNormal * VertexBoneWeight.z;
	weightedNormal += mat3(m4) * VertexNormal * VertexBoneWeight.w;

	localPosition = weightedBonePosition.xyz;
	projectedPosition = modelViewProjectionMatrix * weightedBonePosition;

	frag_Direction = vec2(
		VertexDirection,
		(scape_WorldMatrix * vec4(1.0, 0.0, 0.0, 0.0)).x
	);

	frag_Normal = normalize(mat3(scape_NormalMatrix) * normalize(weightedNormal));
}
