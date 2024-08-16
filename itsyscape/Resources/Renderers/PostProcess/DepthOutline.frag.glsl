#include "Resources/Shaders/Edge.common.glsl"

uniform vec2 scape_TexelSize;
uniform float scape_DepthStep;
uniform sampler2D scape_NormalTexture;
uniform sampler2D scape_OutlineColorTexture;

float getMinAlpha(Image image, vec2 textureCoordinate)
{
	float minAlpha = 1.0;

	for (float x = -1.0; x <= 1; x += 1.0)
	{
		for (float y = -1.0; y <= 1; y += 1.0)
		{
			float alpha = Texel(image, textureCoordinate + vec2(x, y) * scape_TexelSize).r;
			minAlpha = min(alpha, minAlpha);
		}
	}

	return minAlpha;
}

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float outlineThreshold = Texel(scape_NormalTexture, textureCoordinate).a;
	vec3 outlineColor = Texel(scape_OutlineColorTexture, textureCoordinate).rgb;
	float depthEdge = getDepthEdge(image, textureCoordinate, scape_TexelSize, step(0.0, outlineThreshold));

	float edge = step(max(scape_DepthStep + abs(outlineThreshold), 0.0), depthEdge);
	if (edge < 1.0)
	{
		return vec4(1.0);
	}

	return vec4(outlineColor, 1.0);
}
