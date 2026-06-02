extends Node

@onready var start_btn := $Ui/Start
@onready var skip_btn := $Ui/SkipTutorial
@onready var exitBtn := $Ui/BoxContainer/Bar/Leave
@onready var bg := $Background
@onready var ui := $Ui
@onready var gameUi := $GameUi
@onready var blockContainer := $GameUi/BlocksContainer
@onready var cursor := $Cursor
@onready var pirateSound := $PirateSound

var GameState := 0
var backgrounds := [load("res://images/background.png"), load("res://images/1.png"), load("res://images/2.png"), load("res://images/3.png"), load("res://images/end.png")]
var bgMaxIndex : int
var steps := []
var _current_tween : Tween = null

func _ready() -> void:
	Global.pirateSound = pirateSound
	Global.musicPlayer = $Music
	Global._done.connect(_enable_btn)
	Global._finish_tutorial.connect(_reset_tutorial)
	start_btn.connect("pressed", _on_start_btn_pressed)
	exitBtn.connect("pressed", _on_exit_btn_pressed)
	gameUi._can_update.connect(update)
	bgMaxIndex = backgrounds.size() - 1
	steps.append(create_step_dict($GameUi/Container/Image, load("res://sounds/step1.mp3"), false))

func _enable_btn():
	start_btn.disabled = false

func _on_start_btn_pressed() -> void:
	GameState = 1
	gameUi.changeBlkDisable(true)
	gameUi.updateBlocks()
	start_btn.visible = false
	gameUi.visible = true
	bg.texture = backgrounds[1];
	$Ui.swap_exit_btn()
	tutorial()

func create_step_dict(target: Control, voice: AudioStream , click: bool, produce_sound : bool = false)\
-> Dictionary:
	return {"target": target, "voice": voice, "click": click, "produce_sound": produce_sound}

func tutorial() -> void:
	var correct_index : int = gameUi.updateBlocks()
	var false_index := randi_range(0, 2)
	var timer := $Timer
	cursor.visible = true
	skip_btn.visible = true
	while false_index == correct_index:
		false_index = randi_range(0, 2)
	steps.append_array([
		create_step_dict(blockContainer.get_child(false_index), load("res://sounds/step2.mp3"), true, true),
		create_step_dict(blockContainer.get_child(correct_index), load("res://sounds/step3.mp3"), true, true),
		])
	await get_tree().process_frame
	await get_tree().process_frame
	for step in steps:
		var target : Control = step["target"]
		var stream : AudioStream = step["voice"]
		if target:
			await move_pseudo_mouse(target)
			if step["produce_sound"]:
				target._on_texture_button_mouse_entered()
			if step["click"]:
				target._on_texture_button_pressed()

		pirateSound.stream = stream
		pirateSound.play()
		await pirateSound.finished
		timer.start()
		await timer.timeout
	skip_btn.visible = false
	cursor.visible = false
	cursor.set_position(Vector2(856.0, 80.0))
	GameState = 0
	update()
	gameUi.changeBlkDisable(false)

func move_pseudo_mouse(target: Control):
	var dest := target.get_global_rect().get_center()
	_current_tween = create_tween()
	_current_tween.tween_property(cursor, "global_position", dest, 0.8)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	await _current_tween.finished
	_current_tween = null

func _on_exit_btn_pressed() -> void:
	if GameState == 0:
		get_tree().quit()
	_reset_tutorial()
	$Ui.swap_exit_btn()
	GameState = 0
	bg.texture = backgrounds[0]
	gameUi.visible = false
	start_btn.visible = true

func _reset_tutorial() -> void:
	if _current_tween:
		_current_tween.kill()
		_current_tween = null

	pirateSound.stop()
	$Timer.stop()

	cursor.visible = false
	skip_btn.visible = false
	steps.clear()
	gameUi.changeBlkDisable(false)

func update() -> void:
	ui.setDisabledBtn(true)
	gameUi.hide()
	GameState += 1
	bg.texture = backgrounds[GameState]
	await get_tree().create_timer(1.25).timeout
	if GameState == bgMaxIndex:
		return
	gameUi.updateBlocks()
	gameUi.show()
	ui.setDisabledBtn(false)
