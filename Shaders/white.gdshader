shader_type canvas_item;

uniform vec3 focus_color : source_color = vec3(0.95);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
    COLOR = vec4(focus_color, color.a);
}