// Tutorial: https://blogs.love2d.org/content/let-it-glow-dynamically-adding-outlines-characters
// Don't really need this for what I am doing because I have a rectangular shape object

extern vec4 outline_color;
extern number border_thickness;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 texture_color = Texel(texture, texture_coords);



    number edge = step(border_thickness, texture_coords.x);
	+ step(texture_coords.x, 1.0 - border_thickness);
	+ step(1.0 - border_thickness, texture_coords.y);
	+ step(border_thickness, texture_coords.y);

    if (edge > 0.0) {
	return outline_color;
    }
    return texture_color;
}
