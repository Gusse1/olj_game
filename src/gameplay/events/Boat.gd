extends "res://src/gameplay/Event.gd"

@onready var boat: Node3D = $"../.."
@export var environment: Environment
@export var siren_audio: AudioStreamPlayer
@export var sun: DirectionalLight3D
@export var water_walls: Node3D
@export var spirits: Node3D

var boat_in_motion: bool

var boat_speed: float = 1.5

var sun_transition_speed: float = 0.12

var time_since_boat_in_motion:  float

var target_color: Color = Color(1, 1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if boat_in_motion:
		time_since_boat_in_motion += delta

		boat.global_transform.origin += boat.global_transform.basis.z * -boat_speed * delta
		

		if time_since_boat_in_motion > 20:
			spirits.visible = true
			
			for wall in water_walls.get_children():
				wall.use_collision = false

			if not siren_audio.playing:
				siren_audio.play()
	
			var current_color: Color = environment.volumetric_fog_albedo
			var emission_color: Color = environment.volumetric_fog_emission
			var new_color: Color = current_color.lerp(target_color, sun_transition_speed * delta)
			var new_emission_color: Color = emission_color.lerp(target_color, sun_transition_speed * delta)
			environment.volumetric_fog_albedo = new_color
			environment.volumetric_fog_emission = new_emission_color

			var current_emission_intensity: float = environment.volumetric_fog_emission_energy
			var new_emission_intensity: float = lerp(current_emission_intensity, 0.1, sun_transition_speed * delta)
			environment.volumetric_fog_emission_energy = new_emission_intensity
			
			var current_sun_intensity: float = sun.light_energy
			var new_sun_intensity: float = lerp(current_sun_intensity, 1.0, sun_transition_speed * delta)
			sun.light_energy = new_sun_intensity
			
			if current_sun_intensity >= 9.9:
				print_debug("Transition_finished")
	

func interact() -> void:
	boat_in_motion = true
	get_node("MotorSound").play()
