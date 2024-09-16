#include "Resources/Shaders/Edge.common.glsl"

uniform vec2 scape_TexelSize;
uniform sampler2D scape_OutlineTexture;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float alpha = Texel(scape_OutlineTexture, textureCoordinate).a;

	float sobel = getGreyEdge(image, textureCoordinate, scape_TexelSize, 0.0);
	float outline = step(0.4, sobel);

	if (outline >= 1.0 && alpha == 0.0)
	{
		alpha = 1.0;
	}

	vec3 outlineColor = vec3(Texel(scape_OutlineTexture, textureCoordinate).y);
	if (outline < 1.0)
	{
		return vec4(vec3(1.0), alpha);
	}

    return vec4(outlineColor, alpha);
}
