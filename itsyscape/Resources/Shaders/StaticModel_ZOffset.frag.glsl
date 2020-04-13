uniform Image scape_DiffuseTexture;

varying float frag_Z;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	gl_FragDepth = frag_Z;

	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
