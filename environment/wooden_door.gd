extends Node3D

@export var collision : CollisionShape3D
@export var breakable = true
@export var rigid_bodies : Array[RigidBody3D]

signal door_smashed

var broken = false
var rng = RandomNumberGenerator.new()

func destroy_door():
	collision.call_deferred("set_disabled", true)
	$Door/Cube_004.set_visible(false)
	$Door/Cube_006.set_visible(false)
	$Door/Cube_007.set_visible(false)
	for rigid_body in rigid_bodies:
		rigid_body.set_freeze_enabled(false)
	if not broken:
		door_smashed.emit()
		$AudioStreamPlayer3D.set_pitch_scale(rng.randf_range(0.8, 1.2))
		$AudioStreamPlayer3D.play()
	broken = true
	
func explode():
	destroy_door()
	for rigid_body in rigid_bodies:
		rigid_body.apply_force(get_global_transform().basis.z, position)

func _on_area_3d_body_entered(body):
	if body.name == "Companion" and breakable:
		explode()
		

func _on_dialogue_box_dialogue_signal(value):
	match (value):
		"smash_door":	explode()
