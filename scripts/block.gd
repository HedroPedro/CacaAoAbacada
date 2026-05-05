extends Control

@onready var wordLabel := $TextureButton/Word
@onready var soundStream := $AudioStreamPlayer2D
var audio : AudioStreamOggVorbis
var index : int
var toCall : Callable

func update(valDict : Dictionary) -> void:
	wordLabel.text = valDict["silaba"]
	audio = valDict["som"]

func _on_texture_button_pressed() -> void:
	toCall.call(index)

func _on_texture_button_mouse_entered() -> void:
	soundStream.stream = audio
	soundStream.play()
