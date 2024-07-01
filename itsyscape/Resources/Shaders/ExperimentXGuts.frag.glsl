uniform Image scape_DiffuseTexture;
uniform highp float scape_Offset;

varying vec2 frag_Direction;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	if ((frag_Direction.x > 0.0 && frag_Direction.y > 0.0) ||
	    (frag_Direction.x < 0.0 && frag_Direction.y < 0.0))
	{
		discard;
	}

	textureCoordinate.t = 1.0 - textureCoordinate.t;

	textureCoordinate.s += mix(-(1.0 / 16.0), (1.0 / 16.0), sin((scape_Time + scape_Offset) * 3.14 / 2.0) * cos(textureCoordinate.t * 3.14 * 2.0));
    textureCoordinate.s = mod(textureCoordinate.s, 1.0);
    textureCoordinate.t = mod(textureCoordinate.t, 1.0);

	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
