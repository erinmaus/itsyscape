uniform Image scape_DiffuseTexture;

varying vec4 frag_TileBounds;

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	vec2 local;
	local.s = frag_TileBounds.x + (frag_TileBounds.y - frag_TileBounds.x) * textureCoordinate.s;
	local.t = frag_TileBounds.z + (frag_TileBounds.w - frag_TileBounds.z) * textureCoordinate.t;

	textureCoordinate.s = mod(local.s, (frag_TileBounds.y - frag_TileBounds.x)) + frag_TileBounds.x;
	textureCoordinate.t = mod(local.t, (frag_TileBounds.w - frag_TileBounds.z)) + frag_TileBounds.z;

	return Texel(scape_DiffuseTexture, textureCoordinate) * color;
}
