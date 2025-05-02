shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec3 u_line_colour: source_color = vec3(1.0);
uniform int u_line_thickness: hint_range(0, 10) = 1;

void fragment() {
	vec2 size = SCREEN_PIXEL_SIZE * float(u_line_thickness);
	float line_alpha = 0.0;
	for (float i = -size.x; i <= size.x; i += SCREEN_PIXEL_SIZE.x) {
		for (float j = -size.y; j <= size.y; j += SCREEN_PIXEL_SIZE.y) {
			line_alpha += texture(screen_texture, SCREEN_UV + vec2(i, j)).a;
		}
	}
	vec4 colour = texture(screen_texture, SCREEN_UV);
	vec4 outline = vec4(u_line_colour, min(line_alpha, 1.0));
	COLOR *= mix(outline, colour, colour.a);
}