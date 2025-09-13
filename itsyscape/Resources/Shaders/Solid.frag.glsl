#pragma option SCAPE_LIGHT_MODEL_V2

uniform float scape_Specular;

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out float specular)
{
	specular = scape_Specular;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	return color;
}
