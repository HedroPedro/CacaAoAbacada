extends Node
@onready var bar := $Container/BoxContainer/Bar 
@onready var mute_btn := $Container/BoxContainer/Bar/Mute
@onready var with_sound := load("res://images/menu/volume.png")
@onready var no_sound := load("res://images/menu/muted.png")
@onready var default_bar := load("res://images/menu/slider_vol.png")
@onready var bar_sound_focus := load("res://images/menu/menu_fixo_som.png")
@onready var bar_exit_focus := load("res://images/menu/menu_fixo_porta.png")
var has_sound = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bar.mouse_entered.connect(reset_bar)
	mute_btn.mouse_entered.connect(reset_bar)

func _on_mute_mouse_entered() -> void:
	pass # Replace with function body.

func _on_leave_pressed() -> void:
	pass # Replace with function body.

func _on_leave_mouse_entered() -> void:
	bar.texture = bar_exit_focus

func _on_mute_pressed() -> void:
	has_sound = not has_sound
	var audio := AudioServer.get_bus_index("Master")
	if has_sound:
		mute_btn.texture_normal = no_sound
	else:
		AudioServer.set_bus_mute(audio, false)
		mute_btn.texture_normal = with_sound

func reset_bar() -> void:
	bar.texture = default_bar
