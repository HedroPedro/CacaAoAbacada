shader_type canvas_item;

// Textura B (destino da transição)
uniform sampler2D texture_b : source_color, hint_default_white;

// Progresso da transição: 0.0 = textura A pura, 1.0 = textura B pura
uniform float transition_progress : hint_range(0.0, 1.0) = 0.0;

// Suavidade da borda na transição (wipe/radial)
uniform float edge_softness : hint_range(0.0, 0.5) = 0.05;

void fragment() {
    vec4 color_a = texture(TEXTURE, UV);
    
    // Se não houver textura A (nó sem textura), usa branco
    // O Godot retorna branco puro quando não há textura atribuída
    // mas garantimos isso verificando o COLOR do nó pai
    color_a *= COLOR; // multiplica pelo modulate do nó
    
    vec4 color_b = texture(texture_b, UV);
    
    float mask = 0.0;

    mask = transition_progress;
    // Mistura as duas texturas com base no mask
    COLOR = mix(color_a, color_b, mask);
}