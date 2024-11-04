extends RichTextLabel

var text_index = 0
signal done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if text_index < text.length():
		text_index += 20
		visible_characters = text_index
	else:
		done.emit()
