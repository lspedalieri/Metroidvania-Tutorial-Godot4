extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var JUMP_HORIZONTAL: float = 100.0
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
	if is_on_floor():
		current_state = State.Idle
		velocity.x = move_toward(velocity.x, 0, SPEED)


func player_jump(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_state = State.Jump
	if not is_on_floor() and current_state == State.Jump:
		var direction = Input.get_axis("ui_left", "ui_right")
		velocity.x += direction * JUMP_HORIZONTAL * delta

func player_run(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if is_on_floor() and direction:
		current_state = State.Run
		velocity.x = direction * SPEED
	else:
		move_toward(velocity.x, 0, SPEED)



func player_animation() -> void:
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = true if velocity.x < 0 else false
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
