extends CanvasLayer



func _on_play_pressed():
	print("on play")
	GameManager.start_game()
	queue_free()


func _on_exit_pressed():
	print("on exit")
	GameManager.exit_game()
