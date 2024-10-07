shader_type canvas_item;

uniform vec4 modulate_color = vec4(1.0, 1.0, 1.0, 1.0); // Default color (white, no tint)

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV); // Sample the texture
    COLOR = tex_color * modulate_color; // Multiply the texture by the tint color
}