extends EnemyBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	character.in_combat = false
	
	character.velocity.x = 0
	character.velocity.z = 0
	
	for body in character.player_detection.get_overlapping_bodies():
		if(body.name == "Player"):
			state_machine.transition_to("Follow")
			return


func exit() -> void:
	pass


func recive_event(value: String) -> void:
	match (value):
		"player_detected": state_machine.transition_to("Follow")
