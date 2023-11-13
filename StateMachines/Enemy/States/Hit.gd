extends EnemyBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	character.invincible = true
	character.velocity.x = 0
	character.velocity.z = 0


func exit() -> void:
	character.invincible = false


func recive_event(value: String) -> void:
	match (value):
		"recovered": 
			var overlapping_boddies = character.damage_detection.get_overlapping_bodies()
			for body in overlapping_boddies:
				if(body.name == "Player"):
					state_machine.transition_to("Attack")
					return
			state_machine.transition_to("Follow")
