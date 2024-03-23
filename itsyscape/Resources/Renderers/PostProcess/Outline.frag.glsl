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
	float halfOutlineThickness = ceil(scape_OutlineThickness / 2.0);
	vec2 halfTexelSize = scape_TexelSize / 2.0;

	float referenceDepthSample = linearDepth(Texel(texture, textureCoordinate).r);

	float depthSum = 0.0;
	float numDepthSamples = 0.0;
	for (float x = -halfOutlineThickness; x <= halfOutlineThickness; x += 1.0)
	{
		for (float y = -halfOutlineThickness; y <= halfOutlineThickness; y += 1.0)
		{
			// if ((x == 0.0 && y == 0.0) || (scape_OutlineThickness * scape_OutlineThickness) < (x * x + y * y))
			// {
			// 	continue;
			// }

			numDepthSamples += 1.0;

			vec2 localTextureCoordinate = textureCoordinate + vec2(x, y) * scape_TexelSize;
			float localDepthSample = linearDepth(Texel(texture, localTextureCoordinate).r);

			depthSum += localDepthSample - referenceDepthSample;

			// vec2 uv0 = localTextureCoordinate + vec2(-halfTexelSize.x, -halfTexelSize.y);
			// vec2 uv1 = localTextureCoordinate + vec2(halfTexelSize.x, halfTexelSize.y);
			// vec2 uv2 = localTextureCoordinate + vec2(halfTexelSize.x, -halfTexelSize.y);
			// vec2 uv3 = localTextureCoordinate + vec2(-halfTexelSize.x, halfTexelSize.y);

			// float d0 = linearDepth(Texel(texture, uv0).r);
			// float d1 = linearDepth(Texel(texture, uv1).r);
			// float d2 = linearDepth(Texel(texture, uv2).r);
			// float d3 = linearDepth(Texel(texture, uv3).r);

			// float d = length(vec2(d1 - d0, d3 - d2));
			// depthSum += d;
		}
	}

	float depthRange = scape_Far - scape_Near;
	//float minDepth = scape_MinDepth / depthRange;
	//float maxDepth = scape_MaxDepth / depthRange;

	float d = depthSum / numDepthSamples * depthRange;
	//d = smoothstep(scape_MinDepth, scape_MaxDepth, d) * depthRange;
	//d = smoothstep(minDepth, maxDepth, d);

	if (d > scape_MaxDepth)
	{
		d = 0.0;
	}
	else
	{
		d = 1.0;
	}

	return vec4(color.rgb * d, 1.0);
}
