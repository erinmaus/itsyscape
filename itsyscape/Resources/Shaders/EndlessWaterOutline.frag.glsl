#include "Resources/Shaders/RendererPass.common.glsl"

#define SCAPE_ALPHA_DISCARD_THRESHOLD 0.1

uniform float scape_AlphaMask;
uniform vec4 scape_OutlineColor;

varying vec3 frag_Position;
varying vec3 frag_Normal;
varying vec2 frag_Texture;
varying vec4 frag_Color;

vec4 performEffect(vec4 color, vec2 textureCoordinate);

void effect()
{
	vec4 diffuse = performEffect(frag_Color, frag_Texture);

	if (diffuse.a < SCAPE_ALPHA_DISCARD_THRESHOLD)
	{
		discard;
	}

	float alpha = max(diffuse.a, scape_AlphaMask);

	love_Canvases[0] = vec4(alpha, scape_OutlineColor.r, 0.0, alpha);
	love_Canvases[1] = vec4(frag_Position.z, 0.0, 0.0, alpha);
}
