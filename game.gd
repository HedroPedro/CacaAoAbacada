extends Node

@onready var btn := $Ui/Container/VBoxContainer/Start
@onready var exitBtn := $Ui/Container/BoxContainer/Bar/Leave
@onready var bg := $Background
@onready var gameUi := $GameUi
var GameState := 0

var backgrounds := [load("res://images/background.jpg"), load("res://images/1.png"), load("res://images/2.png"), load("res://images/3.png"), load("res://images/end.png")]
var bgMaxIndex : int

func _ready() -> void:
	Global._done.connect(_enable_btn)
	btn.disabled = true
	btn.connect("pressed", _on_start_btn_pressed)
	exitBtn.connect("pressed", _on_exit_btn_pressed)
	gameUi._can_update.connect(update)
	bgMaxIndex = backgrounds.size() - 1

func _enable_btn():
	btn.disabled = false

func _on_start_btn_pressed() -> void:
	GameState = 1
	btn.visible = false
	gameUi.visible = true
	bg.texture = backgrounds[1];
	gameUi.updateBlocks()

func _on_exit_btn_pressed() -> void:
	if GameState == 0:
		get_tree().quit()
	GameState = 0
	bg.texture = backgrounds[0]
	gameUi.visible = false
	btn.visible = true

func update() -> void:
	gameUi.hide()
	GameState += 1
	bg.texture = backgrounds[GameState]
	await get_tree().create_timer(1.5).timeout
	if GameState == bgMaxIndex:
		return
	gameUi.updateBlocks()
	gameUi.show()
