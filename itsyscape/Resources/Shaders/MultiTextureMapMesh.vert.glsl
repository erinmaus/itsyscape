#line 1

uniform Image scape_DataTexture1;
uniform Image scape_DataTexture2;
uniform Image scape_DataTexture3;
uniform Image scape_DataTexture4;
uniform vec2 scape_DataTextureSize;

attribute float VertexIndex;

varying vec4 frag_TileBounds1;
varying vec4 frag_TileBounds2;
varying vec4 frag_TileBounds3;
varying vec4 frag_TileBounds4;

varying vec2 frag_WeightLayer1;
varying vec2 frag_WeightLayer2;
varying vec2 frag_WeightLayer3;
varying vec2 frag_WeightLayer4;

void sampleDataTexture(Image dataTexture, float index, out vec4 tileBounds, out vec2 weightLayer)
{
	vec2 v1 = vec2(mod(index * 2, scape_DataTextureSize.x), floor((index * 2) / scape_DataTextureSize.x));
	v1 /= scape_DataTextureSize;

	vec2 v2 = vec2(mod(index * 2 + 1, scape_DataTextureSize.x), floor((index * 2 + 1) / scape_DataTextureSize.x));
	v2 /= scape_DataTextureSize;

	tileBounds = Texel(dataTexture, v1);
	weightLayer = Texel(dataTexture, v2).xy;
}

void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;

	sampleDataTexture(scape_DataTexture1, VertexIndex, frag_TileBounds1, frag_WeightLayer1);
	sampleDataTexture(scape_DataTexture2, VertexIndex, frag_TileBounds2, frag_WeightLayer2);
	sampleDataTexture(scape_DataTexture3, VertexIndex, frag_TileBounds3, frag_WeightLayer3);
	sampleDataTexture(scape_DataTexture4, VertexIndex, frag_TileBounds4, frag_WeightLayer4);
}
