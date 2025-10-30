vec4 effect(vec4 color, Image image, vec2 textureCoordinates, vec2 screenCoordinates)
{
    vec4 textureSample = Texel(image, textureCoordinates);
    return textureSample * color;
}
