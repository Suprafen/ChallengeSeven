//
//  Shader.metal
//  ChallenegeSeven
//
//  Created by Ivan Pryhara on 18/03/2024.
//

#include <metal_stdlib>
using namespace metal;

[[stitchable]] float2 flagWave(float2 position, float time, float2 s) {
    position.y = sin(time * 5 + position.y / 20) * 5;
    return position;
}
