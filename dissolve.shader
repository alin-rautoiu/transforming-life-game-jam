shader_type canvas_item;

// Gonkee's water shader for Godot 3 - full tutorial https://youtu.be/uhMAHpV_cDg
// If you use this shader, I would prefer if you gave credit to me and my channel

uniform vec4 green_tint : hint_color;
uniform vec2 sprite_scale;
uniform float disolve_proc = 100;

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(12.9898, 78.233)))* 43758.5453123);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);

	// 4 corners of a rectangle surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

void fragment(){
	vec2 noisecoord1 = UV * sprite_scale;
	vec2 noisecoord2 = UV * sprite_scale + 4.0;
	
	vec2 motion1 = vec2(TIME * 0.3, TIME * -0.4);
	vec2 motion2 = vec2(TIME * 0.1, TIME * 0.5);
	
	vec2 distort1 = vec2(noise(noisecoord1 * motion1), noise(noisecoord2 * motion2)) - vec2(0.5);
	vec2 distort2 = vec2(noise(noisecoord1 * motion2), noise(noisecoord2 * motion1)) - vec2(0.5);
	vec2 distort_sum = (distort1 + distort2) / 100.0 / disolve_proc;
	
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV + distort_sum);
//	color.rgb = mix(color.rgb, vec3(0.5), 1.4);
//	color = mix(color, green_tint, 0.1);
	
	COLOR = color;
}