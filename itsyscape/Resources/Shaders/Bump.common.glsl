void calculateBumpNormalFromHeight(
    float topLeft,
    float left,
    float bottomLeft,
    float top,
    float bottom,
    float topRight,
    float right,
    float bottomRight,
    float scale,
    out vec3 normal)
{
    float x = (topRight + 2.0 * right + bottomRight) - (topLeft + 2.0 * left + bottomLeft);
    float y = (bottomLeft + 2.0 * bottom + bottomRight) - (topLeft + 2.0 * top + topRight);

    normal = vec3(x, -y, scale);

    float l = length(normal);
    if (l > 0.0)
    {
        normal = normalize(normal);
    }
}

void calculateBumpNormal(Image heightmapTexture, vec2 textureCoordinate, vec2 texelSize, float scale, out vec3 normal, out float height)
{
    float topLeft = Texel(heightmapTexture, textureCoordinate + vec2(-1.0, -1.0) * texelSize).r;
    float left = Texel(heightmapTexture, textureCoordinate + vec2(-1.0, 0.0) * texelSize).r;
    float bottomLeft = Texel(heightmapTexture, textureCoordinate + vec2(-1.0, 1.0) * texelSize).r;
    float top = Texel(heightmapTexture, textureCoordinate + vec2(0.0, -1.0) * texelSize).r;
    float bottom = Texel(heightmapTexture, textureCoordinate + vec2(0.0, 1.0) * texelSize).r;
    float topRight = Texel(heightmapTexture, textureCoordinate + vec2(1.0, -1.0) * texelSize).r;
    float right = Texel(heightmapTexture, textureCoordinate + vec2(1.0, 0.0) * texelSize).r;
    float bottomRight = Texel(heightmapTexture, textureCoordinate + vec2(1.0, 1.0) * texelSize).r;
    float center = Texel(heightmapTexture, textureCoordinate).r;

    float x = (topRight + 2.0 * right + bottomRight) - (topLeft + 2.0 * left + bottomLeft);
    float y = (bottomLeft + 2.0 * bottom + bottomRight) - (topLeft + 2.0 * top + topRight);

    height = center;
    calculateBumpNormalFromHeight(topLeft, left, bottomLeft, top, bottom, topRight, right, bottomRight, scale, normal);
}
