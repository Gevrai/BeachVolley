extends Node2D

@onready var pivot = $Pivot

var blink_timer: SceneTreeTimer 

func _ready():
	blink_process()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var ball = get_tree().get_first_node_in_group("ball")
	if ball:
		pivot.look_at(ball.global_position)

func blink_process():
	$AnimationPlayer.play("blink")
	blink_timer = get_tree().create_timer(randi_range(2, 7))
	blink_timer.timeout.connect(blink_process)
