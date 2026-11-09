extends Node3D

const Rules = preload("res://scripts/driving_rules.gd")
const Car = preload("res://scripts/car.gd")
const TERRAIN_HALF := 88.0
const TERRAIN_STEPS := 44
const RECORD_PATH := "user://rally_best_time.txt"

var car: DuneRallyCar
var camera: Camera3D
var hud: Label
var elapsed := 0.0
var last_checkpoint_time := 0.0
var last_split := 0.0
var medal := ""
var best_time := -1.0
var new_record := false
var next_checkpoint := 0
var finished := false
var checkpoints := [
	Vector2(23, -22),
	Vector2(47, 8),
	Vector2(8, 40),
	Vector2(-36, 12),
	Vector2(0, -13)
]


func _ready() -> void:
	_load_best_time()
	_create_environment()
	_create_terrain()
	_create_landmarks()
	_create_checkpoints()
	car = Car.new()
	car.position = Vector3(0, _height(0, 0) + 3.0, 0)
	add_child(car)
	camera = Camera3D.new()
	camera.fov = 72.0
	camera.current = true
	add_child(camera)
	camera.position = Vector3(0, 10, 17)
	camera.look_at(car.global_position)
	var layer := CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(27, 23)
	hud.add_theme_font_size_override("font_size", 24)
	hud.add_theme_color_override("font_color", Color("#fff4dd"))
	layer.add_child(hud)
	_refresh_hud()


func _height(x: float, z: float) -> float:
	return 2.8 * sin(x * 0.088) * cos(z * 0.072) + 1.2 * sin((x + z) * 0.045)


func _create_environment() -> void:
	var world := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("#e4b98c")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#ffd9ad")
	env.fog_enabled = true
	env.fog_light_color = Color("#cfa475")
	env.fog_density = 0.007
	world.environment = env
	add_child(world)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, 35, 0)
	sun.light_color = Color("#ffe0a1")
	sun.light_energy = 1.35
	add_child(sun)


func _create_terrain() -> void:
	var tool := SurfaceTool.new()
	tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	var step := TERRAIN_HALF * 2.0 / float(TERRAIN_STEPS)
	for iz in range(TERRAIN_STEPS):
		for ix in range(TERRAIN_STEPS):
			var x0 := -TERRAIN_HALF + float(ix) * step
			var z0 := -TERRAIN_HALF + float(iz) * step
			var x1 := x0 + step
			var z1 := z0 + step
			var a := Vector3(x0, _height(x0, z0), z0)
			var b := Vector3(x1, _height(x1, z0), z0)
			var c := Vector3(x0, _height(x0, z1), z1)
			var d := Vector3(x1, _height(x1, z1), z1)
			tool.add_vertex(a)
			tool.add_vertex(c)
			tool.add_vertex(b)
			tool.add_vertex(b)
			tool.add_vertex(c)
			tool.add_vertex(d)
	tool.generate_normals()
	var mesh := tool.commit()
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("#d4ae70")
	material.roughness = 1.0
	var terrain_body := StaticBody3D.new()
	terrain_body.name = "ProceduralSandDunes"
	add_child(terrain_body)
	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	visual.material_override = material
	terrain_body.add_child(visual)
	var collider := CollisionShape3D.new()
	collider.shape = mesh.create_trimesh_shape()
	terrain_body.add_child(collider)


func _add_prop(mesh: Mesh, position: Vector3, color: Color) -> void:
	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	visual.position = position
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 1.0
	visual.material_override = mat
	add_child(visual)


func _create_landmarks() -> void:
	for i in range(30):
		var angle := float(i) * TAU / 30.0
		var distance := 19.0 + float((i * 13) % 48)
		var x := sin(angle) * distance
		var z := cos(angle) * distance
		var stone := SphereMesh.new()
		stone.radius = 0.6 + float(i % 4) * 0.35
		stone.height = stone.radius * 1.4
		_add_prop(stone, Vector3(x, _height(x, z) + 0.25, z), Color("#a9815f"))


func _create_checkpoints() -> void:
	for index in range(checkpoints.size()):
		var spot: Vector2 = checkpoints[index]
		var color := Color("#4af5df") if index == 0 else Color("#fae68c")
		var beacon := CylinderMesh.new()
		beacon.top_radius = 0.35
		beacon.bottom_radius = 0.35
		beacon.height = 5.0
		_add_prop(beacon, Vector3(spot.x, _height(spot.x, spot.y) + 2.5, spot.y), color)
		var topper := SphereMesh.new()
		topper.radius = 1.1
		topper.height = 2.2
		_add_prop(topper, Vector3(spot.x, _height(spot.x, spot.y) + 5.4, spot.y), color)


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
		return
	if not finished:
		elapsed += delta
		var spot: Vector2 = checkpoints[next_checkpoint]
		var distance := Vector2(car.global_position.x, car.global_position.z).distance_to(spot)
		if Rules.reached_checkpoint(distance):
			last_split = Rules.split_seconds(last_checkpoint_time, elapsed)
			last_checkpoint_time = elapsed
			next_checkpoint += 1
			if next_checkpoint == checkpoints.size():
				finished = true
				medal = Rules.medal_for_time(elapsed)
				if Rules.beats_record(elapsed, best_time):
					new_record = true
					best_time = elapsed
					_save_best_time()
	_refresh_hud()
	if is_instance_valid(camera) and is_instance_valid(car):
		var offset := car.global_transform.basis.z * 12.0 + Vector3(0, 6.0, 0)
		camera.global_position = camera.global_position.lerp(car.global_position + offset, clampf(delta * 2.1, 0.0, 1.0))
		camera.look_at(car.global_position + Vector3.UP * 1.6)


func _refresh_hud() -> void:
	if not is_instance_valid(hud):
		return
	var checkpoint_text := "CONCLUIDO" if finished else "%d / %d" % [next_checkpoint + 1, checkpoints.size()]
	var message := "RALLY FINALIZADO! R: REINICIAR" if finished else "SIGA OS MARCADORES"
	if finished and new_record:
		message = "NOVO RECORDE PESSOAL! R: REINICIAR"
	var split_text := "MEDALHA: %s" % medal if finished else "ULTIMO TRECHO: %.1f s" % last_split
	var record_text := "%.1f s" % best_time if Rules.valid_record_time(best_time) else "SEM REGISTRO"
	var guide := "TODOS OS CHECKPOINTS CONCLUIDOS"
	if not finished:
		var spot: Vector2 = checkpoints[next_checkpoint]
		var current := Vector2(car.global_position.x, car.global_position.z)
		var to_target: Vector2 = spot - current
		var facing := -car.global_transform.basis.z
		var forward := Vector2(facing.x, facing.z)
		guide = "PROXIMO PORTAL: %.0f m / %s" % [to_target.length(), Rules.checkpoint_direction(forward, to_target)]
	hud.text = "RALLY DUNAS RN  •  PROTOTIPO\nVELOCIDADE: %d km/h    CHECKPOINT: %s\nTEMPO: %.1f s       %s\n%s\n%s\nRECORDE PESSOAL: %s\nWASD / SETAS: DIRIGIR       R: REINICIAR" % [
		Rules.speed_kmh(car.speed), checkpoint_text, elapsed, message, split_text, guide, record_text
	]

func _load_best_time() -> void:
	if not FileAccess.file_exists(RECORD_PATH):
		return
	var file := FileAccess.open(RECORD_PATH, FileAccess.READ)
	if file == null:
		return
	var loaded: float = file.get_as_text().strip_edges().to_float()
	if Rules.valid_record_time(loaded):
		best_time = loaded


func _save_best_time() -> void:
	var file := FileAccess.open(RECORD_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string("%.3f" % best_time)
