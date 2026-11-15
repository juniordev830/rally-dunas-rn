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


## Medal thresholds are arcade goals, not real rally classifications.
static func medal_for_time(seconds: float) -> String:
	if not is_finite(seconds) or seconds < 0.0:
		return "INVALIDO"
	if seconds <= 55.0:
		return "OURO"
	if seconds <= 90.0:
		return "PRATA"
	return "BRONZE"


## Timed split between two sequential checkpoints.
static func split_seconds(start_time: float, finish_time: float) -> float:
	if not is_finite(start_time) or not is_finite(finish_time):
		return -1.0
	if start_time < 0.0 or finish_time < start_time:
		return -1.0
	return finish_time - start_time

## Personal record comparisons are kept independent from file storage.
static func valid_record_time(seconds: float) -> bool:
	return is_finite(seconds) and seconds > 0.0


static func beats_record(finish_time: float, previous_best: float) -> bool:
	if not valid_record_time(finish_time):
		return false
	return not valid_record_time(previous_best) or finish_time < previous_best

## Direction of the next checkpoint relative to the current vehicle heading.
static func checkpoint_direction(forward: Vector2, to_checkpoint: Vector2) -> String:
	if not forward.is_finite() or not to_checkpoint.is_finite():
		return "DESCONHECIDA"
	if to_checkpoint.length_squared() < 0.000001:
		return "CHEGOU"
	if forward.length_squared() < 0.000001:
		return "DESCONHECIDA"
	var heading := forward.normalized()
	var right := Vector2(-heading.y, heading.x)
	var ahead: float = heading.dot(to_checkpoint)
	var sideways: float = right.dot(to_checkpoint)
	if absf(ahead) >= absf(sideways):
		return "FRENTE" if ahead >= 0.0 else "ATRAS"
	return "DIREITA" if sideways > 0.0 else "ESQUERDA"
