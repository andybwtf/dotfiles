void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // 1. Softened Sampling
    vec4 baseColor = texture(iChannel0, uv);
    vec4 glow = texture(iChannel0, uv + vec2(0.0002, 0.0002)) * 0.5 + 
                 texture(iChannel0, uv - vec2(0.0002, 0.0002)) * 0.5;
    
    vec4 color = baseColor + (glow * 0.4);

    // 2. Horizontal Scanlines
    float scanline = sin(uv.y * iResolution.y * 2.0) * 0.35 + 0.65;
    color.rgb *= scanline;

    // 3. Vertical Texture
    float vMask = 0.96 + 0.04 * sin(fragCoord.x * 0.8);
    color.rgb *= vMask;

    // 4. Chromatic Aberration
    float offset = 0.0003;
    color.r = texture(iChannel0, uv + vec2(offset, 0.0)).r;
    color.b = texture(iChannel0, uv - vec2(offset, 0.0)).b;

    // 5. Final Output Adjustments
    color.rgb *= 1.4;
    fragColor = vec4(color.rgb, 1.0);
}
