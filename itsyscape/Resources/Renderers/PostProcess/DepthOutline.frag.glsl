#include "Resources/Shaders/Edge.common.glsl"

uniform vec2 scape_TexelSize;
uniform float scape_DepthStep;
uniform float scape_NormalStep;
uniform sampler2D scape_NormalTexture;
uniform sampler2D scape_OutlineColorTexture;
uniform vec3 scape_Forward;

// These variables below might need to be configurable in the future,
// but we need to come up with better names first.

const float SCAPE_DEPTH_EDGE_FALL_OFF = 32.0;
const float SCAPE_DEPTH_EDGE_FALL_OFF_RANGE = 16.0;
const float SCAPE_DEPTH_EDGE_FALL_OFF_STEP = 0.5;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float depthSample = Texel(image, textureCoordinate).r;
	vec3 normalSample = decodeGBufferNormal(Texel(scape_NormalTexture, textureCoordinate).xy);
	float linearDepth = linearDepth(depthSample);
	vec4 outlineSample = Texel(scape_OutlineColorTexture, textureCoordinate);
	float outlineThreshold = (outlineSample.z - 0.5) * 2.0;
	vec3 outlineColor = vec3(outlineSample.y);

	float depthEdge = getDepthEdge(image, textureCoordinate, scape_TexelSize, step(0.0, outlineThreshold));
	float normalEdge = getNormalEdge(scape_NormalTexture, textureCoordinate, scape_TexelSize);

    float normalDotView = max(dot(normalize(scape_Forward), normalSample), 0.0);
	float depthEdgeStepComponent1 = abs(outlineThreshold) * normalDotView;
	float depthEdgeStepComponent2 = 0.0;
	if (outlineThreshold >= 0.0)
	{
		depthEdgeStepComponent2 = clamp((linearDepth - SCAPE_DEPTH_EDGE_FALL_OFF) / SCAPE_DEPTH_EDGE_FALL_OFF_RANGE, 0.0, 1.0) * SCAPE_DEPTH_EDGE_FALL_OFF_STEP;
	}

	float depthEdgeStep = max(scape_DepthStep + max(depthEdgeStepComponent1, depthEdgeStepComponent2), 0.0);
	float normalEdgeStep = max(scape_NormalStep, 0.0);

	float edge = max(step(normalEdgeStep, normalEdge), step(depthEdgeStep, depthEdge));
	if (edge < 1.0)
	{
		return vec4(1.0);
	}

	return vec4(outlineColor, 1.0);
}
