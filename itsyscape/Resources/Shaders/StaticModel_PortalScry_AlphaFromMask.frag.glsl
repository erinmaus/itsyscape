uniform float scape_Time;

uniform Image scape_DiffuseTexture;
uniform Image scape_PortalTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 mask = Texel(scape_DiffuseTexture, textureCoordinate);
	vec4 portal = Texel(scape_PortalTexture, textureCoordinate);

	vec4 result = portal * color;
	result.a *= mask.r * mask.a;

	return result;
}
