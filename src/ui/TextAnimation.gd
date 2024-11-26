extends RichTextLabel

@export var text_scroll_speed: int = 20

var text_index = 0
signal done

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if text_index < text.length():
		text_index += text_scroll_speed
		visible_characters = text_index
	else:
		done.emit()
