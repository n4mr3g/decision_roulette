shader_type canvas_item;

uniform float rotation_degrees : hint_range(0.0, 360.0);  // Rotation angle in degrees

void fragment() {
    vec2 center = vec2(0.5, 0.5);  // Center of the sprite in normalized coordinates
    vec2 uv = FRAGCOORD.xy / TEXTURE_PIXEL_SIZE;  // Convert fragment coordinates to UV

    uv -= center;  // Translate UV coordinates to the center of the sprite

    // Convert degrees to radians
    float angle = radians(rotation_degrees);

    // Calculate the sine and cosine of the angle
    float cos_angle = cos(angle);
    float sin_angle = sin(angle);

    // Apply the rotation manually
    vec2 rotated_uv = vec2(
        uv.x * cos_angle - uv.y * sin_angle,
        uv.x * sin_angle + uv.y * cos_angle
    );

    uv = rotated_uv + center;  // Translate UV coordinates back

    // Sample the texture with the rotated UV coordinates
    COLOR = texture(TEXTURE, uv);
}
