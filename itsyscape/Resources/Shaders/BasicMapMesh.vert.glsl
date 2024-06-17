#include "Resources/Shaders/MapCurve.common.glsl"

attribute vec4 VertexTileBounds;
attribute vec4 VertexTextureLayer;

varying highp vec4 frag_TileBounds;
varying highp vec4 frag_TextureLayer;

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	vec4 warpedPosition = vec4(transformPointByCurves(position.xyz), position.w);

	localPosition = warpedPosition.xyz;
	projectedPosition = modelViewProjectionMatrix * warpedPosition;
	frag_TileBounds = VertexTileBounds;
	frag_TextureLayer = VertexTextureLayer;
}
