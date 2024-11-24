extends ColorRect

var active_tutorial: RichTextLabel
var tutorial_timer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tutorial_timer > 0:
		tutorial_timer -= delta
	else:
		visible = false
		if active_tutorial:
			active_tutorial.visible = false

func activate_tutorial(tutorial_name: String, duration: float) -> void:
	visible = true
	active_tutorial = get_node(tutorial_name)
	active_tutorial.visible = true
	
	tutorial_timer = duration
	