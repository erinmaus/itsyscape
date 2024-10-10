#pragma option SCAPE_SKINNED_MODEL_TRANSFORM_FUNC_NAME basePerformTransform

#include "Resources/Shaders/SkinnedModel.common.glsl"

in float VertexLayer;

varying float frag_Layer;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	basePerformTransform(modelViewProjectionMatrix, position, localPosition, projectedPosition);

	frag_Layer = VertexLayer;
}
