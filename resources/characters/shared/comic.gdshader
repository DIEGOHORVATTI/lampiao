shader_type spatial;
render_mode cull_disabled, specular_disabled;

uniform sampler2D albedo_texture : source_color, filter_linear_mipmap;
uniform vec4 tint : source_color = vec4(1.0);
uniform float threshold : hint_range(-1.0, 1.0) = 0.15;
uniform float softness : hint_range(0.0, 0.5) = 0.08;
uniform float shadow_light : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	ALBEDO = texture(albedo_texture, UV).rgb * tint.rgb;
	ROUGHNESS = 1.0;
}

void light() {
	float ndl = dot(NORMAL, LIGHT);
	float lit = smoothstep(threshold - softness, threshold + softness, ndl);
	DIFFUSE_LIGHT += LIGHT_COLOR / PI * ATTENUATION * mix(shadow_light, 1.0, lit);
}
