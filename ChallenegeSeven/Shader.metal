//
//  Shader.metal
//  ChallenegeSeven
//
//  Created by Ivan Pryhara on 18/03/2024.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] float2 relativeWave(float2 position, float2 size, float time, float speed, float smoothing, float strength) {

    half2 uv = half2(position / size);
    half offset = sin(time * speed + position.y / smoothing);
    position.x += offset * uv.y * strength;

    return position;
 }
