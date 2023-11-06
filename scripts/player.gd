extends RigidBody2D

class_name Player

@export var speed := 150.0
@export var jump_velocity := -320.0
@export var jump_squash := 0.8
@export var playerID := "player1"

@onready var body: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var floorDetectionArea: Area2D = $FloorDetectionArea

var is_on_floor := false
@onready var ai_player: Node = $AIPlayer

func _ready():
	if playerID == "player2":
		body.flip_h = true
		$Body/Eye.position.x = -$Body/Eye.position.x

func _process(_delta):
	if is_on_floor:
		if abs(linear_velocity.x) < 0.01:
			body.play("Idle", 0.5)
		else:
			body.play("Run")
	else:
		body.play("Jump")

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("%s_left" % playerID, "%s_right" % playerID)
	if direction:
		stop_ai()
		move(direction)

	# Handle Jump.
	if Input.is_action_just_pressed("%s_jump" % playerID):
		stop_ai()
		squash()

	if Input.is_action_just_released("%s_jump" % playerID):
		jump()

func move(direction: float) -> void:
	linear_velocity.x = direction * speed

func squash():
	body.scale.y = jump_squash
	$CollisionPolygon2D.scale.y = jump_squash

func jump():
	body.scale.y = 1
	$CollisionPolygon2D.scale.y = 1
	if is_on_floor:
		apply_central_impulse(Vector2(0, jump_velocity))
		$JumpSound.play()

func stop_ai():
	if ai_player:
		ai_player.queue_free()
		ai_player = null

func _on_floor_detection_area_body_entered(_body: Node2D) -> void:
	is_on_floor = true

func _on_floor_detection_area_body_exited(_body: Node2D) -> void:
	is_on_floor = false
