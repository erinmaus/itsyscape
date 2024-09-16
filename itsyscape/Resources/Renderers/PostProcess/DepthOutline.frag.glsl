#include "Resources/Shaders/Edge.common.glsl"

uniform vec2 scape_TexelSize;
uniform float scape_DepthStep;
uniform float scape_NormalStep;
uniform sampler2D scape_NormalTexture;
uniform sampler2D scape_OutlineTexture;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float depthSample = Texel(image, textureCoordinate).r;
	float linearDepth = linearDepth(depthSample);
	vec4 outlineSample = Texel(scape_OutlineTexture, textureCoordinate);
	float outlineThreshold = (outlineSample.z - 0.5) * 2.0;
	vec3 outlineColor = vec3(outlineSample.y);
	float depthEdge = getDepthEdge(image, textureCoordinate, scape_TexelSize, step(0.0, outlineThreshold));
	float normalEdge = getNormalEdge(scape_NormalTexture, textureCoordinate, scape_TexelSize);
	float depthEdgeStep = max(scape_DepthStep + abs(outlineThreshold), 0.0);
	float normalEdgeStep = max(scape_NormalStep, 0.0);

	float edge = max(step(normalEdgeStep, normalEdge), step(depthEdgeStep, depthEdge));
	if (edge < 1.0)
	{
		return vec4(1.0);
	}

	return vec4(outlineColor, 1.0);
}
