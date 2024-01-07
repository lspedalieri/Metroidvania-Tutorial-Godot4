extends CanvasLayer

var settings_menu_screen: PackedScene = preload("res://ui/settings_menu_screen.tscn")


func _on_play_pressed():
	print("on play")
	GameManager.start_game()
	queue_free()


func _on_exit_pressed():
	print("on exit")
	GameManager.exit_game()


func _on_settings_pressed():
	var settings_menu_screen_instance = settings_menu_screen.instantiate()
	get_tree().get_root().add_child(settings_menu_screen_instance)
