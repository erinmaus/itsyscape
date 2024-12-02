#pragma option SCAPE_LIGHT_MODEL_V2

uniform Image scape_DiffuseTexture;
uniform Image scape_SpecularTexture;
uniform Image scape_CustomDiffuseTexture;

uniform vec4 scape_PrimaryColor;
uniform vec4 scape_SecondaryColor;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	vec2 maskSample = Texel(scape_CustomDiffuseTexture, textureCoordinate).ra;
	vec4 maskColor = mix(scape_PrimaryColor, scape_SecondaryColor, 1.0 - step(0.5, maskSample.x));

	vec4 specularSample = Texel(scape_SpecularTexture, textureCoordinate);
	vec4 colorSample = Texel(scape_DiffuseTexture, textureCoordinate);

	vec4 resultColor = mix(colorSample, maskColor, step(0.5, maskSample.y));

	specular = specularSample.r * specularSample.a + 0.2;
	color = resultColor * color * vec4(mix(vec3(specularSample), vec3(1.0), 1.0 - specularSample.a), 1.0);
}	

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
