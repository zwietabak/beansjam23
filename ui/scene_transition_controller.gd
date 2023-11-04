extends CanvasLayer


func change_scene(target: String):
	$Transition_Animation.play("dissolve")
	await $Transition_Animation.animation_finished
	get_tree().change_scene_to_file(target)
	$Transition_Animation.play_backwards("dissolve")
