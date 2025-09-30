#include "Resources/Shaders/MapCurve.common.glsl"

attribute float VertexLayer;

varying float frag_Layer;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec3 warpedNormal = frag_Normal;
	vec3 warpedPosition = position.xyz;

	transformPointByCurves(warpedPosition, warpedNormal);

	localPosition = warpedPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * vec4(warpedPosition, 1.0);

	frag_Normal = warpedNormal;
	frag_Layer = VertexLayer;
}
