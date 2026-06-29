extends Node

@export var ground_tile: PackedScene
var tile_size: float = 100.0;
var generated := {}
var max := 250
var subdivide_levels = 200

func generate_terrain() -> void:
	var queue: Array = [Vector3(0.0, 0.0, 0.0)]
	var i = -1
	
	while i < max:
		var pos = queue.pop_front()
		if generated.has(pos):
			continue
		
		i += 1
		
		generated[pos] = true
		
		var ground = ground_tile.instantiate()
		ground.subdivide_levels = subdivide_levels / ((i * 1.25) + 1)
		ground.tile_size = tile_size
		ground.position = pos
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
