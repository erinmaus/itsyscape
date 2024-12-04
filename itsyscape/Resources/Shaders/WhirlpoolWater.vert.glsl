uniform float scape_YOffset;

#include "Resources/Shaders/Wind.common.glsl"

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec3 anchorPosition = (scape_WorldMatrix * position).xyz;
	vec3 worldPosition = anchorPosition + vec3(0.0, scape_YOffset, 0.0);

	vec3 normal = VertexNormal;
	transformWorldPositionByWind(
		scape_Time,
		scape_WindSpeed,
		scape_WindDirection,
		scape_WindPattern,
		anchorPosition,
		worldPosition,
		normal);

	localPosition = (worldPosition - anchorPosition) + position.xyz;
	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);

	frag_Normal = normal;
}
