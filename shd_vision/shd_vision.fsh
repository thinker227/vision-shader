#region Variable declarations
varying vec2 v_vTexcoord;
//varying vec4 v_vColour;			Unused due to shader being used as a mask

#region Uniforms
uniform float pixel_w;
uniform float pixel_h;

uniform float player_x;
uniform float player_y;

uniform float radius;
#endregion

vec2 player_pos = vec2(player_x * pixel_w, player_y * pixel_h);
#endregion







#region point_direction
float point_direction(vec2 point1, vec2 point2) {
	return degrees(atan(point2.y - point1.y, point2.x - point1.x));
}
#endregion



#region lengthdir
vec2 lengthdir(float dir) {
	vec2 point;
	point.x = (pixel_w * cos(radians(dir)));
	point.y = (pixel_h * sin(radians(dir)));
	return point;
}
#endregion



#region point_visible
bool point_visible(vec2 target_point) {
	float dir = point_direction(v_vTexcoord, target_point);
	vec2 increment = lengthdir(dir);
	vec2 current_point = v_vTexcoord;

	while (sign(target_point - v_vTexcoord) == sign(target_point - current_point)) {
		current_point += increment;
		if (texture2D(gm_BaseTexture, current_point).a > 0.0) return false;
	}

	return true;
}
#endregion



#region main
void main() {
	if (texture2D(gm_BaseTexture, v_vTexcoord).a > 0.0) discard;

	if (distance(v_vTexcoord, player_pos) > radius) {
		gl_FragColor = vec4(vec3(0.0), 1.0);
	}
	else {
		if (!point_visible(player_pos)) gl_FragColor = vec4(vec3(0.0), 1.0);
		else {
			float alpha = distance(v_vTexcoord, player_pos) / radius;
			gl_FragColor = vec4(vec3(0.0), alpha);
		}
	}
}
#endregion
