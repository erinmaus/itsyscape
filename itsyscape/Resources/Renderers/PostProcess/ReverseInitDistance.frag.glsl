uniform vec2 scape_TextureSize;

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 sample = Texel(texture, textureCoordinate);
	if (sample.r == 1.0 && sample.a > 0.0)
	{
		return vec4(floor(textureCoordinate * scape_TextureSize), 0.0, sample.a);
	}
	else
	{
		return vec4(0.0, 0.0, -1.0, sample.a);
	}
}