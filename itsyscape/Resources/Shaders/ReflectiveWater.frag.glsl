uniform highp vec4 scape_TimeScale;
uniform Image scape_DiffuseTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate += sin(scape_Time * scape_TimeScale.y) * scape_TimeScale.x;
	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
