shader_type canvas_item;

uniform sampler2D noise_texture;
uniform sampler2D dissolve_noise_texture;
uniform vec4 colour_1:source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 colour_2:source_color = vec4(34.0, 32.0, 12.0, 1.0);
uniform float tilling_factor:hint_range(1.0, 10.0) = 1.0;
uniform float move_speed:hint_range(0.1, 5.0) = 0.1;
uniform float subtract_speed:hint_range(0.1, 5.0) = 0.1;

void fragment() {
	//Calculate UV coordinates and apply tilling
	vec2 uv = UV * tilling_factor;
	
	//Offset UV coordinates to move textures up or down
	uv.y += TIME * move_speed;

	//Adjust uv coordinates for seamless tiling
	uv = fract(uv);
	
	//Sample the noise texture using the UV modified coordinates
	float noise_value = texture(noise_texture, uv).r;
	
	//Sample the dissolve noise texture using the UV modified coordinates
	float dissolve_value = texture(dissolve_noise_texture, uv).r;
	
	//Calculate the time dependend factor for subtraction
	float subtraction_factor = sin(TIME * subtract_speed);
	
	//Subtract the value of the dissolve noise texture from the noise texture
	float final_value = noise_value - (dissolve_value * subtraction_factor);
	
	//Interpolate between the two colors based on final value
	vec4 final_color = mix(colour_1, colour_2, final_value);
	
	//Output the final color
	COLOR = final_color;
}
