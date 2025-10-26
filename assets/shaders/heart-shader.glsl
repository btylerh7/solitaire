
vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen_coords)
{
    vec4 pixel = Texel(texture, uv);
    vec4 newColor = vec4(1, 0, 0, 1);

    if (pixel.r > 0.5 && pixel.g < 0.5 && pixel.b < 0.5) {
	return newColor;
    }
    return pixel;
}
