#line 1

uniform Image scape_DiffuseTexture;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;
	vec4 result = Texel(scape_DiffuseTexture, textureCoordinate) * color;

#ifdef SCAPE_PARTICLE_OUTLINE_PASS
	result.a = step(SCAPE_ALPHA_DISCARD_THRESHOLD, result.a);
#endif
	
	return result;
}
