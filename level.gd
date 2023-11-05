extends Node

func trigger_smashed_door_dialog():
	$DialogueBox.start("DOOR_CONV")


func _on_scream_trigger_body_entered(body):
	if body.name == "Player":
		$Scream.play()


func _on_enemy_on_died():
	$DialogueBox.start("FIRST_ENEMY_DEAD")
	var flares = get_tree().get_nodes_in_group("flare_first_enemy")
	for flare in flares:
		flare.visible = true


func _on_scream_finished():
	$DialogueBox.start("WEIRD_NOISE")


func _on_enemy_group_all_dead():
	$DialogueBox.start("HOW_MANY")
	var flares = get_tree().get_nodes_in_group("flare_first_group")
	for flare in flares:
		flare.visible = true


func _on_enemy_group_2_all_dead():
	$DialogueBox.start("AFTER_FIGHT_CONV")
	var flares = get_tree().get_nodes_in_group("flare_before_jail")
	for flare in flares:
		flare.visible = true
