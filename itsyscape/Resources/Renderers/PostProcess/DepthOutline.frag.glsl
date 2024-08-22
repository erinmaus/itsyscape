#include "Resources/Shaders/Edge.common.glsl"

uniform vec2 scape_TexelSize;
uniform float scape_DepthStep;
uniform float scape_NormalStep;
uniform sampler2D scape_NormalTexture;
uniform sampler2D scape_OutlineThresholdTexture;
uniform sampler2D scape_OutlineColorTexture;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float depthSample = Texel(image, textureCoordinate).r;
	float linearDepth = linearDepth(depthSample);
	float width = fwidth(linearDepth);
	float outlineThreshold = Texel(scape_OutlineThresholdTexture, textureCoordinate).a;
	vec3 outlineColor = Texel(scape_OutlineColorTexture, textureCoordinate).rgb;
	float depthEdge = getDepthEdge(image, textureCoordinate, scape_TexelSize, step(0.0, outlineThreshold));
	float normalEdge = getNormalEdge(scape_NormalTexture, textureCoordinate, scape_TexelSize);
	float depthEdgeStep = max(scape_DepthStep + abs(outlineThreshold), 0.0);
	float normalEdgeStep = max(scape_NormalStep, 0.0);

	float edge = max(step(normalEdgeStep, length(normalEdge)), step(depthEdgeStep, depthEdge));
	if (edge < 1.0)
	{
		return vec4(1.0);
	}

	return vec4(outlineColor, 1.0);
}
