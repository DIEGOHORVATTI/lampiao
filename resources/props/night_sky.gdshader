shader_type spatial;
render_mode unshaded, blend_add, cull_front, depth_draw_never, shadows_disabled, fog_disabled;

uniform vec3 moon_direction = vec3(0.0, 0.4, -0.9);
uniform float moon_radius = 0.04;
uniform vec3 moon_color : source_color = vec3(1.0, 1.0, 0.96);
uniform float moon_energy = 2.2;
uniform vec3 halo_color : source_color = vec3(0.45, 0.5, 0.65);
uniform vec3 horizon_color : source_color = vec3(0.07, 0.08, 0.11);
uniform float star_density = 0.988;

varying vec3 sky_direction;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float stars(vec3 dir) {
	vec2 grid = vec2(atan(dir.x, dir.z), asin(dir.y)) * 120.0;
	vec2 cell = floor(grid);
	float pick = hash(cell);
	vec2 offset = vec2(hash(cell + 7.1), hash(cell + 3.3)) * 0.6 + 0.2;
	float dot_size = smoothstep(0.22, 0.0, length(fract(grid) - offset));
	return step(star_density, pick) * dot_size * (0.4 + 1.2 * hash(cell + 1.9)) * smoothstep(0.03, 0.3, dir.y);
}

void vertex() {
	sky_direction = normalize(VERTEX);
}

void fragment() {
	vec3 dir = normalize(sky_direction);
	vec3 moon = normalize(moon_direction);
	float angle = acos(clamp(dot(dir, moon), -1.0, 1.0));
	float disc = 1.0 - smoothstep(moon_radius * 0.94, moon_radius, angle);
	float halo = exp(-angle * 7.0) * 0.35 + exp(-angle * 22.0) * 0.4;
	float band = exp(-abs(dir.y) * 7.0) * (0.6 + 0.4 * max(dot(normalize(dir.xz + 0.0001), normalize(moon.xz + 0.0001)), 0.0));
	vec3 color = moon_color * moon_energy * disc;
	color += halo_color * halo * (1.0 - disc);
	color += horizon_color * band;
	color += vec3(0.8, 0.85, 1.0) * stars(dir) * (1.0 - disc) * (1.0 - smoothstep(0.0, 0.5, halo));
	ALBEDO = color;
}
