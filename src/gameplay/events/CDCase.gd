extends "res://src/gameplay/Event.gd"

@export var original_situation: Node3D
@export var new_situation: Node3D

func interact():
	print_debug("Interacted with CD Case")
	original_situation.process_mode = Node.PROCESS_MODE_DISABLED
	original_situation.visible = false

	new_situation.process_mode = Node.PROCESS_MODE_ALWAYS
	new_situation.visible = true
