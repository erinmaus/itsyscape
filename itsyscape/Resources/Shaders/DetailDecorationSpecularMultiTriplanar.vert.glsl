#include "Resources/Shaders/MapCurve.common.glsl"

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec3 warpedNormal = frag_Normal;
	vec3 warpedPosition = position.xyz;

	transformPointByCurves(warpedPosition, warpedNormal);

	localPosition = warpedPosition;
	projectedPosition = modelViewProjectionMatrix * vec4(warpedPosition, 1.0);
}
