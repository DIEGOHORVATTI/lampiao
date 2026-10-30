shader_type canvas_item;

uniform float blood : hint_range(0.0, 1.0) = 0.0;
uniform float hunger : hint_range(0.0, 1.0) = 0.0;
uniform float hit : hint_range(0.0, 1.0) = 0.0;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x), mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

void fragment() {
	vec2 centered = (UV - 0.5) * vec2(1.7, 1.0);
	float r = length(centered);
	float n = noise(UV * 7.0) * 0.6 + noise(UV * 19.0) * 0.4;
	float edge = smoothstep(0.45, 0.95, r);

	float bloodiness = clamp(blood * 0.85 + hit * 0.6, 0.0, 1.0);
	float stain = smoothstep(1.05 - bloodiness * 0.7, 1.1 - bloodiness * 0.7, r + n * 0.35) * smoothstep(0.0, 0.15, bloodiness);

	float pulse = 0.55 + 0.45 * sin(TIME * (2.0 + hunger * 4.0));
	float vein_lines = 1.0 - smoothstep(0.0, 0.06, abs(noise(UV * vec2(9.0, 5.0) + TIME * 0.05) - 0.5));
	float veins = vein_lines * smoothstep(0.35, 0.9, r) * smoothstep(0.35, 1.0, hunger) * pulse;

	vec3 color = mix(vec3(0.02, 0.0, 0.0), vec3(0.22, 0.0, 0.01), stain * 0.5 + veins * 0.6);
	float alpha = edge * 0.45 + stain * 0.92 + veins * 0.7;
	COLOR = vec4(color, clamp(alpha, 0.0, 0.96));
}
