extends MeshInstance3D

var TILE_SIZE = 1000.0

var plane := PlaneMesh.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
	plane.size = Vector2(TILE_SIZE, TILE_SIZE)
	
	mesh = plane
	
	mesh.subdivide_depth = 200
	mesh.subdivide_width = 200
	
	var arrays = mesh.get_mesh_arrays()
	var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	
		
	var colors := PackedColorArray()
	colors.resize(vertices.size())
	
	var large = FastNoiseLite.new()
	large.noise_type = FastNoiseLite.TYPE_PERLIN
	large.frequency = 0.02

	var detail = FastNoiseLite.new()
	detail.noise_type = FastNoiseLite.TYPE_CELLULAR
	detail.fractal_gain = 5.0
	detail.frequency = 0.001

	var carve = FastNoiseLite.new()
	carve.noise_type = FastNoiseLite.TYPE_SIMPLEX
	carve.fractal_octaves = 4
	carve.frequency = 0.03

	for i in vertices.size():
		var v = vertices[i]
		var height = large.get_noise_2d(v.x, v.z) * 2
		height += detail.get_noise_2d(v.x, v.z) * 5
		height -= carve.get_noise_2d(v.x, v.z)
		
		v.y = height
		vertices[i] = v
		
		# Random-ish green variation based on another noise sample
		var green = Color(0.243 / 2, 0.325 / 2, 0.039 / 2, 1.0)
		var brown = Color(0.416 / 2, 0.337 / 2, 0.161 / 2, 1.0)
		var brown2 = Color(0.388 / 2, 0.286 / 2, 0.082 / 2, 1.0)
		var green2 = Color(0.443 / 2, 0.426 / 2, 0.164 / 2, 1.0)

		colors[i] = [green, brown, green2, brown2].pick_random()
	
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_COLOR] = colors
	
	var st := SurfaceTool.new()
	st.create_from_arrays(arrays)
	st.generate_normals()
	
	mesh = st.commit()
	
	var material = StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	mesh.surface_set_material(0, material)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
