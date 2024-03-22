uniform float scape_InColor;
uniform float scape_OutColor;

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float sample = Texel(texture, textureCoordinate).r;
	if (sample == 1.0)
	{
		return vec4(0.0, 0.0, scape_InColor, 1.0); // should be 0
	}
	else
	{
		return vec4(0.0, 0.0, scape_OutColor, 1.0); // should be infinity
	}
}
