shader_type spatial;
render_mode cull_disabled;

uniform sampler2D wall_texture : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D floor_texture : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D outdoor_texture : source_color, filter_linear_mipmap, repeat_enable;
uniform float wall_scale = 0.22;
uniform float floor_scale = 0.3;
uniform float outdoor_scale = 0.18;
uniform float mouth_z = -8.0;
uniform vec3 tint = vec3(0.82, 0.74, 0.66);

varying vec3 world_pos;
varying vec3 world_normal;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

void fragment() {
	vec3 weights = pow(abs(world_normal), vec3(4.0));
	weights /= weights.x + weights.y + weights.z;
	vec3 side_x = texture(wall_texture, world_pos.zy * wall_scale).rgb;
	vec3 side_z = texture(wall_texture, world_pos.xy * wall_scale).rgb;
	vec3 top_wall = texture(wall_texture, world_pos.xz * wall_scale).rgb;
	vec3 cave_ground = texture(floor_texture, world_pos.xz * floor_scale).rgb;
	vec3 open_ground = texture(outdoor_texture, world_pos.xz * outdoor_scale).rgb;
	float outdoor = smoothstep(mouth_z + 1.0, mouth_z - 2.0, world_pos.z);
	float flat_ground = smoothstep(0.55, 0.8, world_normal.y);
	vec3 ground = mix(cave_ground, open_ground, outdoor);
	vec3 top = mix(top_wall, ground, flat_ground);
	ALBEDO = (side_x * weights.x + top * weights.y + side_z * weights.z) * tint;
	ROUGHNESS = 0.95;
}
