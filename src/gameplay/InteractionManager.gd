extends Node

@onready var cursor_ui = $"../UserInterface/StrideIndicatorContainer"
@onready var interact_ui = $"../UserInterface/InteractIndicator"

@onready var cd_case_image = $"../UserInterface/InGameUI/Items/CDCaseImage"

@onready var raycast = $"../CameraPivot/Raycast"
@onready var player_area = $"../CameraPivot/DetectorCylinder/PlayerArea"
@onready var player = $".."

var looked_at_area: Area3D
var can_interact: bool

func _process(_delta: float) -> void:
	if looked_at_area and not _is_looking_at_wall():
		print_debug(looked_at_area.name)
		if (looked_at_area.name != "LevelEnd") or (looked_at_area.name != "TimeTransitioner"):
			interact_ui.visible = true
	else:
		interact_ui.visible = false

	if Input.is_action_just_pressed("interact"):
			if looked_at_area and not _is_looking_at_wall():
				looked_at_area.interact()
				if looked_at_area.name == "InteractArea":
					_on_cd_case_picked_up()
	

func _is_looking_at_wall() -> bool:
	raycast.force_raycast_update()

	raycast.add_exception(player_area)
	raycast.add_exception(player)

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider != looked_at_area:
			return true
		else:
			return false
	else:
		return false


func _on_area_3d_area_entered(area: Area3D) -> void:
	raycast.enabled = true
	looked_at_area = area
		
func _on_area_3d_area_exited(_area: Area3D) -> void:
	raycast.enabled = false
	looked_at_area = null

func _on_cd_case_picked_up() -> void:
	cd_case_image.visible = true
