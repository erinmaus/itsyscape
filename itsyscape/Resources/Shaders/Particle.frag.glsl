#line 1

uniform Image scape_DiffuseTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 result = Texel(scape_DiffuseTexture, textureCoordinate) * color;

#ifdef SCAPE_ALPHA_MASK_PASS
	result.a = step(SCAPE_ALPHA_DISCARD_THRESHOLD, color.a);
#endif
	
	return result;
}
