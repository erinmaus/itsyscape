#include "Resources/Shaders/SkinnedModel.common.glsl"

varying vec3 frag_ModelPosition;
varying vec3 frag_ModelNormal;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	frag_ModelPosition = localPosition;
	frag_ModelNormal = VertexNormal;

	basePerformTransform(modelViewProjectionMatrix, position, localPosition, projectedPosition);
}

#pragma option SCAPE_SKINNED_MODEL_TRANSFORM_FUNC_NAME basePerformTransform
