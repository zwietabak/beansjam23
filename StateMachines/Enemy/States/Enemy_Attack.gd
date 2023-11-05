extends EnemyBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	character.attack_player()
	character.in_combat = true

func exit() -> void:
	pass

func recive_event(value: String) -> void:
	match (value):
		"attack_end": 
			var overlapping_boddies = character.damage_detection.get_overlapping_bodies()
			for body in overlapping_boddies:
				if(body.name == "Player"):
					print("go in attack")
					state_machine.transition_to("Attack")
					return
	
			print("go in attack")					
			state_machine.transition_to("Follow")
