extends Control


func _on_btn_start_pressed():
	print("oink")
	SceneTransition.change_scene("res://main.tscn")

func _on_btn_options_pressed():
	pass # Replace with function body.

func _on_btn_credits_pressed():
	pass # Replace with function body.

func _on_btn_exit_pressed():
	get_tree().quit()
