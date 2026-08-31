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
var _skip_requested := false
signal _tutorial_interrupt

func _ready() -> void:
	Global.pirateSound = pirateSound
	Global.musicPlayer = $Music
	Global._done.connect(_enable_btn)
	Global._finish_tutorial.connect(_reset_tutorial)
	start_btn.connect("pressed", _on_start_btn_pressed)
	exitBtn.connect("pressed", _on_exit_btn_pressed)
	skip_btn.connect("pressed", _on_skip_btn_pressed)
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
	_skip_requested = false
	while false_index == correct_index:
		false_index = randi_range(0, 2)
	steps.append_array([
		create_step_dict(blockContainer.get_child(false_index), load("res://sounds/step2.mp3"), true, true),
		create_step_dict(blockContainer.get_child(correct_index), load("res://sounds/step3.mp3"), true, true),
		])
	await get_tree().process_frame
	await get_tree().process_frame
	for step in steps:
		if _skip_requested:
			break
		var target : Control = step["target"]
		var stream : AudioStream = step["voice"]
		if target:
			if await move_pseudo_mouse(target):
				break
			if step["produce_sound"]:
				target._on_texture_button_mouse_entered()
			if step["click"]:
				target._on_texture_button_pressed()

		pirateSound.stream = stream
		pirateSound.play()
		if await _wait_or_skip(pirateSound.finished):
			break
		timer.start()
		if await _wait_or_skip(timer.timeout):
			break
	skip_btn.visible = false
	cursor.visible = false
	cursor.set_position(Vector2(856.0, 80.0))
	GameState = 0
	update()
	gameUi.changeBlkDisable(false)

func move_pseudo_mouse(target: Control) -> bool:
	var dest := target.get_global_rect().get_center()
	_current_tween = create_tween()
	_current_tween.tween_property(cursor, "global_position", dest, 0.8)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	var skipped := await _wait_or_skip(_current_tween.finished)
	_current_tween = null
	return skipped

## Waits for "sig" to fire, but stops waiting immediately if Skip is pressed.
## Returns true if it was interrupted by Skip, false if "sig" fired normally.
func _wait_or_skip(sig: Signal) -> bool:
	if _skip_requested:
		return true
	var done := false
	var skipped := false
	var on_sig := func(_a = null, _b = null, _c = null, _d = null):
		done = true
	var on_skip := func():
		skipped = true
		done = true
	sig.connect(on_sig, CONNECT_ONE_SHOT)
	_tutorial_interrupt.connect(on_skip, CONNECT_ONE_SHOT)
	while not done:
		await get_tree().process_frame
	if sig.is_connected(on_sig):
		sig.disconnect(on_sig)
	if _tutorial_interrupt.is_connected(on_skip):
		_tutorial_interrupt.disconnect(on_skip)
	return skipped

func _on_skip_btn_pressed() -> void:
	if _skip_requested:
		return
	_skip_requested = true
	_tutorial_interrupt.emit()

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
		ui.setDisabledBtn(false)
		return
	gameUi.updateBlocks()
	gameUi.show()
	ui.setDisabledBtn(false)
