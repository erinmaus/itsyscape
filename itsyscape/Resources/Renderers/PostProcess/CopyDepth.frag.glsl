vec4 effect(
	vec4 color,
	Image image,
	vec2 textureCoordinate,
	vec2 screenCoordinate)
{
	gl_FragDepth = Texel(image, textureCoordinate).r;
    return vec4(0.0);
}
