extends CharacterBody2D

@export var patrol_points: Node
@export var speed: int = 1500
@export var wait_time: int = 3
@export var health_amount: int = 3
@export var damage_amount: int = 1
@export var bullet_impact_effect: PackedScene = preload("res://player/enemy_death_effect.tscn")

@onready var timer: Timer = $Timer

enum State {Idle, Walk}
var current_state: State
var direction: Vector2 = Vector2.LEFT
var number_of_points: int
var point_positions: Array[Vector2]
var current_point: Vector2
var current_point_position: int
var can_walk: bool
@onready var animated_sprite_2d = $AnimatedSprite2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	timer.start()
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("no patrol points")
		


func _physics_process(delta):
	enemy_gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	move_and_slide()
	enemy_animation()


func enemy_gravity(delta):
	velocity.y += gravity * delta

func enemy_idle(delta: float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		current_state = State.Idle
	
	
func enemy_walk(delta: float):
	if !can_walk:
		return
		
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = State.Walk
		#print("move")
	else:
		current_point_position += 1
		
		if current_point_position >= number_of_points:
			current_point_position = 0
			
		current_point = point_positions[current_point_position]
		
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		can_walk = false
		timer.start()
		#print("stop")
	$AnimatedSprite2D.flip_h = direction.x > 0


func enemy_animation():
	if current_state == State.Idle || !can_walk:
		animated_sprite_2d.play("idle")
	elif current_state == State.Walk && can_walk:
		animated_sprite_2d.play("walk")


func _on_timer_timeout():
	can_walk = true


func _on_hurtbox_area_entered(area: Area2D):
	print("hurtbox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		print("Health amount ", health_amount)
		if health_amount <= 0:
			var bullet_impact_effect_instance = bullet_impact_effect.instantiate()
			bullet_impact_effect_instance.global_position = global_position
			get_parent().add_child(bullet_impact_effect_instance)
			queue_free()
