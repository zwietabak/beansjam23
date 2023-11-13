extends EnemyBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	character.face_direction.look_at(character.follow_target.global_transform.origin, Vector3.UP)
	character.rotate_y(deg_to_rad(character.face_direction.rotation.y * character.TURN_SPEED))


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	print("Attack")
	character.attack_player()
	character.in_combat = true
	$"../../Damage_Detection/CollisionShape3D".shape.radius = 1

func exit() -> void:
	pass

func recive_event(value: String) -> void:
	match (value):
		"attack_end": 
			$"../../Damage_Detection/CollisionShape3D".shape.radius = 0.5
			var overlapping_boddies = character.damage_detection.get_overlapping_bodies()
			for body in overlapping_boddies:
				if(body.name == "Player"):
					state_machine.transition_to("Attack")
					return
			state_machine.transition_to("Follow")
