uniform Image scape_ClearColorTexture;
uniform Image scape_BlurColorTexture;
uniform Image scape_ReflectionPropertiesTexture;

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
    float roughness = Texel(scape_ReflectionPropertiesTexture, textureCoordinate).z;
    vec4 clearColorSample = Texel(scape_ClearColorTexture, textureCoordinate);
    vec4 blurColorSample = Texel(scape_BlurColorTexture, textureCoordinate);
    
    vec3 mixedColorSample = mix(clearColorSample.rgb, blurColorSample.rgb, roughness);
    return vec4(mixedColorSample, max(clearColorSample.a, blurColorSample.a));
}
