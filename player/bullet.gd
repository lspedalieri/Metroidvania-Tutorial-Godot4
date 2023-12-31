extends AnimatedSprite2D

var speed: int = 600
var direction: int
@export var damage_amount:int = 1
@export var bullet_impact_effect = preload("res://player/bullet_impact_effect.tscn")

func _physics_process(delta):
	move_local_x(direction * speed * delta)


func _on_timer_timeout():
	queue_free() # Replace with function body.


func _on_area_2d_area_entered(area):
	print("bullet area entered")
	bullet_impact()
	queue_free()


func _on_area_2d_body_entered(body):
	print("bullet body entered")
	bullet_impact()
	queue_free()


func get_damage_amount() -> int:
	return damage_amount


func bullet_impact():
	var bullet_impact_effect_instance = bullet_impact_effect.instantiate()
	bullet_impact_effect_instance.global_position = global_position
	get_parent().add_child(bullet_impact_effect_instance)
	queue_free()
