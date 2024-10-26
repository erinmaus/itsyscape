vec2 encodeGBufferNormal(vec3 normal)
{
    float l = length(normal.xy);
    float d = step(l, 0.0);
    return (normal.xy / vec2(l + d)) * vec2(sqrt((-normal.z + 1.0) / 2.0));
}

vec3 decodeGBufferNormal(vec2 encodedNormal)
{
    float l = dot(vec3(encodedNormal, 1.0), vec3(-encodedNormal, 1.0));
    return vec3(encodedNormal * vec2(sqrt(l)), l) * vec3(2.0) - vec3(vec2(0.0), 1.0);
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
