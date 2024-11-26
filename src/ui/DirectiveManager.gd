extends RichTextLabel

@export var directives: Array[String]
var current_directive: int

func skip_to_directive(num: int) -> void:
	current_directive = num
	text = directives[current_directive]
	
func next_directive() -> void:
	current_directive += 1
	text = directives[current_directive]
	