// Tutorial: https://blogs.love2d.org/content/let-it-glow-dynamically-adding-outlines-characters
// Don't really need this for what I am doing because I have a rectangular shape object

extern vec4 outline_color;
extern number border_thickness;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 texture_color = Texel(texture, texture_coords);

    // Distance from different corners
    number left = texture_coords.x;
    number right = 1.0 - texture_coords.x;
    number top = texture_coords.y;
    number bottom = 1.0 - texture_coords.y;

    number edge = step(left, border_thickness);
	// + step(right, border_thickness)
	// + step(top, border_thickness)
	// + step(bottom, border_thickness);

    if (edge > 0.0) {
	return outline_color;
    }
    return texture_color;
}
