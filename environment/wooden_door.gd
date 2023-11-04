extends Node3D

@export var collision : CollisionShape3D

#@onready var rigid_bodies = get_tree().get_nodes_in_group("rigid_bodies")

var broken = false

signal door_smashed


func _on_area_3d_body_entered(body):
	if(body.name == "Companion"):
		collision.call_deferred("set_disabled", true)
		$Door/Cube_004.set_visible(false)
		$Door/Cube_006.set_visible(false)
		$Door/Cube_007.set_visible(false)
		#for rigid_body in rigid_bodies:
		#	rigid_body.set_freeze_enabled(false)
		if not $AudioStreamPlayer3D.playing and not broken:
			$AudioStreamPlayer3D.play()
		broken = true
		door_smashed.emit()
		

