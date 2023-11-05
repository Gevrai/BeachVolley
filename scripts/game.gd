extends Node2D

@onready var ball_scene: PackedScene = preload("res://Ball.tscn")

@onready var score1: Label = $UI/Score1
@onready var score2: Label = $UI/Score2

var ball: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball = ball_scene.instantiate() as Node2D
	ball.position = $Spawn0.position
	add_child(ball)

	score1.text = "0"
	score2.text = "0"

func reset_ball(pos: Vector2) -> void:
	ball.queue_free()
	ball = ball_scene.instantiate() as Node2D
	ball.position = pos
	get_tree().get_root().add_child(ball)

func _on_goal_1_body_entered(body: Node2D):
	if !body.is_in_group("ball"): return

	$GoalSound.play()
	score2.text = str(score2.text.to_int() + 1)
	call_deferred("reset_ball", $Spawn2.position)

func _on_goal_2_body_entered(body: Node2D):
	if !body.is_in_group("ball"): return

	$GoalSound.play()
	score1.text = str(score1.text.to_int() + 1)
	call_deferred("reset_ball", $Spawn1.position)
