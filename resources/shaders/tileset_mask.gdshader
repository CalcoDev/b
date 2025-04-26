shader_type canvas_item;

uniform sampler2D inner_overlay_tex: repeat_enable, filter_nearest;
uniform float inner_scale = 0.015625;

uniform sampler2D outer_overlay_tex: repeat_enable, filter_nearest;
uniform float outer_scale = 0.015625;

varying vec2 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float inner_mix = floor(COLOR.r) * float(length(COLOR.gba) <= 1.0);
	float outer_mix = floor(COLOR.b) * float(length(COLOR.rga) <= 1.0);

	// sample the overlay_tex using worldPos
	vec4 inner_overlay_col = texture(inner_overlay_tex, world_position * inner_scale);
	vec4 outer_overlay_col = texture(outer_overlay_tex, world_position * outer_scale);

	// combine original color and overlay color together
	vec4 inner_c = mix(COLOR, inner_overlay_col, inner_mix);
	vec4 outer_c = mix(inner_c, outer_overlay_col, outer_mix);
	COLOR = outer_c;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
