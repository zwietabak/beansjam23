extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
	$MarginContainer/MarginContainer/VBoxContainer/btn_restart.grab_focus()

func _on_btn_restart_pressed():
	$MarginContainer/MarginContainer/VBoxContainer/btn_restart.grab_focus()
	SceneTransition.change_scene("res://level.tscn")


func _on_btn_exit_pressed():
	$MarginContainer/MarginContainer/VBoxContainer/btn_exit.grab_focus()
	get_tree().quit()


func _on_btn_main_menu_pressed():
	$MarginContainer/MarginContainer/VBoxContainer/btn_main_menu.grab_focus()
	SceneTransition.change_scene("res://ui/main_menu.tscn")
