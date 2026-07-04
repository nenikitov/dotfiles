uniform sampler2D layer_mask;
uniform float opacity_threshold;
uniform float mask_feather;

vec4 shader_main(vec2 uv, vec2 rect_size) {
    vec4 blurred = texture2D(tex, uv);
    float layer_alpha = texture2D(layer_mask, uv).a;
    float mask = smoothstep(
        opacity_threshold - mask_feather,
        opacity_threshold + mask_feather,
        layer_alpha
    );
    return blurred * mask;
}
