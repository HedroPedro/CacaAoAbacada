extends Control

signal _can_update

@onready var blocks := $BlocksContainer.get_children()
@onready var imgTexture := $Container/Image
var arraySilabas := Global.array_silabas
var correctIndex := -1

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	for i in range(3):
		blocks[i].index = i
		blocks[i].toCall = checkTruth

func updateBlocks():
	Global.embaralhar()
	var maxIndex := arraySilabas.size() - 1
	var tmpIndex := {}
	while tmpIndex.size() < 3:
		var i := randi_range(0, maxIndex)
		tmpIndex[i] = true
	var indexes := tmpIndex.keys()
	correctIndex = randi_range(0, 2)

	for i in range(3):
		var index : int = indexes[i]
		blocks[i].update(arraySilabas[index])

	imgTexture.texture = arraySilabas[indexes[correctIndex]].imagens[0]

func checkTruth(index : int):
	if index == correctIndex:
		updateBlocks()
		_can_update.emit()
