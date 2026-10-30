shader_type spatial;
render_mode cull_disabled, specular_disabled;

uniform sampler2D albedo_texture : source_color, filter_linear_mipmap;
uniform vec4 tint : source_color = vec4(1.0);
uniform float threshold : hint_range(-1.0, 1.0) = 0.25;
uniform float band : hint_range(0.0, 1.0) = 0.45;
uniform float dot_size : hint_range(1.0, 16.0) = 4.0;
uniform float shadow_light : hint_range(0.0, 1.0) = 0.12;

void fragment() {
	ALBEDO = texture(albedo_texture, UV).rgb * tint.rgb;
	ROUGHNESS = 1.0;
}

void light() {
	float ndl = dot(NORMAL, LIGHT) * ATTENUATION;
	float tone = clamp((ndl - threshold + band) / band, 0.0, 1.0);
	vec2 cell = mat2(vec2(0.7071, -0.7071), vec2(0.7071, 0.7071)) * FRAGCOORD.xy / dot_size;
	float dist = length(fract(cell) - 0.5);
	float radius = (1.0 - tone) * 0.75;
	float ink = 1.0 - smoothstep(radius - 0.06, radius + 0.06, dist);
	float lit = step(1.0, tone + 0.001) + (1.0 - step(1.0, tone + 0.001)) * step(0.001, tone) * (1.0 - ink);
	DIFFUSE_LIGHT += LIGHT_COLOR / PI * mix(shadow_light, 1.0, lit);
}
