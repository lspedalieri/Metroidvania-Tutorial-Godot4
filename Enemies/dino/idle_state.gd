extends NodeState

@export var character_body_2d: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var slow_down_speed: int = 150

func on_process(delta: float):
	pass


func on_physics_process(delta: float):
	print("breaking")
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, slow_down_speed * delta)
	animated_sprite_2d.play("idle")
	character_body_2d.move_and_slide()


func enter():
	print("entered in idle state")
	pass


func exit():
	print("exited from idle state")
	pass

