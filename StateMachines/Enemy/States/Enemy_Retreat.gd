extends EnemyBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	character.walk_back_to_start(_delta)


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	print("Retreat")
	character.in_combat = false
	character.battle_music.check_if_enemy_in_combat()
	character.running.emit(true)


func exit() -> void:
	character.running.emit(false)


func recive_event(value: String) -> void:
	match (value):
		"player_detected": state_machine.transition_to("Follow")
