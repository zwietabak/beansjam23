extends Node

func trigger_smashed_door_dialog():
	$DialogueBox.start("DOOR_CONV")


func _on_scream_trigger_body_entered(body):
	if body.name == "Player":
		$Scream.play()


func _on_enemy_on_died():
	$DialogueBox.start("FIRST_ENEMY_DEAD")


func _on_scream_finished():
	$DialogueBox.start("WEIRD_NOISE")


func _on_enemy_group_all_dead():
	$DialogueBox.start("HOW_MANY")


func _on_enemy_group_2_all_dead():
	$DialogueBox.start("AFTER_FIGHT_CONV")
