shader_type canvas_item;

uniform vec4 border_color : source_color = vec4(1,1,1,1);

void fragment() {
	vec2 uv = UV - 0.5;
	float dist = distance(uv, vec2(0,0));
	if (dist > .49){
		COLOR.a = 0.;
		if (dist < 0.5){
			COLOR.rgba = border_color;
		}
	}
}