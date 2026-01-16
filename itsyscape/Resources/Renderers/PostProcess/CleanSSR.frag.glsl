uniform vec2 scape_TexelSize;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	vec4 center = Texel(image, textureCoordinate);
	vec4 top = Texel(image, textureCoordinate - vec2(0.0, scape_TexelSize.y));
	vec4 bottom = Texel(image, textureCoordinate + vec2(0.0, scape_TexelSize.y));
	vec4 left = Texel(image, textureCoordinate - vec2(scape_TexelSize.x, 0.0));
	vec4 right = Texel(image, textureCoordinate + vec2(scape_TexelSize.x, 0.0));
	float alpha = min(min(min(min(center.a, top.a), bottom.a), left.a), right.a);
	return vec4(center.rgb, alpha);
}
