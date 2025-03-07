uniform Image scape_DilateTexture;

vec4 effect(vec4 color, Image highlightTexture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 highlightSample = Texel(highlightTexture, textureCoordinate);
	vec4 dilateTexture = Texel(scape_DilateTexture, textureCoordinate);

	if (highlightSample.a == 0.0)
	{
		return dilateTexture;
	}

	return vec4(0.0);
}
