extends SceneTree
const Rules = preload("res://scripts/driving_rules.gd")

func _initialize() -> void:
	assert(Rules.next_speed(0.0, 1.0, 1.0) == 16.0)
	assert(Rules.next_speed(28.0, 1.0, 1.0) == 29.0)
	assert(Rules.next_speed(0.0, -1.0, 1.0) == -10.0)
	assert(Rules.next_speed(10.0, 0.0, 0.5) == 5.5)
	assert(Rules.next_speed(10.0, 1.0, -1.0) == 0.0)
	assert(Rules.reached_checkpoint(6.0))
	assert(not Rules.reached_checkpoint(6.1))
	assert(Rules.speed_kmh(10.0) == 36)
	print("Driving rules: 8 assertions passed")
	quit()
