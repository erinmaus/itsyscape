uniform float scape_Time;
uniform Image scape_DiffuseTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 result = Texel(scape_DiffuseTexture, textureCoordinate) * color;

	float delta = (sin(scape_Time * 2 - frag_Position.x) + 1) / 2 * 0.25;
	if (result.a < delta + 0.1)
	{
		discard;
	}

	result.a = 1.0;

	return result;
}
