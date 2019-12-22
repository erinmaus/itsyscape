uniform float scape_Time;

uniform Image scape_DiffuseTexture;
uniform Image scape_ReflectionTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	vec4 reflection = Texel(scape_ReflectionTexture, textureCoordinate);
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 shape = Texel(scape_DiffuseTexture, textureCoordinate);

	return shape * reflection * color;
}
