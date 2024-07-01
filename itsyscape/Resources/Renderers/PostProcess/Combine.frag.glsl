uniform sampler2D scape_Other;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec3 self = Texel(image, textureCoordinate).rgb;
	vec3 other = Texel(scape_Other, textureCoordinate).rgb;

	if (self.b < other.b)
	{
		return vec4(self, 1.0);
	}
	else
	{
		return vec4(other, 1.0);
	}
}
