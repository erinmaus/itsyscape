#include "Resources/Shaders/Edge.common.glsl"

uniform vec2 scape_TexelSize;
uniform float scape_DepthStep;
uniform float scape_NormalStep;
uniform sampler2D scape_NormalTexture;
uniform sampler2D scape_OutlineColorTexture;
uniform mat4 scape_InverseProjectionMatrix;

// These variables below might need to be configurable in the future,
// but we need to come up with better names first.

// 'scape_max_depth' makes the surface normal adjustment to the outline threshold
// have less effect the further away the depth sample from the near plane to account
// for depth precision issues further from the near plane.
const float SCAPE_MAX_DEPTH = 64.0;

// 'scape_max_depth_dot' sets the lower bound for the dot product.
// This is multiplied against the ratio of the world depth and 'scape_max_depth' above.
const float SCAPE_MIN_DEPTH_DOT = 0.5;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float depthSample = Texel(image, textureCoordinate).r;
	vec3 normalSample = decodeGBufferNormal(Texel(scape_NormalTexture, textureCoordinate).xy);
	float linearDepth = linearDepth(depthSample);
	vec4 outlineSample = Texel(scape_OutlineColorTexture, textureCoordinate);
	float outlineThreshold = (outlineSample.z - 0.5) * 2.0;
	vec3 outlineColor = vec3(outlineSample.y);

    vec4 clipSpacePosition = vec4(textureCoordinate, 0.0, 1.0);
    vec4 viewSpacePosition = scape_InverseProjectionMatrix * clipSpacePosition;
    viewSpacePosition /= vec4(viewSpacePosition.w);

    float normalDotView = max(dot(normalize(-viewSpacePosition.xyz), normalSample), min(linearDepth / SCAPE_MAX_DEPTH, SCAPE_MIN_DEPTH_DOT));

	float depthEdge = 0.0;
	float normalEdge = 0.0;
	for (float x = -1.0; x <= 1.0; x += 1.0)
	{
		for (float y = -1.0; y <= 1.0; y += 1.0)
		{
			depthEdge = max(depthEdge, getDepthEdge(image, textureCoordinate, scape_TexelSize, step(0.0, outlineThreshold)));
			normalEdge = max(normalEdge, getNormalEdge(scape_NormalTexture, textureCoordinate, scape_TexelSize));
		}
	}

	float depthEdgeStep = max(scape_DepthStep + abs(outlineThreshold) * normalDotView, 0.0);
	float normalEdgeStep = max(scape_NormalStep, 0.0);

	float edge = max(step(normalEdgeStep, normalEdge), step(depthEdgeStep, depthEdge));
	if (edge < 1.0)
	{
		return vec4(1.0);
	}

	return vec4(outlineColor, 1.0);
}
