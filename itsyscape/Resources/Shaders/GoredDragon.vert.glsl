#define SCAPE_SKINNED_MODEL_TRANSFORM_FUNC_NAME skinnedPerformTransform
#include "Resources/Shaders/SkinnedModel.common.glsl"

varying vec3 frag_PretransformedPosition;
varying vec3 frag_PretransformedNormal;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	frag_PretransformedPosition = position.xzy;
	frag_PretransformedNormal = VertexNormal.xzy;

	skinnedPerformTransform(modelViewProjectionMatrix, position, localPosition, projectedPosition);
}
