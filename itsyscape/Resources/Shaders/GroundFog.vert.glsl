#include "Resources/Shaders/MapCurve.common.glsl"

attribute vec3 ParticlePosition;

varying vec3 frag_ParticlePosition;
varying vec3 frag_LocalPosition;
varying vec2 frag_ScreenPosition;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec3 warpedNormal = vec3(0.0);
	vec3 warpedPosition = position.xyz;
	transformPointByCurves(warpedPosition, warpedNormal);

	localPosition = warpedPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * vec4(warpedPosition, 1.0);

	frag_LocalPosition = position.xyz;
	frag_ParticlePosition = (scape_WorldMatrix * vec4(ParticlePosition, 1.0)).xyz;

	vec2 screenPosition = projectedPosition.xy / projectedPosition.w;
	screenPosition += vec2(1.0);
	screenPosition /= vec2(2.0);

	frag_ScreenPosition = screenPosition;
}
