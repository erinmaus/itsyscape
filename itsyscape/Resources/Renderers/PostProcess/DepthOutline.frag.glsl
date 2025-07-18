#include "Resources/Shaders/Edge.common.glsl"

uniform vec2 scape_TexelSize;
uniform float scape_DepthStep;
uniform float scape_NormalStep;
uniform sampler2D scape_NormalTexture;
uniform sampler2D scape_OutlineColorTexture;
uniform mat4 scape_InverseProjectionMatrix;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float depthSample = Texel(image, textureCoordinate).r;
	vec3 normalSample = decodeGBufferNormal(Texel(scape_NormalTexture, textureCoordinate).xy);
	float linearDepth = linearDepth(depthSample);
	vec4 outlineSample = Texel(scape_OutlineColorTexture, textureCoordinate);
	float outlineThreshold = (outlineSample.z - 0.5) * 2.0;
	vec3 outlineColor = vec3(outlineSample.y);

    vec4 clipSpacePosition = vec4(textureCoordinate * vec2(2.0) - vec2(1.0), -1.0, 1.0);
    vec4 viewSpacePosition = scape_InverseProjectionMatrix * clipSpacePosition;
    viewSpacePosition /= vec4(viewSpacePosition.w);

    float normalDotView = dot(viewSpacePosition.xyz, normalSample);

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

	float depthEdgeStep = max(scape_DepthStep + abs(outlineThreshold), 0.0);
	float normalEdgeStep = max(scape_NormalStep, 0.0);

	float edge = max(step(normalEdgeStep, normalEdge), step(depthEdgeStep, depthEdge));
	if (edge < 1.0)
	{
		return vec4(1.0);
	}

	return vec4(outlineColor, 1.0);
}
