vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 sample = Texel(texture, textureCoordinate);
	if (sample.r == 1.0)
	{
		return vec4(textureCoordinate.st, 0.0, sample.a);
	}
	else
	{
		return vec4(-1.0, -1.0, 0.0, sample.a);
	}
}
