void calculateBumpNormal(Image heightmapTexture, vec2 textureCoordinate, vec2 texelSize, float scale, out vec3 normal, out float height)
{
    float center = texture(heightmapTexture, textureCoordinate).r;
    float left = Texel(heightmapTexture, textureCoordinate + vec2(-1.0, 0.0) * texelSize).r;
    float right = Texel(heightmapTexture, textureCoordinate + vec2(1.0, 0.0) * texelSize).r;
    float top = Texel(heightmapTexture, textureCoordinate + vec2(0.0, -1.0) * texelSize).r;
    float bottom = Texel(heightmapTexture, textureCoordinate + vec2(0.0, 1.0) * texelSize).r;

    vec3 a = normalize(vec3(2.0, (left - right) * scale, 0.0));
    vec3 b = normalize(vec3(0.0, (top - bottom) * scale, 2.0));

    normal = normalize(cross(a, b));
    height = center;
}
