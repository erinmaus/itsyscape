uniform vec2 scape_TextureSize;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 result = Texel(image, textureCoordinate);
	if (
		result.r >= 0.0 && result.r < 1.0 &&
		result.g >= 0.0 && result.g < 1.0 &&
		result.b >= 0.0 && result.b < 1.0 &&
		result.a > 0.0
	) {
		return vec4(0.5, 0.5, 0.0, result.a);
	}
	else
	{
		return vec4(0.0, 0.0, 1.0, result.a);
	}
}
