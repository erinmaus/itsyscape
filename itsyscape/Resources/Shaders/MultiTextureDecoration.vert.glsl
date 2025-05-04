#include "Resources/Shaders/MapCurve.common.glsl"

attribute float VertexLayer;

varying float frag_Layer;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec4 warpedPosition = vec4(transformPointByCurves(position.xyz), position.w);

	localPosition = warpedPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * warpedPosition;

	frag_Layer = VertexLayer;
}
