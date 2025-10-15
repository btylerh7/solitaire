extern number border_thickness;
extern vec4 outline_color;

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen_coords)
{
    vec4 texColor = Texel(texture, uv);

    // Find the distance to the nearest edge (0 at edge → 0.5 in middle)
    number dist_to_edge = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));

    // If within border_thickness, draw outline color
    number is_border = 1.0 - step(border_thickness, dist_to_edge);

    // Mix outline over texture
    vec4 finalColor = mix(texColor, outline_color, is_border);

    return finalColor * color;
}

