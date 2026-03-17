#include "Resources/Shaders/Wind.common.glsl"

uniform float scape_YOffset;
uniform float scape_WindSpeedMultiplier;
uniform vec3 scape_WindPatternMultiplier;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec3 transformedPosition = (scape_WorldMatrix * position).xyz;
	vec3 anchorPosition = transformedPosition - vec3(0.0, 0.0, scape_YOffset);
	vec3 worldPosition = transformedPosition;

	transformWorldPositionByWave(
		scape_Time,
		scape_WindSpeed * scape_WindSpeedMultiplier,
		scape_WindDirection,
		scape_WindPattern * scape_WindPatternMultiplier,
		anchorPosition.xzy,
		worldPosition.xzy);

	localPosition = (scape_InverseWorldMatrix * vec4(worldPosition, 1.0)).xyz;
	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);
}
