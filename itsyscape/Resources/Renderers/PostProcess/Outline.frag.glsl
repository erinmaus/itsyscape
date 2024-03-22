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
	float offsetPositive = ceil(scape_OutlineThickness / 2.0);
	float offsetNegative = -floor(scape_OutlineThickness / 2.0);
	float left = scape_TexelSize.x * offsetNegative;
	float right = scape_TexelSize.x * offsetPositive;
	float top = scape_TexelSize.y * offsetNegative;
	float bottom = scape_TexelSize.y * offsetPositive;
	vec2 uv0 = textureCoordinate + vec2(left, top);
	vec2 uv1 = textureCoordinate + vec2(right, bottom);
	vec2 uv2 = textureCoordinate + vec2(right, top);
	vec2 uv3 = textureCoordinate + vec2(left, bottom);

	float d0 = linearDepth(Texel(texture, uv0).r);
	float d1 = linearDepth(Texel(texture, uv1).r);
	float d2 = linearDepth(Texel(texture, uv2).r);
	float d3 = linearDepth(Texel(texture, uv3).r);

	float d = length(vec2(d1 - d0, d3 - d2));
	d = smoothstep(scape_MinDepth, scape_MaxDepth, d);
	if (d < 1.0)
	{
		d = 0.0;
	}

	return vec4(color.rgb, d);
}
