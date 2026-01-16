uniform Image scape_ColorTexture;
uniform vec2 scape_TexelSize;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
    vec3 remappedTextureCoordinate = Texel(image, textureCoordinate).xyw;
    vec4 colorSample = Texel(scape_ColorTexture, remappedTextureCoordinate.xy);
    return vec4(colorSample.rgb, remappedTextureCoordinate.z) * color;
}
