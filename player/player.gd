extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var speed: int = 1000
@export var max_horizontal_speed: float = 300
@export var slow_down_speed: int = 100

@export var jump: float = -400.0
@export var jump_horizontal_speed: int = 1000
@export var max_jump_horizontal_speed: int = 300

enum State {Idle, Run, Jump}

var current_state: State

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	current_state = State.Idle

func _physics_process(delta: float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	#jump after run to see the correct animation
	player_jump(delta)
	move_and_slide()
	player_animation()
	print("State: ", State.keys()[current_state])


func input_movement() -> float:
	return Input.get_axis("ui_left", "ui_right")


func player_falling(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


func player_idle(delta: float) -> void:
	var direction = input_movement()
	if is_on_floor() and direction == 0:
		current_state = State.Idle
		velocity.x = move_toward(velocity.x, 0, speed)


func player_run(delta: float) -> void:
	if !is_on_floor():
		return
		
	var direction = input_movement()
	
	if direction:
		velocity.x += direction * speed * delta
		#print(speed, " - ", delta, " - ", velocity.x)
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)

	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = true if velocity.x < 0 else false

func player_jump(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump
		current_state = State.Jump
	if !is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, -max_jump_horizontal_speed, max_jump_horizontal_speed)


func player_animation() -> void:
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")

