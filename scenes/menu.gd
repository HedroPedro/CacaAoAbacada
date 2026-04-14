extends Node2D

@onready var btn := $Ui/Container/VBoxContainer/Start

func _ready() -> void:
	btn.connect("pressed", _on_start_btn_pressed)

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
