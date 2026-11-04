extends RefCounted
## Arcade driving rules independent from physics and 3D rendering.

static func next_speed(current: float, throttle: float, delta: float) -> float:
	if delta < 0.0 or not is_finite(delta) or not is_finite(current) or not is_finite(throttle):
		return 0.0
	var speed := current
	if throttle > 0.0:
		speed += clampf(throttle, 0.0, 1.0) * 16.0 * delta
	elif throttle < 0.0:
		speed += clampf(throttle, -1.0, 0.0) * 21.0 * delta
	else:
		speed = move_toward(speed, 0.0, 9.0 * delta)
	return clampf(speed, -10.0, 29.0)


static func reached_checkpoint(distance: float, radius: float = 6.0) -> bool:
	return is_finite(distance) and distance >= 0.0 and radius >= 0.0 and distance <= radius


static func speed_kmh(meters_per_second: float) -> int:
	return int(round(absf(meters_per_second) * 3.6))
