#pragma option SCAPE_LIGHT_MODEL_V2

void performAdvancedEffect(vec2 textureCoordinate, inout vec4 color, inout vec3 position, inout vec3 normal, out vec4 specular)
{
	color = performEffect(color, textureCoordinate);
	specular = vec4(0.0, 0.0, 0.0, 1.0);
}
