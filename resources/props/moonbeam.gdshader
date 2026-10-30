shader_type spatial;
render_mode unshaded, blend_add, cull_disabled, depth_draw_never, shadows_disabled;

uniform vec3 beam_color : source_color = vec3(0.55, 0.6, 0.8);
uniform float strength = 0.12;

void fragment() {
	float facing = pow(abs(dot(NORMAL, VIEW)), 3.0);
	float height = smoothstep(0.0, 0.35, UV.y) * (0.35 + 0.65 * (1.0 - UV.y));
	ALBEDO = beam_color * facing * height * strength;
}
