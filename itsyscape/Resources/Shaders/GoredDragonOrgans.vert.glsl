#include "Resources/Shaders/Math.common.glsl"
#include "Resources/Shaders/MapCurve.common.glsl"

#define SCALE_FROM 0.95
#define SCALE_TO 1.05
#define SCALE_MULTIPLIER 1.5

attribute vec3 FeaturePosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec3 relativePosition = position.xyz - FeaturePosition;
	float mu = scape_Time + FeaturePosition.x + FeaturePosition.z + FeaturePosition.y;
	float delta = clamp(abs(sin(mu * SCAPE_PI) * SCALE_MULTIPLIER), 0.0, 1.0);
	relativePosition *= vec3(mix(SCALE_FROM, SCALE_TO, delta));

	localPosition = relativePosition + FeaturePosition;
	vec3 normal = frag_Normal;
	transformPointByCurves(localPosition, normal);

	projectedPosition = modelViewProjectionMatrix * vec4(localPosition, 1.0);
	frag_Normal = normal;
}
