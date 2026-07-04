vec4 shader_main(vec2 uv, vec2 rect_size) {
    vec4 source = texture2D(tex, uv);
    float gray = dot(source.rgb, vec3(0.299, 0.587, 0.114));
    return vec4(vec3(gray), source.a);
}
