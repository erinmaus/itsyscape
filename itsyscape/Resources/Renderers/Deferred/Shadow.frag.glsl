#define SCAPE_MAX_CASCADES 8

uniform ArrayImage scape_ShadowMap;
uniform Image scape_PositionTexture;
uniform vec2 scape_TexelSize;
uniform mat4 scape_CascadeLightSpaceMatrices[SCAPE_MAX_CASCADES];
uniform float scape_CascadeNearPlanes[SCAPE_MAX_CASCADES];
uniform int scape_NumCascades;
uniform float scape_ShadowAlpha;

#define SCAPE_PCF_BLUR_START -1
#define SCAPE_PCF_BLUR_END 1

vec2 getTexelDepthDeltas(vec3 shadowX, vec3 shadowY)
{
    mat2 screenToShadow = mat2(shadowX.xy, shadowY.xy);
    float d = determinant(screenToShadow);
    float inverseD = 1.0f / d;

    mat2 shadowToScreen = mat2(
        screenToShadow[1][1] * inverseD, screenToShadow[0][1] * -inverseD,
        screenToShadow[1][0] * -inverseD, screenToShadow[1][1] * inverseD);

    vec2 yTexelLocation = vec2(scape_TexelSize.x, 0.0f);
    vec2 xTexelLocation = vec2(0.0f, scape_TexelSize.y);

    vec2 xRatio = shadowToScreen * xTexelLocation;
    vec2 yRatio = shadowToScreen * yTexelLocation;

    return vec2(
        xRatio.x * shadowX.z + xRatio.y * shadowX.z,
        yRatio.x * shadowY.z + yRatio.y * shadowY.z);
}

float calculatePCF(int cascadeIndex, vec3 position, vec2 delta)
{
    float layer = float(cascadeIndex);

    float result = 0.0f;
    float numSamples = 0.0f;
    for (int i = SCAPE_PCF_BLUR_START; i <= SCAPE_PCF_BLUR_END; ++i)
    {
        for (int j = SCAPE_PCF_BLUR_START; j <= SCAPE_PCF_BLUR_END; ++j)
        {
            float comparison = position.z;
            float x = float(i);
            float y = float(j);

            comparison += delta.x * x + delta.y * y;
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

    int cascadeIndex = 0;
    for (int i = 0; i < scape_NumCascades; ++i)
    {
        float near = scape_CascadeNearPlanes[i];
        if (worldPosition.z >= near)
        {
            cascadeIndex = i;
        }
        else
        {
            break;
        }
    }

    vec4 lightPosition = scape_CascadeLightSpaceMatrices[cascadeIndex] * vec4(worldPosition, 1.0);
    vec3 projectedLightPosition = lightPosition.xyz / lightPosition.w;
    projectedLightPosition = projectedLightPosition * vec3(2.0f) - vec3(1.0f);

    vec2 delta = getTexelDepthDeltas(dFdx(projectedLightPosition), dFdy(projectedLightPosition));
    float shadow = calculatePCF(cascadeIndex, projectedLightPosition, delta);

    return vec4(vec3(0.0f), delta * scape_ShadowAlpha);
}
