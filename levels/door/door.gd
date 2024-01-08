extends Node2D


@export var next_scene: String


func _on_exit_area_2d_body_entered(body: CharacterBody2D):
	if body.is_in_group("Player"):
		var player = body
		player.queue_free()
		
	await get_tree().create_timer(3.0).timeout
	print("scene transition")
	SceneManager.transition_to_scene(next_scene)
