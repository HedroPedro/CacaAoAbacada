extends Control
@onready var bar := $Container/BoxContainer/Bar 
@onready var muteBtn := $Container/BoxContainer/Bar/Mute
@onready var startStreamPlayer := $Container/VBoxContainer/Start/StartStreamPlayer2D
@onready var tutorialStreamPlayer := $Container/VBoxContainer/Tutorial/TutorialStreamPlayer2D
var with_sound := load("res://images/menu/volume.png")
var no_sound := load("res://images/menu/muted.png")
var default_bar := load("res://images/menu/menu_fixo.png")
var bar_sound_focus := load("res://images/menu/menu_fixo_som.png")
var bar_exit_focus := load("res://images/menu/menu_fixo_porta.png")
var has_sound = true

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	startStreamPlayer.stream = load("res://sounds/jogar.mp3")
	tutorialStreamPlayer.stream = load("res://sounds/howToPlay.mp3")

func _on_mute_mouse_entered() -> void:
	bar.texture = bar_sound_focus

func _on_leave_mouse_entered() -> void:
	bar.texture = bar_exit_focus

func _on_mute_pressed() -> void:
	has_sound = not has_sound
	var audio := AudioServer.get_bus_index("Master")
	if has_sound:
		muteBtn.texture_normal = no_sound
		return
	AudioServer.set_bus_mute(audio, false)
	muteBtn.texture_normal = with_sound

func reset_bar() -> void:
	bar.texture = default_bar

func _on_start_mouse_entered() -> void:
	if !startStreamPlayer.playing:
		startStreamPlayer.play()

func _on_tutorial_mouse_entered() -> void:
	if !tutorialStreamPlayer.playing:
		tutorialStreamPlayer.play()
