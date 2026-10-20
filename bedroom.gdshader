shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

render_mode unshaded;

uniform float fade_amount : hint_range(0.0, 1.0) = 0.0;

uniform sampler2D screen_texture :
    hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 color = textureLod(screen_texture, SCREEN_UV, 0.0);

    if (color.a > 0.0001) {
        color.rgb /= color.a;
    }

    float luminance = dot(
        color.rgb,
        vec3(0.299, 0.587, 0.114)
    );

    vec3 grayscale = vec3(luminance);

    color.rgb = mix(color.rgb, grayscale, fade_amount);

    COLOR *= color;
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
