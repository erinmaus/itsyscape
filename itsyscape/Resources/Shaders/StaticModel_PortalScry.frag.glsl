uniform float scape_Time;

uniform Image scape_DiffuseTexture;
uniform Image scape_PortalTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	vec4 scry = Texel(scape_PortalTexture, textureCoordinate);
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 shape = Texel(scape_DiffuseTexture, textureCoordinate);

	float delta = (sin(scape_Time * 6 - frag_Position.x) + 1) / 2 * 0.25;
	if (shape.a < delta + 0.1)
	{
		discard;
	}
	shape.a = 1.0;

	return shape * scry * color;
}
