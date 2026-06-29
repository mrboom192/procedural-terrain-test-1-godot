extends Node

@export var ground_tile: PackedScene
var tile_size: float = 100.0;
var generated := {}
var max := 1000
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
		var distance_from_center = clamp(sqrt((pos.x) ** 2 + (pos.z) ** 2) / 50, 1.0, 1000.0)
		
		ground.subdivide_levels = max(
			8,
			int(subdivide_levels / distance_from_center)
		)
		
		ground.tile_size = tile_size
		ground.position = pos
		
		ground.large = large
		ground.detail = detail
		ground.carve = carve
		
		add_child(ground)
		
		queue.push_back(Vector3(pos.x + tile_size, 0.0, pos.z))
		queue.push_back(Vector3(pos.x - tile_size, 0.0, pos.z))
		queue.push_back(Vector3(pos.x, 0.0, pos.z + tile_size))
		queue.push_back(Vector3(pos.x, 0.0, pos.z - tile_size))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
	generate_terrain()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
