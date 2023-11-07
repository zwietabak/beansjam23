extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$MarginContainer/MarginContainer/VBoxContainer/btn_start.grab_focus()

func _on_btn_start_pressed():
	$MarginContainer/MarginContainer/VBoxContainer/btn_start.grab_focus()
	SceneTransition.change_scene("res://level.tscn")

func _on_btn_options_pressed():
	pass # Replace with function body.

func _on_btn_credits_pressed():
	pass # Replace with function body.

func _on_btn_exit_pressed():
	$MarginContainer/MarginContainer/VBoxContainer/btn_exit.grab_focus()
	get_tree().quit()
