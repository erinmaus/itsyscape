uniform Image scape_ShadowTexture;
uniform Image scape_MaskTexture;

varying vec2 frag_Texture;

void effect()
{
	vec2 textureCoordinate = frag_Texture;
	textureCoordinate.y = 1.0 - textureCoordinate.y;

	vec4 maskSample = Texel(scape_MaskTexture, frag_Texture);
	vec4 shadowSample = Texel(scape_MaskTexture, frag_Texture);

	if (maskSample.a <= 0.0)
	{
		discard;
	}

	love_Canvases[0] = shadowSample;
	love_Canvases[1] = maskSample;
}
