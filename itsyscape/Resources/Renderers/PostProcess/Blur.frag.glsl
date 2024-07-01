uniform vec2 scape_TexelSize;
uniform vec2 scape_Direction;

vec4 blur(Image image, vec2 textureCoordinate, vec2 direction) {
	vec4 color = vec4(0.0);
	vec2 off1 = vec2(1.411764705882353) * direction;
	vec2 off2 = vec2(3.2941176470588234) * direction;
	vec2 off3 = vec2(5.176470588235294) * direction;
	color += Texel(image, textureCoordinate) * 0.1964825501511404;
	color += Texel(image, textureCoordinate + (off1 * scape_TexelSize)) * 0.2969069646728344;
	color += Texel(image, textureCoordinate - (off1 * scape_TexelSize)) * 0.2969069646728344;
	color += Texel(image, textureCoordinate + (off2 * scape_TexelSize)) * 0.09447039785044732;
	color += Texel(image, textureCoordinate - (off2 * scape_TexelSize)) * 0.09447039785044732;
	color += Texel(image, textureCoordinate + (off3 * scape_TexelSize)) * 0.010381362401148057;
	color += Texel(image, textureCoordinate - (off3 * scape_TexelSize)) * 0.010381362401148057;
	return color;
}

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	return blur(image, textureCoordinate, scape_Direction);
}
