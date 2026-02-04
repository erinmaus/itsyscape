#include "Resources/Shaders/MapCurve.common.glsl"

varying vec3 frag_PretransformedPosition;
varying vec3 frag_PretransformedNormal;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	frag_PretransformedPosition = position.xzy;
	frag_PretransformedNormal = VertexNormal.xzy;

	vec3 warpedNormal = frag_Normal;
	vec3 warpedPosition = position.xyz;

	transformPointByCurves(warpedPosition, warpedNormal);

	localPosition = warpedPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * vec4(warpedPosition, 1.0);

	frag_Normal = warpedNormal;
}
