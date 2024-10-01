extends Control

func _on_resume_click_end():
	visible = false
	get_tree().paused = false

func _on_menu_click_end():
	get_tree().quit()
