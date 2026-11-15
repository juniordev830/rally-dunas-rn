extends CharacterBody3D
class_name DuneRallyCar

const Rules = preload("res://scripts/driving_rules.gd")

var speed := 0.0


func _ready() -> void:
	floor_snap_length = 0.65
	var hitbox := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.1, 1.2, 4.2)
	hitbox.position.y = 1.1
	hitbox.shape = shape
	add_child(hitbox)
	var chassis := BoxMesh.new()
	chassis.size = Vector3(2.1, 0.85, 4.0)
	_part(chassis, Vector3(0, 1.05, 0), Vector3.ZERO, Color("#e84839"))
	var roof := BoxMesh.new()
	roof.size = Vector3(1.55, 0.75, 1.9)
	_part(roof, Vector3(0, 1.77, 0.20), Vector3.ZERO, Color("#ffc452"))
	var glass := BoxMesh.new()
	glass.size = Vector3(1.4, 0.42, 0.15)
	_part(glass, Vector3(0, 1.70, -0.81), Vector3.ZERO, Color("#3a9dba"))
	for x in [-1.08, 1.08]:
		for z in [-1.28, 1.28]:
			var wheel := CylinderMesh.new()
			wheel.top_radius = 0.48
			wheel.bottom_radius = 0.48
			wheel.height = 0.30
			_part(wheel, Vector3(x, 0.57, z), Vector3(0, 0, PI / 2.0), Color("#1c252b"))


func _part(mesh: Mesh, offset: Vector3, angles: Vector3, tint: Color) -> void:
	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	visual.position = offset
	visual.rotation = angles
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = 0.62
	material.metallic = 0.18
	visual.material_override = material
	add_child(visual)


func _physics_process(delta: float) -> void:
	var throttle := 0.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		throttle += 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		throttle -= 1.0
	speed = Rules.next_speed(speed, throttle, delta)
	var steer := 0.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		steer += 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		steer -= 1.0
	if absf(speed) > 0.6:
		rotation.y += steer * delta * 1.25 * signf(speed)
	var facing := -global_transform.basis.z
	velocity.x = facing.x * speed
	velocity.z = facing.z * speed
	if is_on_floor():
		velocity.y = -0.15
	else:
		velocity.y -= 24.0 * delta
	move_and_slide()
	global_position.x = clampf(global_position.x, -82.0, 82.0)
	global_position.z = clampf(global_position.z, -82.0, 82.0)
