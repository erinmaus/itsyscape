#define SCAPE_MAX_CASCADES 8

uniform ArrayImage scape_ShadowMap;
uniform Image scape_PositionTexture;
uniform Image scape_NormalSpecularTexture;
uniform vec2 scape_TexelSize;
uniform vec3 scape_LightDirection;
uniform mat4 scape_CascadeLightSpaceMatrices[SCAPE_MAX_CASCADES];
uniform vec2 scape_CascadePlanes[SCAPE_MAX_CASCADES];
uniform int scape_NumCascades;
uniform float scape_ShadowAlpha;
uniform mat4 scape_View;

#define SCAPE_PCF_BLUR_START -1
#define SCAPE_PCF_BLUR_END 1

float calculatePCF(int cascadeIndex, vec3 position, float bias)
{
    float layer = float(cascadeIndex);

    float result = 0.0f;
    float numSamples = 0.0f;
    for (int i = SCAPE_PCF_BLUR_START; i <= SCAPE_PCF_BLUR_END; ++i)
    {
        for (int j = SCAPE_PCF_BLUR_START; j <= SCAPE_PCF_BLUR_END; ++j)
        {
            float comparison = position.z - bias;
            float x = float(i);
            float y = float(j);

            float target = Texel(scape_ShadowMap, vec3(position.x + x * scape_TexelSize.x, position.y + y * scape_TexelSize.y, layer)).r;

            result += step(target, comparison);
            numSamples += 1.0f;
        }
    }

    return result /= numSamples;
}

vec4 effect(
    vec4 color,
    Image depth,
    vec2 textureCoordinate,
    vec2 screenCoordinate)
{
    vec3 worldPosition = Texel(scape_PositionTexture, textureCoordinate).xyz;
    vec3 viewPosition = (scape_View * vec4(worldPosition, 1.0)).xyz;

    int cascadeIndex = 0;
    for (int i = 0; i < scape_NumCascades; ++i)
    {
        float near = scape_CascadePlanes[i].x;
        if (viewPosition.z >= near)
        {
            cascadeIndex = i;
        }
    }

    vec3 normal = normalize(Texel(scape_NormalSpecularTexture, textureCoordinate).xyz);
    float bias = max(0.05 * (1.0 - dot(normal, scape_LightDirection)), 0.05) / (scape_CascadePlanes[cascadeIndex].y * 0.25f);

    vec4 lightPosition = scape_CascadeLightSpaceMatrices[cascadeIndex] * vec4(worldPosition, 1.0);
    vec3 projectedLightPosition = lightPosition.xyz / lightPosition.w;
    projectedLightPosition = (projectedLightPosition + vec3(1.0f)) / vec3(2.0f);

    if (projectedLightPosition.z < 0.0 || projectedLightPosition.z > 1.0)
    {
        return vec4(0.0);
    }

    float shadow = calculatePCF(cascadeIndex, projectedLightPosition, bias);
    return vec4(vec3(0.0), shadow * scape_ShadowAlpha);
}
