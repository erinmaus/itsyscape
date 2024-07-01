uniform ArrayImage scape_DiffuseTexture;

varying float frag_Layer;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, vec3(textureCoordinate, frag_Layer)) * color;
}
