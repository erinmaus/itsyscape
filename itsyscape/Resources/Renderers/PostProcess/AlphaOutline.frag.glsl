#include "Resources/Shaders/Edge.common.glsl"

uniform vec2 scape_TexelSize;
uniform sampler2D scape_AlphaMaskTexture;
uniform sampler2D scape_OutlineColorTexture;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float alpha = Texel(scape_AlphaMaskTexture, textureCoordinate).a;

	float sobel = getGreyEdge(image, textureCoordinate, scape_TexelSize, 0.0);
	float outline = step(0.2, sobel);

	if (outline >= 1.0 && alpha == 0.0)
	{
		alpha = 1.0;
	}

	vec3 outlineColor = Texel(scape_OutlineColorTexture, textureCoordinate).rgb;
	if (outline < 1.0)
	{
		return vec4(1.0);
	}

    return vec4(outlineColor, alpha);
}
