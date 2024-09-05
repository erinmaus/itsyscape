#pragma option SCAPE_SKINNED_MODEL_TRANSFORM_FUNC_NAME basePerformTransform

#include "Resources/Shaders/SkinnedModel.common.glsl"
#include "Resources/Shaders/Wind.common.glsl"

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	basePerformTransform(modelViewProjectionMatrix, position, localPosition, projectedPosition);

	vec3 beforeWorldPosition = (scape_WorldMatrix * vec4(localPosition, 1.0)).xyz;
	vec3 afterWorldPosition = beforeWorldPosition;
	vec3 normal = VertexNormal;
	transformWorldPositionByWind(
		scape_Time,
		scape_WindSpeed,
		scape_WindDirection,
		scape_WindPattern,
		beforeWorldPosition - vec3(0.0, scape_WindMaxDistance, 0.0),
		afterWorldPosition,
		normal);

	localPosition = position.xyz + (afterWorldPosition.xyz - beforeWorldPosition.xyz);
	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);

	// frag_Normal = normal;
}
