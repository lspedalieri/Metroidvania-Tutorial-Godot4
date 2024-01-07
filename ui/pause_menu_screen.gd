extends CanvasLayer


func _ready():
	print("pause menu")


func _on_main_menu_pressed():
	print("on main menu")
	GameManager.main_menu()
	queue_free()



func _on_continue_pressed():
	print("on main menu")
	GameManager.continue_game()
	queue_free()
