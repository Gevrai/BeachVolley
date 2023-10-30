extends RigidBody2D

@export var speed := 150.0
@export var jump_velocity := -320.0
@export var jump_squash := 0.8
@export var playerID := "player1"

@onready var body: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var floorDetectionArea: Area2D = $FloorDetectionArea

var is_on_floor := false

func _ready():
	if playerID == "player2":
		body.flip_h = true
		$Body/Eye.position.x = -$Body/Eye.position.x

func _process(_delta):
	if is_on_floor:
		if abs(linear_velocity.x) < 0.01:
			body.play("Idle", 0.2)
		else:
			body.play("Run")
	else:
		body.play("Jump")

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("%s_left" % playerID, "%s_right" % playerID)
	if direction:
		linear_velocity.x = direction * speed

	# Handle Jump.
	if Input.is_action_just_pressed("%s_jump" % playerID):
		body.scale.y = jump_squash
		$CollisionPolygon2D.scale.y = jump_squash

	if Input.is_action_just_released("%s_jump" % playerID):
		body.scale.y = 1
		$CollisionPolygon2D.scale.y = 1
		if is_on_floor:
			apply_central_impulse(Vector2(0, jump_velocity))

func _on_floor_detection_area_body_entered(_body: Node2D) -> void:
	is_on_floor = true

func _on_floor_detection_area_body_exited(_body: Node2D) -> void:
	is_on_floor = false
