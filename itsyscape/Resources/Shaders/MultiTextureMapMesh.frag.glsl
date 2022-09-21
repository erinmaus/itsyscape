uniform ArrayImage scape_DiffuseTexture;

varying vec4 frag_TileBounds1;
varying vec4 frag_TileBounds2;
varying vec4 frag_TileBounds3;
varying vec4 frag_TileBounds4;

varying vec2 frag_WeightLayer1;
varying vec2 frag_WeightLayer2;
varying vec2 frag_WeightLayer3;
varying vec2 frag_WeightLayer4;

vec4 sampleTexture(vec2 textureCoordinate, vec4 tileBounds, vec2 weightLayer)
{
	vec2 local;
	local.s = tileBounds.x + (tileBounds.y - tileBounds.x) * textureCoordinate.s;
	local.t = tileBounds.z + (tileBounds.w - tileBounds.z) * textureCoordinate.t;

	textureCoordinate.s = mod(local.s, (tileBounds.y - tileBounds.x)) + tileBounds.x;
	textureCoordinate.t = mod(local.t, (tileBounds.w - tileBounds.z)) + tileBounds.z;

	return Texel(scape_DiffuseTexture, vec3(textureCoordinate, 0)) * weightLayer.x;
}

vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	textureCoordinate.t = 1.0 - textureCoordinate.t;

	vec4 result = sampleTexture(textureCoordinate, frag_TileBounds1, frag_WeightLayer1) +
	              sampleTexture(textureCoordinate, frag_TileBounds2, frag_WeightLayer2) +
	              sampleTexture(textureCoordinate, frag_TileBounds3, frag_WeightLayer3) +
	              sampleTexture(textureCoordinate, frag_TileBounds4, frag_WeightLayer4);

	return result * color;
}
