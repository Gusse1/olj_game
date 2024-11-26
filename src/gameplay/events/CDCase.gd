extends "res://src/gameplay/events/Event.gd"

@export var original_situation: Node3D
@export var new_situation: Node3D
@export var interact_audio: AudioStreamPlayer3D
@export var note_manager: ColorRect
@export var directive_manager: RichTextLabel

signal cd_case_picked_up

func interact():
	print_debug("Interacted with CD Case")
	original_situation.process_mode = Node.PROCESS_MODE_DISABLED
	original_situation.visible = false

	new_situation.process_mode = Node.PROCESS_MODE_INHERIT
	new_situation.visible = true

	get_parent().visible = false
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	
	if note_manager:
		note_manager.activate_note("CD_Case")
	if directive_manager:
		directive_manager.next_directive()
	
	if interact_audio:
		interact_audio.play()