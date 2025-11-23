uniform Image scape_DiffuseTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	if (abs(frag_Normal.y) < 0.01)
	{
		discard;
	}

	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
