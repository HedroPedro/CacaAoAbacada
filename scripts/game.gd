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
var _tutorial_cancelled := false

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
	_tutorial_cancelled = false
	var correct_index : int = gameUi.updateBlocks()
	var false_index := randi_range(0, 2)
	var timer := $Timer
	cursor.visible = true
	skip_btn.visible = true
	_skip_requested = false
	while false_index == correct_index:
		false_index = randi_range(0, 2)
	steps.append_array([
		create_step_dict($GameUi/Container/Image, load("res://sounds/step1.mp3"), false),
		create_step_dict(blockContainer.get_child(false_index), load("res://sounds/step2.mp3"), true, true),
		create_step_dict(blockContainer.get_child(correct_index), load("res://sounds/step3.mp3"), true, true),
		])
	await get_tree().process_frame
	await get_tree().process_frame
<<<<<<< HEAD

	for step in steps.duplicate():
		if _tutorial_cancelled: return
=======
	for step in steps:
		if _tutorial_cancelled:
			break
>>>>>>> 650cb03 (fix: return button not returning)
		var target : Control = step["target"]
		var stream : AudioStream = step["voice"]
		if target:
			await move_pseudo_mouse(target)
			if _tutorial_cancelled: return
			if step["produce_sound"]:
				target._on_texture_button_mouse_entered()
			if step["click"]:
				target._on_texture_button_pressed()

		pirateSound.stream = stream
		pirateSound.play()
		await pirateSound.finished
		if _tutorial_cancelled: return

		timer.start()
		await timer.timeout
		if _tutorial_cancelled: return

	skip_btn.visible = false
	cursor.visible = false
	cursor.set_position(Vector2(856.0, 80.0))
	GameState = 0
	update()
	gameUi.changeBlkDisable(false)

func move_pseudo_mouse(target: Control) -> bool:
	var dest := target.get_global_rect().get_center()
<<<<<<< HEAD
	dest.x -= 1.0
=======
	dest.x += 1.0
>>>>>>> 650cb03 (fix: return button not returning)
	_current_tween = create_tween()
	_current_tween.tween_property(cursor, "global_position", dest, 0.8)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	var skipped := await _wait_or_skip(_current_tween.finished)
	_current_tween = null

func _reset_tutorial() -> void:
	_tutorial_cancelled = true

	if _current_tween:
		var t := _current_tween
		_current_tween = null
		t.kill()
		t.emit_signal("finished")   # libera o await em move_pseudo_mouse

	if pirateSound.playing:
		pirateSound.stop()
	pirateSound.emit_signal("finished")  # libera o await da voz

	$Timer.stop()
	$Timer.emit_signal("timeout")  # libera o await do timer

	cursor.visible = false
	skip_btn.visible = false
	steps.clear()
	gameUi.changeBlkDisable(false)

func _on_exit_btn_pressed() -> void:
	if GameState == 0:
		get_tree().quit()
<<<<<<< HEAD
		return
=======
		return;
>>>>>>> 650cb03 (fix: return button not returning)
	_reset_tutorial()
	$Ui.swap_exit_btn()
	GameState = 0
	bg.texture = backgrounds[0]
	gameUi.visible = false
	start_btn.visible = true

func update() -> void:
	ui.setDisabledBtn(true)
	gameUi.hide()
	GameState += 1
	bg.texture = backgrounds[GameState]
	await get_tree().create_timer(1.25).timeout
	ui.setDisabledBtn(false)
	if GameState == bgMaxIndex:
		ui.setDisabledBtn(false)
		return
	gameUi.updateBlocks()
	gameUi.show()

func _on_music_finished() -> void:
	$Music.play()
