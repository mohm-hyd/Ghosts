shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
//uniform bool is_grayscale = true;
uniform float fade_amount : hint_range(0.0, 1.0) = 0.0; 

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    
 
    float luminance = dot(screen_color.rgb, vec3(0.299, 0.587, 0.114));
    vec4 grayscale_color = vec4(vec3(luminance), screen_color.a);
    
 
    COLOR = mix(screen_color, grayscale_color, fade_amount);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
