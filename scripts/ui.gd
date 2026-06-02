extends Control

@onready var bar := $BoxContainer/Bar
@onready var muteBtn := $BoxContainer/Bar/Mute
@onready var mute_btn_player := $BoxContainer/Bar/Mute/AudioStreamPlayer
@onready var leaveBtn := $BoxContainer/Bar/Leave
@onready var leave_btn_player := $BoxContainer/Bar/Leave/AudioStreamPlayer
@onready var startStreamPlayer := $Start/StartStreamPlayer
@onready var slider := $BoxContainer/VSlider
var with_sound := load("res://images/menu/volume.png")
var no_sound := load("res://images/menu/muted.png")
var default_bar := load("res://images/menu/menu_fixo.png")
var bar_sound_focus := load("res://images/menu/menu_fixo_som.png")
var bar_exit_focus := load("res://images/menu/menu_fixo_porta.png")
var return_icon :=load("res://images/menu/seta_back.png")
var door_icon := load("res://images/menu/door.png")
var door_icon2 := load("res://images/menu/door.png")
var go_back_sound := load("res://sounds/goBack.mp3")
var exit_sound := load("res://sounds/sair.mp3")
var sound_sound := load("res://sounds/sound.mp3")
var has_sound = true
var musicPlayer : AudioStreamPlayer
var stage0 := true

func _on_mute_mouse_entered() -> void:
	bar.texture = bar_sound_focus
	mute_btn_player.play()
	await mute_btn_player.finished

func _on_leave_mouse_entered() -> void:
	bar.texture = bar_exit_focus
	leave_btn_player.play()
	await leave_btn_player.finished

func _on_mute_pressed() -> void:
	has_sound = not has_sound
	if has_sound:
		muteBtn.texture_normal = with_sound
		Global.change_music_db(slider.value)
		return
	Global.change_music_db(-80.0)
	muteBtn.texture_normal = no_sound

func reset_bar() -> void:
	bar.texture = default_bar

func _on_start_mouse_entered() -> void:
	startStreamPlayer.play()
	await startStreamPlayer.finished

func _on_skip_tutorial_mouse_entered() -> void:
	$SkipTutorial/AudioStreamPlayer.play()
	await $SkipTutorial/AudioStreamPlayer.finished

func _on_skip_tutorial_pressed() -> void:
	Global.emit_signal("_finish_tutorial")

func _on_v_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed:
		return
	Global.change_music_db(slider.value)

func swap_exit_btn() -> void:
	stage0 = not stage0
	if not stage0:
		leaveBtn.texture_normal = return_icon
		leaveBtn.texture_hover = return_icon
		leave_btn_player.stream = go_back_sound
		return
	leave_btn_player.stream = exit_sound
	leaveBtn.texture_normal = door_icon
	leaveBtn.texture_hover = door_icon2

func setDisabledBtn(disable : bool):
	leaveBtn.disabled = disable
