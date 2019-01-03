uniform float scape_Alpha;
uniform Image scape_DiffuseTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 result = Texel(scape_DiffuseTexture, textureCoordinate) * color;

	if (result.a < scape_Alpha || result.a < 1.0 / 255.0)
	{
		discard;
	}

	result.a = 1.0;

	return result;
}
