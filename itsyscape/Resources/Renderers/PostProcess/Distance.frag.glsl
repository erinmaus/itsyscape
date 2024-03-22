uniform float scape_Beta;
uniform vec2 scape_Offset;

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec3 selfPixel = Texel(texture, textureCoordinate).rgb;
	vec3 rightPixel = Texel(texture, textureCoordinate + scape_Offset).rgb;
	vec3 leftPixel = Texel(texture, textureCoordinate - scape_Offset).rgb;

	float A = selfPixel.b;
	float e = scape_Beta + rightPixel.b;
	float w = scape_Beta + leftPixel.b;
	float B = min(min(A, e), w);

	if (A == B)
	{
		discard;
	}

	vec4 result = vec4(vec3(0.0), 1.0);
	result.rg = leftPixel.rg;
	result.b = B;

	if (A <= e && e <= w)
	{
		result.rg = selfPixel.rg;
	}
	if (A <= w && w <= e)
	{
		result.rg = selfPixel.rg;
	}
	if (e <= A && A <= w)
	{
		result.rg = rightPixel.rg;
	}
	if (e <= w && w <= A)
	{
		result.rg = rightPixel.rg;
	}

	return result;
}
