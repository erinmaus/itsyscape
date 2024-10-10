uniform Image scape_ColorTexture;
uniform vec2 scape_TexelSize;

float sampleAlpha(Image image, vec2 textureCoordinate)
{
    float alpha = 1.0;
    for (float x = -1.0; x <= 1.0; x += 1.0)
    {
        for (float y = -1.0; y <= 1.0; y += 1.0)
        {
            alpha = min(alpha, Texel(image, textureCoordinate + vec2(x, y) * scape_TexelSize).z);
            // alpha *= Texel(image, textureCoordinate + vec2(x, y) * scape_TexelSize).a;
        }
    }

    return alpha;
}

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
    vec3 remappedTextureCoordinate = Texel(image, textureCoordinate).rga;
    float alpha = sampleAlpha(image, textureCoordinate);

    vec4 colorSample = Texel(scape_ColorTexture, remappedTextureCoordinate.xy);

    return vec4(colorSample.rgb, colorSample.a * alpha) * color;
}
