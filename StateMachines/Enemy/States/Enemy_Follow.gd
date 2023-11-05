extends EnemyBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	character.follow_player(_delta)


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	if character.battle_music != null:
		character.battle_music.fade_in()
	character.walking_sound.start_walking()
	character.running.emit(true)
	character.in_combat = true


func exit() -> void:
	character.walking_sound.stop_walking()
	character.running.emit(false)

func recive_event(value: String) -> void:
	match (value):
		"attack_player": state_machine.transition_to("Attack")
		"walk_back": state_machine.transition_to("Retreat")
