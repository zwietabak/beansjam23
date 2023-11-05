extends EnemyBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	character.walk_back_to_start(_delta)


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	character.in_combat = false
		
	character.walking_sound.start_walking()
	character.running.emit(true)


func exit() -> void:
	character.walking_sound.stop_walking()
	character.running.emit(false)


func recive_event(value: String) -> void:
	match (value):
		"player_detected": state_machine.transition_to("Follow")
