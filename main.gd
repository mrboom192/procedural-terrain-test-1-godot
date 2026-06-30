extends Node

@export var ground_tile: PackedScene
var tile_size: float = 100.0
var generated := {}
var max := 5000
var subdivide_levels = 200

func generate_terrain() -> void:
	var queue: Array = [Vector3(0.0, 0.0, 0.0)]
	var i = 0
	
	var large = FastNoiseLite.new()
	large.noise_type = FastNoiseLite.TYPE_PERLIN
	large.fractal_octaves = 6.0
	large.frequency = 0.00075

	var detail = FastNoiseLite.new()
	detail.noise_type = FastNoiseLite.TYPE_CELLULAR
	detail.frequency = 0.01

	var carve = FastNoiseLite.new()
	carve.noise_type = FastNoiseLite.TYPE_SIMPLEX
	carve.fractal_octaves = 4
	carve.frequency = 0.03
	
	while i < max:
		var pos = queue.pop_front()
		if generated.has(pos):
			continue
		
		i += 1
		
		generated[pos] = true
		
		var ground = ground_tile.instantiate()
		var distance_from_center = sqrt((pos.x) ** 2 + (pos.z) ** 2)
		
		ground.subdivide_levels = max(
			8,
			int(subdivide_levels / clamp(distance_from_center / 50, 1.0, 1000.0))
		)
		
		ground.tile_size = tile_size
		ground.position = pos
		
		ground.large = large
		ground.detail = detail
		ground.carve = carve
		
		add_child(ground)
		
		var up = Vector3(pos.x, 0.0, pos.z - tile_size)
		var down = Vector3(pos.x, 0.0, pos.z + tile_size)
		var left = Vector3(pos.x - tile_size, 0.0, pos.z)
		var right = Vector3(pos.x + tile_size, 0.0, pos.z)
		
		if !generated.has(up):
			queue.push_back(up)
		
		if !generated.has(down):
			queue.push_back(down)
			
		if !generated.has(left):
			queue.push_back(left)
			
		if !generated.has(right):
			queue.push_back(right)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
	generate_terrain()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
