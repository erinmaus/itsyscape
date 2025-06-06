uniform ArrayImage scape_DiffuseTexture;

varying vec2 frag_Direction;
varying float frag_Layer;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	if ((frag_Direction.x > 0.0 && frag_Direction.y > 0.0) ||
	    (frag_Direction.x < 0.0 && frag_Direction.y < 0.0))
	{
		discard;
	}

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, vec3(textureCoordinate, frag_Layer)) * color;
}
