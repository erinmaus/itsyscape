uniform Image scape_DiffuseTexture;
uniform Image scape_PortalTexture;
uniform vec2 scape_ScreenSize;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	vec2 screenSpaceTextureCoordinate = gl_FragCoord.xy / scape_ScreenSize;
	screenSpaceTextureCoordinate.y = 1.0 - screenSpaceTextureCoordinate.y;
	textureCoordinate.y = 1.0 - textureCoordinate.y;

	vec4 portalTexture = Texel(scape_PortalTexture, screenSpaceTextureCoordinate);
	vec4 particleTexture = Texel(scape_DiffuseTexture, textureCoordinate);

	vec4 result = portalTexture * particleTexture * color;
	return result;
}
