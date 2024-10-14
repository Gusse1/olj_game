extends "res://src/gameplay/Event.gd"

@export var original_situation: Node3D
@export var new_situation: Node3D

signal cd_case_picked_up

func interact():
	print_debug("Interacted with CD Case")
	original_situation.process_mode = Node.PROCESS_MODE_DISABLED
	original_situation.visible = false

	new_situation.process_mode = Node.PROCESS_MODE_INHERIT
	new_situation.visible = true

	get_parent().visible = false
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
