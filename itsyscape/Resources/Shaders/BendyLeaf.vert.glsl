uniform Image scape_BumpCanvas;
uniform float scape_BumpForce;
uniform vec2 scape_MapSize;

#include "Resources/Shaders/Wind.common.glsl"
#include "Resources/Shaders/Quaternion.common.glsl"
#include "Resources/Shaders/Bump.common.glsl"

attribute vec3 FeaturePosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec3 bendyPosition = position.xyz;
	vec3 featureWorldPosition = (scape_WorldMatrix * vec4(FeaturePosition, 1.0)).xyz;
	vec3 vertexWorldPosition = (scape_WorldMatrix * position).xyz;

	if (scape_BumpForce != 0.0)
	{
		vec2 relativeFeaturePosition = featureWorldPosition.xz / max(scape_MapSize, vec2(1.0, 1.0));
		 transformWorldPositionByBump(scape_BumpCanvas, relativeFeaturePosition, scape_BumpForce, FeaturePosition, bendyPosition);
	}

	vec3 normal = VertexNormal;
	transformWorldPositionByWind(
		scape_Time,
		scape_WindSpeed,
		scape_WindDirection,
		scape_WindPattern,
		bendyPosition - vec3(0.0, scape_WindMaxDistance, 0.0),
		bendyPosition,
		normal);

	localPosition = bendyPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);
}
