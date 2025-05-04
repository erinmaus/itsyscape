#pragma option SCAPE_LIGHT_MODEL_V2

uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	vec4 specularSample = Texel(scape_SpecularTexture, textureCoordinate);
	vec4 colorSample = Texel(scape_DiffuseTexture, textureCoordinate);

	specular = specularSample.r * specularSample.a;
	color = colorSample * color * vec4(mix(vec3(min(specular + 0.25, 1.0)), vec3(1.0), 1.0 - specularSample.a), 1.0);
}	

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
