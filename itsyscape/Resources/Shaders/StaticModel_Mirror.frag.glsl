uniform Image scape_DiffuseTexture;
uniform Image scape_ReflectionTexture;
uniform vec2 scape_TextureSize;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	//vec2 reflectionTexureCoordinate = gl_FragCoord.xy / scape_TextureSize;
	vec2 reflectionTexureCoordinate = vec2(textureCoordinate.s, 1.0 - textureCoordinate.t);

	vec4 reflection = Texel(scape_ReflectionTexture, reflectionTexureCoordinate);
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 shape = Texel(scape_DiffuseTexture, textureCoordinate);

	return shape * reflection * color;
}
