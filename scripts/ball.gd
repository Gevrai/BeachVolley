extends RigidBody2D

func _ready() -> void:
	var end = gravity_scale
	gravity_scale = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "gravity_scale", end, 2)
