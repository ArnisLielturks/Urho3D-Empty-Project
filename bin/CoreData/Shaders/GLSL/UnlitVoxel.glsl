#include "Uniforms.glsl"
#include "Samplers.glsl"
#include "Transform.glsl"
#include "ScreenPos.glsl"
#include "Fog.glsl"

#ifdef WEBGL
precision mediump float;
#endif

varying vec2 vTexCoord;
varying vec4 vWorldPos;
varying vec4 vColor;
uniform float cSunlightIntensity;

void VS()
{
    mat4 modelMatrix = iModelMatrix;
    vec3 worldPos = GetWorldPos(modelMatrix);
    gl_Position = GetClipPos(worldPos);
    vTexCoord = GetTexCoord(iTexCoord);
    vWorldPos = vec4(worldPos, GetDepth(gl_Position));
    vColor = iColor;
}

void PS()
{
    // Get material diffuse albedo
    #ifdef DIFFMAP
        vec4 diffColor = cMatDiffColor * texture2D(sDiffMap, vTexCoord);
        diffColor.rgb = diffColor.rgb * vColor.r + diffColor.rgb * vColor.g * cSunlightIntensity;
//        diffColor = vColor;
        #ifdef ALPHAMASK
        #endif
    #else
        vec4 diffColor = cMatDiffColor;
    #endif

    if (diffColor.a < 0.5) {
        discard;
    }

//     Get fog factor
    #ifdef HEIGHTFOG
        float fogFactor = GetHeightFogFactor(vWorldPos.w, vWorldPos.y);
    #else
        float fogFactor = GetFogFactor(vWorldPos.w);
    #endif
//
//    #if defined(PREPASS)
//        // Fill light pre-pass G-Buffer
//        gl_FragData[0] = vec4(0.5, 0.5, 0.5, 1.0);
//        gl_FragData[1] = vec4(EncodeDepth(vWorldPos.w), 0.0);
//    #elif defined(DEFERRED)
//        gl_FragData[0] = vec4(GetFog(diffColor.rgb, fogFactor), diffColor.a);
//        gl_FragData[1] = vec4(0.0, 0.0, 0.0, 0.0);
//        gl_FragData[2] = vec4(0.5, 0.5, 0.5, 1.0);
//        gl_FragData[3] = vec4(EncodeDepth(vWorldPos.w), 0.0);
//    #else
        gl_FragColor = vec4(GetFog(diffColor.rgb, fogFactor), diffColor.a);
//    #endif
}
