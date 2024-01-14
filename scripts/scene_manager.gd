extends Node

var scene_transition_screen: PackedScene = preload("res://ui/scene_transition/scene_transition_screen.tscn")

var scenes: Dictionary = {
	"Level1": "res://levels/level_1.tscn",
	"Level2": "res://levels/level_2.tscn"
}


func transition_to_scene(level: String):
	var scene_path: String = scenes.get(level)
	var scene_transition_screen_instance = scene_transition_screen.instantiate()
	get_tree().get_root().add_child(scene_transition_screen_instance)
	if scene_path != null:
		await get_tree().create_timer(5.0).timeout
		get_tree().change_scene_to_file(scene_path)
		scene_transition_screen_instance.queue_free()
	
