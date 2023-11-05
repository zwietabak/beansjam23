extends Control


func _on_btn_restart_pressed():
	SceneTransition.change_scene("res://level.tscn")


func _on_btn_exit_pressed():
	get_tree().quit()


func _on_btn_main_menu_pressed():
	SceneTransition.change_scene("res://ui/main_menu.tscn")
