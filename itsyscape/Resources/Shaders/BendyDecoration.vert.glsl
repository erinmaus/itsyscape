uniform Image scape_BumpCanvas;

#include "Resources/Shaders/MapCurve.common.glsl"
#include "Resources/Shaders/Wind.common.glsl"

attribute vec3 FeaturePosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec4 featureWorldPosition = scape_WorldMatrix * vec4(FeaturePosition, 1.0);
	vec2 relativePosition = featureWorldPosition.xz / scape_MapSize;

	vec3 bendyPosition = position.xyz;
	vec3 normal;
	transformWorldPositionByBump(scape_BumpCanvas, relativePosition, 1.0, FeaturePosition, bendyPosition);
	transformWorldPositionByWind(scape_Time, scape_WindSpeed, scape_WindDirection, scape_WindPattern, FeaturePosition, bendyPosition, normal);

	vec4 warpedPosition = vec4(transformPointByCurves(bendyPosition), position.w);

	localPosition = warpedPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * warpedPosition;
}
