shader_type canvas_item;

uniform float speed: hint_range(0,10) = 1.0;
uniform float strength: hint_range(0,100) = 1.0;
uniform float frequency: hint_range(0,100) = 1.0;

void fragment(){
	float PI = 3.1415926;
	float time_speed = TIME * speed;
	float wave_count = frequency * PI;
	float displace_x = sin(time_speed + SCREEN_UV.y  * wave_count);
	float displace_y = sin(time_speed + SCREEN_UV.x * wave_count);
	
	vec2 offset = vec2(displace_x, displace_y);
	
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV + (offset * SCREEN_PIXEL_SIZE * strength));
	COLOR = color;
}