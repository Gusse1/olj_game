extends RichTextLabel

@export var directives: Array[String]
var current_directive: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func next_directive() -> void:
	current_directive += 1
	text = directives[current_directive]
	