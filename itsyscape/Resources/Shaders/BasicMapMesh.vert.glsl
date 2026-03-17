#include "Resources/Shaders/MapCurve.common.glsl"

attribute vec4 VertexTileBounds;
attribute vec4 VertexTextureLayer;

varying highp vec4 frag_TileBounds;
varying highp vec4 frag_TextureLayer;
varying highp vec2 frag_RelativeTexture;

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

	frag_Normal = warpedNormal;
	frag_TileBounds = VertexTileBounds;
	frag_TextureLayer = VertexTextureLayer;
	frag_RelativeTexture = position.xz / scape_MapSize;
}
