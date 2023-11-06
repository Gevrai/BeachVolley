extends Node2D

@onready var player = get_parent() as Player

var idle_position_x: float
var last_jumped = 0

func _ready() -> void:
	idle_position_x = global_position.x

# The position of this Node2D is the target to hit the ball with on the player
# I've put it around the eyes, so that the AI hits the ball mostly foward, with its head
func _physics_process(_delta: float) -> void:
	# Get the ball each time, as we delete it on goals and I can't be bothered
	var ball = get_tree().get_first_node_in_group("ball") as RigidBody2D

	# Are we on the same side as the ball?
	# If so, move to the ball, otherwise move to the idle position
	# The ball starts in the middle, don't move then as the player should strike first when game starts.
	var is_ball_same_side = abs(ball.global_position.x) > 1 && (global_position.x < 0) == (ball.global_position.x < 1) 
	var move_to : float = ball.global_position.x if is_ball_same_side else idle_position_x
	if abs(global_position.x - move_to) > 5: # reduce jitter
		var direction = 1 if global_position.x < move_to else -1
		player.move(direction)
	
	# Jump if the ball is above us and close enough, and we haven't jumped too recently
	if last_jumped + 500 < Time.get_ticks_msec():
		if abs(global_position.x - ball.global_position.x) < 20:
			if global_position.y - 100 < ball.global_position.y:
				player.jump()
				last_jumped = Time.get_ticks_msec()
