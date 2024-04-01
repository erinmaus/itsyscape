uniform float scape_Near;
uniform float scape_Far;
uniform float scape_PlanarComparisonFactor;
uniform float scape_MinPlanarDepth;
uniform float scape_MaxPlanarDepth;
uniform float scape_MinDepth;
uniform float scape_MaxDepth;
uniform vec2 scape_TexelSize;
uniform float scape_OutlineThickness;
uniform sampler2D scape_NormalTexture;
uniform sampler2D scape_AlphaMaskTexture;

float linearDepth(float depthSample)
{
	depthSample = 2.0 * depthSample - 1.0;
	float zLinear = 2.0 * scape_Near * scape_Far / (scape_Far + scape_Near - depthSample * (scape_Far - scape_Near));
	return zLinear;
}

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	float halfOutlineThickness = scape_OutlineThickness / 2.0;
	vec2 halfTexelSize = scape_TexelSize / 2.0;

	float referenceDepthSample = linearDepth(Texel(texture, textureCoordinate).r);
	vec3 referenceNormal = Texel(texture, textureCoordinate).xyz;

	float sumDepthSamples = 0.0;
	float sumNormalDot = 0.0;
	float numDepthSamples = 0.0;
	float minDepthSample = referenceDepthSample;
	float maxDepthSample = referenceDepthSample;
	float minAlpha = 1.0;
	for (float x = -halfOutlineThickness; x <= halfOutlineThickness; x += 1.0)
	{
		for (float y = -halfOutlineThickness; y <= halfOutlineThickness; y += 1.0)
		{
			vec2 otherDepthSampleTextureCoordinate = textureCoordinate + vec2(x, y) * scape_TexelSize;
			float otherDepthSample = linearDepth(Texel(texture, otherDepthSampleTextureCoordinate).r);
			vec3 otherNormal = Texel(scape_NormalTexture, otherDepthSampleTextureCoordinate).xyz;
			float alpha = Texel(scape_AlphaMaskTexture, otherDepthSampleTextureCoordinate).r;

			sumDepthSamples += otherDepthSample - referenceDepthSample;
			numDepthSamples += 1.0;
			sumNormalDot += dot(referenceNormal, otherNormal);
			maxDepthSample = max(otherDepthSample, maxDepthSample);
			minDepthSample = min(otherDepthSample, minDepthSample);
			minAlpha = min(minAlpha, alpha);
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
	float normalDifference = abs(sumNormalDot / numDepthSamples);
	float minDepthComparison = scape_MinDepth;
	float maxDepthComparison = scape_MaxDepth;
	if (normalDifference < scape_PlanarComparisonFactor && (maxDepthSample - referenceDepthSample) < scape_MaxPlanarDepth)
	{
		minDepthComparison = scape_MinPlanarDepth;
		maxDepthComparison = scape_MaxPlanarDepth;
	}

	float difference = abs(sumDepthSamples / numDepthSamples);
	float d = smoothstep(minDepthComparison, maxDepthComparison, difference);
	//d = 1.0 - d;
	d = 1.0 - step(0.4, d);
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

	//return vec4(color.rgb * vec3(sumDepthSamples / numDepthSamples, minDepthSample, d), 1);
	return vec4(color.rgb * vec3(d), minAlpha);
}
