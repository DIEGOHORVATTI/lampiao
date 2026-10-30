shader_type spatial;
render_mode unshaded, cull_front, shadows_disabled;

uniform vec4 ink_color : source_color = vec4(0.06, 0.04, 0.035, 1.0);
uniform float width = 0.004;
uniform float max_scale = 3.0;

void vertex() {
	float dist = -(MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).z;
	VERTEX += NORMAL * width * clamp(dist * 0.35, 1.0, max_scale);
}

void fragment() {
	ALBEDO = ink_color.rgb;
}
