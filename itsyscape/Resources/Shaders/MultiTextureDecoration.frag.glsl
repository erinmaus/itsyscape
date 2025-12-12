#pragma option SCAPE_LIGHT_MODEL_V2

uniform ArrayImage scape_DiffuseTexture;
uniform ArrayImage scape_SpecularTexture;

varying float frag_Layer;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	color *= Texel(scape_DiffuseTexture, vec3(textureCoordinate, frag_Layer));
	specular = Texel(scape_SpecularTexture, vec3(textureCoordinate, frag_Layer)).r;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, vec3(textureCoordinate, frag_Layer)) * color;
}
