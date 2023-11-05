extends EnemyBaseState


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	character.velocity.x = 0
	character.velocity.z = 0

func exit() -> void:
	character.is_active = true
	character.invincible = false
