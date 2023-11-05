extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_btn_start_pressed():
	SceneTransition.change_scene("res://level.tscn")

func _on_btn_options_pressed():
	pass # Replace with function body.

func _on_btn_credits_pressed():
	pass # Replace with function body.

func _on_btn_exit_pressed():
	get_tree().quit()
