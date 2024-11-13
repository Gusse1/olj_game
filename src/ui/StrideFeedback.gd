extends RichTextLabel

var orig_size: int = 75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if theme.default_font_size > 0 and visible:
		theme.default_font_size -= 1
	if theme.default_font_size < 15:
		visible = false
	

func give_feedback(feedback: String):
	text = feedback
	theme.default_font_size = orig_size
	visible = true