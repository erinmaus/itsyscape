vec2 encodeGBufferNormal(vec3 normal)
{
    float f = sqrt(normal.z * 8.0 + 8.0);
    return normal.xy / vec2(f) + vec2(0.5);
}

vec3 decodeGBufferNormal(vec2 encodedNormal)
{
    vec2 transformedEncodedNormal = encodedNormal * vec2(4.0) - vec2(2.0);
    float f = dot(transformedEncodedNormal, transformedEncodedNormal);
    float g = sqrt(1.0 - f / 4.0);

    return vec3(encodedNormal * vec2(g), 1.0 - f / 2.0);
}

vec3 worldPositionFromGBufferDepth(float depth, vec2 textureCoordinate, mat4 inverseProjectionMatrix, mat4 inverseViewMatrix)
{
    float z = depth * 2.0 - 1.0;

    vec4 clipSpacePosition = vec4(textureCoordinate * vec2(2.0) - vec2(1.0), z, 1.0);
    vec4 viewSpacePosition = inverseProjectionMatrix * clipSpacePosition;
    viewSpacePosition /= vec4(viewSpacePosition.w);

    vec4 worldSpacePosiiton = inverseViewMatrix * viewSpacePosition;
    return worldSpacePosiiton.xyz;
}
