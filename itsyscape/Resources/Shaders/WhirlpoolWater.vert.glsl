uniform float scape_YOffset;
uniform float scape_WindSpeedMultiplier;
uniform vec3 scape_WindPatternMultiplier;

#include "Resources/Shaders/Wind.common.glsl"

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec3 transformedPosition = (scape_WorldMatrix * position).xyz;
	vec3 anchorPosition = transformedPosition - vec3(0.0, scape_YOffset, 0.0);
	vec3 worldPosition = transformedPosition;

	if (abs(position.x) <= 1 && abs(position.z) <= 1)
	{
		frag_Color = vec4(0.0, 0.0, 1.0, 1.0);		
	}

	transformWorldPositionByWave(
		scape_Time,
		scape_WindSpeed * scape_WindSpeedMultiplier,
		scape_WindDirection,
		scape_WindPattern * scape_WindPatternMultiplier,
		anchorPosition,
		worldPosition);

	vec3 normalWorldPositionLeft = transformedPosition - vec3(1.0, 0.0, 0.0);
	transformWorldPositionByWave(
		scape_Time,
		scape_WindSpeed * scape_WindSpeedMultiplier,
		scape_WindDirection,
		scape_WindPattern * scape_WindPatternMultiplier,
		anchorPosition - vec3(1.0, 0.0, 0.0),
		normalWorldPositionLeft);

	vec3 normalWorldPositionRight = transformedPosition + vec3(1.0, 0.0, 0.0);
	transformWorldPositionByWave(
		scape_Time,
		scape_WindSpeed * scape_WindSpeedMultiplier,
		scape_WindDirection,
		scape_WindPattern * scape_WindPatternMultiplier,
		anchorPosition + vec3(1.0, 0.0, 0.0),
		normalWorldPositionRight);

	vec3 normalWorldPositionTop = transformedPosition - vec3(0.0, 0.0, 1.0);
	transformWorldPositionByWave(
		scape_Time,
		scape_WindSpeed * scape_WindSpeedMultiplier,
		scape_WindDirection,
		scape_WindPattern * scape_WindPatternMultiplier,
		anchorPosition - vec3(0.0, 0.0, 1.0),
		normalWorldPositionTop);

	vec3 normalWorldPositionBottom = transformedPosition + vec3(0.0, 0.0, 1.0);
	transformWorldPositionByWave(
		scape_Time,
		scape_WindSpeed * scape_WindSpeedMultiplier,
		scape_WindDirection,
		scape_WindPattern * scape_WindPatternMultiplier,
		anchorPosition + vec3(0.0, 0.0, 1.0),
		normalWorldPositionBottom);

	vec3 normal = vec3(
		2.0 * (normalWorldPositionLeft.y - normalWorldPositionRight.y),
		4.0,
		2.0 * (normalWorldPositionTop.y - normalWorldPositionBottom.y));
	normal = normalize(normal);

	localPosition = (inverse(scape_WorldMatrix) * vec4(worldPosition, 1.0)).xyz;
	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);

	frag_Normal = normal;
}
