extends MeshInstance3D

var TILE_SIZE = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
	generate_plane(Vector2(0, 0))

func generate_plane(pos: Vector2) -> void:
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	# Define vertices for rectangle
	verts = PackedVector3Array([
		Vector3(pos.x, 0, pos.y),
		Vector3(pos.x, 0, pos.y + TILE_SIZE),
		Vector3(pos.x + TILE_SIZE, 0, 0),
		Vector3(pos.x + TILE_SIZE, 0, pos.y + TILE_SIZE)
	])
	
	uvs = PackedVector2Array([
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(1, 1)
	])
	
	normals = PackedVector3Array([
		Vector3.UP,
		Vector3.UP,
		Vector3.UP,
		Vector3.UP
	])
	
	indices = PackedInt32Array([
		0, 2, 1,
		2, 3, 1
	])
	
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	# No blendshapes, lods, or compression used.
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
