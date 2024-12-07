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

	vec3 normal = frag_Normal;

	vec3 direction = normal;
	if (dot(VertexNormal, vec3(0.0, 1.0, 0.0)) < 0.0)
	{
		direction = -direction;
	}

	vec3 beforeWorldOffset = normalize(mat3(scape_WorldMatrix) * direction) * vec3(scape_WindMaxDistance);
	vec3 beforeWorldPosition = (scape_WorldMatrix * vec4(localPosition, 1.0)).xyz;
	vec3 afterWorldPosition = beforeWorldPosition;
	transformWorldPositionByWind(
		scape_Time,
		scape_WindSpeed,
		scape_WindDirection,
		scape_WindPattern,
		beforeWorldPosition - beforeWorldOffset,
		afterWorldPosition,
		normal);

	localPosition = localPosition + (afterWorldPosition.xyz - beforeWorldPosition.xyz);
	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);

	frag_Normal = normal;
}
