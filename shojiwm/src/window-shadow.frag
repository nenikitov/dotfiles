uniform vec3 shadow_color;
uniform float shadow_opacity;
uniform vec2 shadow_offset_px;

vec4 shader_main(vec2 uv, vec2 rect_size) {
    vec2 sample_uv = uv - (shadow_offset_px / max(rect_size, vec2(1.0)));
    vec4 source = texture2D(tex, sample_uv);
    float alpha = source.a * shadow_opacity;
    return vec4(source.rgb * shadow_color * alpha, alpha);
}
