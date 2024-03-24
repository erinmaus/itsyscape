uniform float scape_Near;
uniform float scape_Far;
uniform float scape_MinDepth;
uniform float scape_MaxDepth;
uniform vec2 scape_TexelSize;
uniform float scape_OutlineThickness;

float linearDepth(float depthSample)
{
	depthSample = 2.0 * depthSample - 1.0;
	float zLinear = 2.0 * scape_Near * scape_Far / (scape_Far + scape_Near - depthSample * (scape_Far - scape_Near));
	return zLinear;
}

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float halfOutlineThickness = ceil(scape_OutlineThickness / 2.0) - 1;
	vec2 halfTexelSize = scape_TexelSize / 2.0;

	float referenceDepthSample = linearDepth(Texel(texture, textureCoordinate).r);

	float sumDepthSamples = 0.0;
	float numDepthSamples = 0.0;
	float minDepthSample = referenceDepthSample;
	float maxDepthSample = referenceDepthSample;
	for (float x = -halfOutlineThickness; x <= halfOutlineThickness; x += 1.0)
	{
		for (float y = -halfOutlineThickness; y <= halfOutlineThickness; y += 1.0)
		{
			vec2 otherDepthSampleTextureCoordinate = textureCoordinate + vec2(x, y) * scape_TexelSize;
			float otherDepthSample = linearDepth(Texel(texture, otherDepthSampleTextureCoordinate).r);

			sumDepthSamples += otherDepthSample;
			numDepthSamples += 1.0;
			maxDepthSample = max(otherDepthSample, maxDepthSample);
			minDepthSample = min(otherDepthSample, minDepthSample);
		}
	}

	//return step(9.0, numDepthSamples) * vec4(1.0, 0.0, 0.0, 1.0);

	// reference: 0.5
	// sum: 5
	// num: 10

	// 5 - (10 * 0.5)

	//float d = sumDepthSamples - (referenceDepthSample * numDepthSamples);
	//float d = 1.0 - smoothstep(scape_MinDepth, scape_MaxDepth, referenceDepthSample - (sumDepthSamples / numDepthSamples));
	//float d = referenceDepthSample;
	// float d1 = minDepthSample;
	// //float d2 = smoothstep(scape_MinDepth, scape_MaxDepth, d1);
	// float d2 = 0.0;
	// float d3 = maxDepthSample;
	// float d4 = referenceDepthSample;
	float difference = (sumDepthSamples / numDepthSamples) - minDepthSample;
	float d = 1.0 - smoothstep(scape_MinDepth, scape_MaxDepth, difference);
	//float d = difference;
	//float d = step(scape_MinDepth, difference) * step(difference, scape_MaxDepth);

	//float d = sumDepthSamples - (referenceDepthSample * numDepthSamples);
	//float d = referenceDepthSample;
	//float d = sumDepthSamples - (referenceDepthSample * numDepthSamples);

	//float minDepth = scape_MinDepth / depthRange;
	//float maxDepth = scape_MaxDepth / depthRange;

	//float d = 0.0;
	//d = smoothstep(scape_MinDepth, scape_MaxDepth, d) * depthRange;
	//d = smoothstep(minDepth, maxDepth, d);


	// if (numSamples > scape_OutlineThickness || numSamples < 1.0)
	// {
	// 	d = 1.0;
	// }

	// if (d > scape_MaxDepth)
	// {
	// 	d = 0.0;
	// }
	// else
	// {
	// 	d = 1.0;
	// }

	return vec4(color.rgb * d, 1);
}
