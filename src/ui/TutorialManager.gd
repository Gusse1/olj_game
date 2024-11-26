extends ColorRect

var active_tutorial: RichTextLabel
var tutorial_timer: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tutorial_timer > 0:
		tutorial_timer -= delta
	else:
		visible = false
		if active_tutorial:
			active_tutorial.visible = false

func activate_tutorial(tutorial_name: String, duration: float) -> void:
	if active_tutorial:
		active_tutorial.visible = false
	visible = true
	active_tutorial = get_node(tutorial_name)
	active_tutorial.visible = true
	
	tutorial_timer = duration
	