class_name Player
extends CharacterBody2D

@export var max_speed = 250.0
@export var max_fall_velocity = 250.0
@export var acceleration = 750.0
@export var jump_velocity = -400.0
@onready var animation: AnimationPlayer = $AnimationPlayer
var current_interactable: Node = null
var paused = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float):
	if paused:
		if Input.is_action_just_pressed("pause"):
			get_node("/root/Map/PauseScreen").hide()
			get_node("/root/Map/PauseScreen").enabled = false
			paused = false
		return

	if not paused and Input.is_action_just_pressed("pause"):
		paused = true
		get_node("/root/Map/PauseScreen").show()
		get_node("/root/Map/PauseScreen").enabled = true
		return

	var direction = Input.get_axis("move_left", "move_right")
	if direction and velocity.x != 0:
		animation.play("Walking")
		flip(direction)
	else:
		animation.play("Idle")
		
	if Input.is_action_just_pressed("action") and current_interactable:
		current_interactable.do_action()

	apply_gravity(delta)
	handle_jump()

	handle_horizontal_movement(direction, delta)

	move_and_slide()

func flip(direction):
	transform.x.x = sign(direction)

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, delta * gravity)

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$JumpSound.play()
		velocity.y = jump_velocity

func handle_horizontal_movement(direction: float, delta: float):
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, delta * acceleration)
		flip(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * acceleration)

func _on_plot_hitbox_area_entered(area: Area2D):
	if not area.owner is PlantablePlot and not area.owner is ExpandSign:
		## this shouldn't happen
		return
		
	current_interactable = area.owner

func _on_plot_hitbox_area_exited(area: Area2D):
	current_interactable = null
