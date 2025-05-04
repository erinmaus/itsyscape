#define MAX_BONES 48
uniform mat4 scape_Bones[MAX_BONES];

attribute vec4 VertexBoneIndex;
attribute vec4 VertexBoneWeight;
attribute float VertexDirection;

varying vec2 frag_Direction;

void applySkinToVertex(vec4 position, vec3 normal, vec4 boneIndices, vec4 boneWeights, out vec4 skinnedPosition, out vec3 skinnedNormal)
{
	mat4 m1 = scape_Bones[int(boneIndices.x) - 1];
	mat4 m2 = scape_Bones[int(boneIndices.y) - 1];
	mat4 m3 = scape_Bones[int(boneIndices.z) - 1];
	mat4 m4 = scape_Bones[int(boneIndices.w) - 1];

	vec4 weightedBonePosition = vec4(0.0);
	weightedBonePosition += m1 * position * boneWeights.x;
	weightedBonePosition += m2 * position * boneWeights.y;
	weightedBonePosition += m3 * position * boneWeights.z;
	weightedBonePosition += m4 * position * boneWeights.w;

	vec3 weightedNormal = vec3(0.0);
	weightedNormal += mat3(m1) * normal * boneWeights.x;
	weightedNormal += mat3(m2) * normal * boneWeights.y;
	weightedNormal += mat3(m3) * normal * boneWeights.z;
	weightedNormal += mat3(m4) * normal * boneWeights.w;

	skinnedPosition = weightedBonePosition;
	skinnedNormal = normalize(weightedNormal);
}

#ifndef SCAPE_SKINNED_MODEL_TRANSFORM_FUNC_NAME
	#define SCAPE_SKINNED_MODEL_TRANSFORM_FUNC_NAME performTransform
#endif

void SCAPE_SKINNED_MODEL_TRANSFORM_FUNC_NAME(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec4 skinnedPosition;
	vec3 skinnedNormal;
	applySkinToVertex(position, VertexNormal, VertexBoneIndex, VertexBoneWeight, skinnedPosition, skinnedNormal);

	localPosition = skinnedPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * skinnedPosition;

	frag_Direction = vec2(
		VertexDirection,
		(scape_ViewMatrix * scape_WorldMatrix * vec4(1.0, 0.0, 0.0, 0.0)).x
	);

	frag_Normal = normalize(mat3(scape_NormalMatrix) * normalize(skinnedNormal));
}
