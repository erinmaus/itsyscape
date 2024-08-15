#pragma option SCAPE_LIGHT_MODEL_V2

uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	specular = Texel(scape_SpecularTexture, textureCoordinate).r;
	color = Texel(scape_DiffuseTexture, textureCoordinate) * color * vec4(vec3(1.0 - (specular * specular)), 1.0);
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
