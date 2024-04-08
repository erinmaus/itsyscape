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
uniform vec4 scape_FarPlane;
uniform vec4 scape_NearPlane;

float linearDepth(float depthSample)
{
	depthSample = 2.0 * depthSample - 1.0;
	float zLinear = 2.0 * scape_Near * scape_Far / (scape_Far + scape_Near - depthSample * (scape_Far - scape_Near));
	return zLinear;
}

void makeDepthKernel(inout float n[9], sampler2D texture, vec2 textureCoordinate)
{
	float x = scape_TexelSize.x;
    float y = scape_TexelSize.y;

	n[4] = linearDepth(Texel(texture, textureCoordinate).r);
	n[0] = abs(linearDepth(Texel(texture, textureCoordinate + vec2( -x, -y)).r) - n[4]);
	n[1] = abs(linearDepth(Texel(texture, textureCoordinate + vec2(0.0, -y)).r) - n[4]);
	n[2] = abs(linearDepth(Texel(texture, textureCoordinate + vec2(  x, -y)).r) - n[4]);
	n[3] = abs(linearDepth(Texel(texture, textureCoordinate + vec2( -x, 0.0)).r) - n[4]);
	n[5] = abs(linearDepth(Texel(texture, textureCoordinate + vec2(  x, 0.0)).r) - n[4]);
	n[6] = abs(linearDepth(Texel(texture, textureCoordinate + vec2( -x, y)).r) - n[4]);
	n[7] = abs(linearDepth(Texel(texture, textureCoordinate + vec2(0.0, y)).r) - n[4]);
	n[8] = abs(linearDepth(Texel(texture, textureCoordinate + vec2(  x, y)).r) - n[4]);
}

float getDepthSobel(sampler2D texture, vec2 textureCoordinate)
{
	float n[9];
	makeDepthKernel(n, texture, textureCoordinate);

	float horizontalEdge = n[2] + (2.0 * n[5]) + n[8] - (n[0] + (2.0 * n[3]) + n[6]);
  	float verticalEdge = n[0] + (2.0 * n[1]) + n[2] - (n[6] + (2.0 * n[7]) + n[8]);
	float sobel = sqrt((horizontalEdge * horizontalEdge) + (verticalEdge * verticalEdge));

	return sobel;
}

void makeNormalKernel(inout vec4 n[9], sampler2D texture, vec2 textureCoordinate)
{
	float x = scape_TexelSize.x;
    float y = scape_TexelSize.y;

	n[0] = Texel(texture, textureCoordinate + vec2( -x, -y));
	n[1] = Texel(texture, textureCoordinate + vec2(0.0, -y));
	n[2] = Texel(texture, textureCoordinate + vec2(  x, -y));
	n[3] = Texel(texture, textureCoordinate + vec2( -x, 0.0));
	n[4] = Texel(texture, textureCoordinate);
	n[5] = Texel(texture, textureCoordinate + vec2(  x, 0.0));
	n[6] = Texel(texture, textureCoordinate + vec2( -x, y));
	n[7] = Texel(texture, textureCoordinate + vec2(0.0, y));
	n[8] = Texel(texture, textureCoordinate + vec2(  x, y));
}

float getNormalSobel(sampler2D texture, vec2 textureCoordinate)
{
	vec4 n[9];
	makeNormalKernel(n, texture, textureCoordinate);

	vec4 horizontalEdge = n[2] + (2.0 * n[5]) + n[8] - (n[0] + (2.0 * n[3]) + n[6]);
  	vec4 verticalEdge = n[0] + (2.0 * n[1]) + n[2] - (n[6] + (2.0 * n[7]) + n[8]);
	vec4 sobel = sqrt((horizontalEdge * horizontalEdge) + (verticalEdge * verticalEdge));

	return ((sobel.r + sobel.g + sobel.b) / 3.0) * n[4].w;
}

float getMinAlpha(Image texture, vec2 textureCoordinate)
{
	float minAlpha = 1.0;

	for (float x = -1.0; x <= 1; x += 1.0)
	{
		for (float y = -1.0; y <= 1; y += 1.0)
		{
			float alpha = Texel(texture, textureCoordinate + vec2(x, y) * scape_TexelSize).r;
			minAlpha = min(alpha, minAlpha);
		}
	}

	return minAlpha;
}

vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
{
	// float halfOutlineThickness = scape_OutlineThickness / 2.0;
	// vec2 halfTexelSize = scape_TexelSize / 2.0;

	// float referenceDepthSample = linearDepth(Texel(texture, textureCoordinate).r);
	// vec3 referenceNormal = Texel(texture, textureCoordinate).xyz;

	// float sumDepthSamples = 0.0;
	// float sumNormalDot = 0.0;
	// float numDepthSamples = 0.0;
	// float minDepthSample = referenceDepthSample;
	// float maxDepthSample = referenceDepthSample;
	// float minAlpha = 1.0;
	// for (float x = -halfOutlineThickness; x <= halfOutlineThickness; x += 1.0)
	// {
	// 	for (float y = -halfOutlineThickness; y <= halfOutlineThickness; y += 1.0)
	// 	{
	// 		vec2 otherDepthSampleTextureCoordinate = textureCoordinate + vec2(x, y) * scape_TexelSize;
	// 		float otherDepthSample = linearDepth(Texel(texture, otherDepthSampleTextureCoordinate).r);
	// 		vec3 otherNormal = Texel(scape_NormalTexture, otherDepthSampleTextureCoordinate).xyz;
	// 		float alpha = Texel(scape_AlphaMaskTexture, otherDepthSampleTextureCoordinate).r;

	// 		sumDepthSamples += otherDepthSample - referenceDepthSample;
	// 		numDepthSamples += 1.0;
	// 		sumNormalDot += dot(referenceNormal, otherNormal);
	// 		maxDepthSample = max(otherDepthSample, maxDepthSample);
	// 		minDepthSample = min(otherDepthSample, minDepthSample);
	// 		minAlpha = min(minAlpha, alpha);
	// 	}
	// }

	//alpha = Texel(scape_AlphaMaskTexture, textureCoordinate).r;

	float alpha = getMinAlpha(scape_AlphaMaskTexture, textureCoordinate);
	float depthSobel = getDepthSobel(texture, textureCoordinate);
	float normalSobel = getNormalSobel(scape_NormalTexture, textureCoordinate);
	//float sobel = max(getDepthSobel(texture, textureCoordinate), getNormalSobel(scape_NormalTexture, textureCoordinate));
	float d = max(
		step(0.2, normalSobel),
		step(0.2, depthSobel));

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
	// float normalDifference = abs(sumNormalDot / numDepthSamples);
	// float minDepthComparison = scape_MinDepth;
	// float maxDepthComparison = scape_MaxDepth;
	// if (normalDifference < scape_PlanarComparisonFactor && (maxDepthSample - referenceDepthSample) < scape_MaxPlanarDepth)
	// {
	// 	minDepthComparison = scape_MinPlanarDepth;
	// 	maxDepthComparison = scape_MaxPlanarDepth;
	// }

	// float difference = abs(sumDepthSamples / numDepthSamples);
	// float d = smoothstep(minDepthComparison, maxDepthComparison, difference);
	// d = 1.0 - d;
	//d = 1.0 - step(0.5, d);
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
	//return vec4(color.rgb * vec3(normalSobel, depthSobel, max(normalSobel, depthSobel)), alpha);
	return vec4(color.rgb * vec3(1.0 - d), 1.0);
}
