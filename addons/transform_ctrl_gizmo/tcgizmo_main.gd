class_name TCGizmoTop
extends Node3D


signal gizmo_rotate(x:float, y:float, z:float, is_relative:bool)
signal gizmo_translate(x:float, y:float, z:float, is_relative:bool)
signal gizmo_scaling(x:float, y:float, z:float, is_relative:bool)



@export var is_relative: bool = false
@export var is_translation: bool
@export var is_rotation: bool
#@export var is_scale: bool
@export var is_selfhost: bool = false
@export var target: Node3D = null
@export var current_camera: Camera3D
# show position offset
@export var show_offset: Vector3 = Vector3.ZERO
@export var target_receiver: TransformCtrlGizmoReceiver

var savemat = []

const base_distance = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#if target == null:
	#	target = get_parent_node_3d()
		
	#current_camera = %MainCamera
	
	setup_meshObject()

func _exit_tree() -> void:
	for m in savemat:
		pass
		#m.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if !is_selfhost:
		if target != null:
			position.x = target.position.x + target_receiver.show_offset.x + show_offset.x
			position.y = target.position.y + target_receiver.show_offset.y + show_offset.y
			position.z = target.position.z + target_receiver.show_offset.z + show_offset.z
			rotation = target.rotation
			
			#---change this gizmo size by distance to main camera
			var glodist = current_camera.global_position - global_position
			#print("glodist=",glodist.length())
			var basesize = (glodist.length() * 0.2)
			#print("basesize=",basesize)
			if basesize < 0.3:
				basesize = 0.3
			#if basesize > 5:
			#	basesize = basesize * 0.5
				
			scale.x = 1#basesize
			scale.y = 1#basesize
			scale.z = 1#basesize
			
				
	
func setup(cam:Camera3D):
	current_camera = cam
	setup_meshObject()


func setup_meshObject():
	var colgreen = [
		Color(0, 1, 0, 1),
		Color(0, 0.7, 0, 1)
	]
	var colblue = [
		Color(0, 0, 1, 1),
		Color(0, 0, 0.7, 1)
	]
	var colred = [
		Color(1, 0, 0, 1),
		Color(0.7, 0, 0, 1)
	]
	var cs = get_children()
	for obj in cs:
		var meshobj:CSGPrimitive3D = obj
		var axisname = obj #.get_child(0)
		var axistype = obj.get_class().get_basename()
		var mat:StandardMaterial3D = StandardMaterial3D.new()
		mat.set("transparency",StandardMaterial3D.TRANSPARENCY_ALPHA)
		mat.set("shading_mode",StandardMaterial3D.SHADING_MODE_UNSHADED)
		if axistype == "CSGMesh3D":
			if axisname.axis.y == 0:
				mat.set("albedo_color",colgreen[0])
			elif axisname.axis.x == 0:
				mat.set("albedo_color",colred[0])
			elif axisname.axis.z == 0:
				mat.set("albedo_color",colblue[0])
		else:
			if axisname.axis.y == 1:
				mat.set("albedo_color",colgreen[0])
			elif axisname.axis.x == 1:
				mat.set("albedo_color",colred[0])
			elif axisname.axis.z == 1:
				mat.set("albedo_color",colblue[0])
		
		obj.basecolor = mat.get("albedo_color")
		obj.selcolor = Color(1.0, 1.0, 0, 1.0)
		savemat.append(mat)
		meshobj.material_override = mat

func input_event(camera:Node, event:InputEvent, position:Vector3, normal:Vector3, shape_idx:int):
	pass

#---Receive input event ring
func input_event_axis(event:InputEvent, cur_position: Vector2, old_position: Vector2, clickpos: Vector3, axis: Vector3, transformType, is_global:bool):
	if target == null:
		return
	
	var oldpos3 = current_camera.project_ray_normal(event.position - event.relative)
	var curpos3 = current_camera.project_ray_normal(event.position)
	var EnumTrans: Array = ["translate","rotate","scale"]
	
	#print("    click=",clickpos, " <-> curpos=", curpos3)
	
	if transformType == 0: #---translate
		var diff:Vector3
		
		diff = (curpos3) - (oldpos3)
		
		print("**",oldpos3, " -> ", curpos3, " -> ", "diff=",diff)
		if diff.x > 0:
			diff.x = 0.1
		elif diff.x < 0:
			diff.x = -0.1
		if diff.y > 0:
			diff.y = 0.1
		elif diff.y < 0:
			diff.y = -0.1
		if diff.z > 0:
			diff.z = 0.1
		elif diff.z < 0:
			diff.z = -0.1
		
		var res = Vector3.ZERO
		var relXY = 0
		
		var istran = true
		
		res = diff * axis * Vector3(0.5, 0.5, 0.5)

		
		#---set by
#		if axis.x == 1:
#			if diff.x > 0.0:
#				res.x = -clickpos.x - (diff.x) 
#				istran = true
#			elif diff.x < 0.0:
#				res.x = clickpos.x + (diff.x)
#				istran = true
#			res.x = res.x * 0.1
#		else:
#			res.x = 0
#		istran = true
#		res.x = (
#			event.relative.x * forward.x  + 
#			event.relative.x * right.x  + 
#			event.relative.x * up.x  
#			#event.relative.y * forward.x + 
#			#event.relative.y * right.x + 
#			#event.relative.y * up.x
#			) * 0.01 * axis.x
		
#		if axis.y == 1:
#			if diff.y > 0.0:
#				res.y = -clickpos.y - (diff.y) 
#				istran = true
#			elif diff.y < 0.0:
#				res.y = clickpos.y + (diff.y)
#				istran = true
#			res.y = res.y * 0.1
#		else:
#			res.y = 0
#		istran = true
#		res.y = (
#			#event.relative.x * forward.y + 
#			#event.relative.x * right.y + 
#			#event.relative.x * up.y +
#			event.relative.y * forward.y  + 
#			event.relative.y * right.y   + 
#			event.relative.y * up.y 
#			) * 0.01 * axis.y
		
#		if axis.z == 1:
#			if diff.z > 0.0:
#				res.z = -clickpos.z - (diff.z)
#				istran = true
#			elif diff.z < 0.0:
#				res.z = clickpos.z + (diff.z)
#				istran = true
#			res.z = res.z * 0.1
#		else:
#			res.z = 0
#		istran = true
#		res.z = (
#			event.relative.x * forward.z + 
#			event.relative.x * right.z  + 
#			event.relative.x * up.z  +
#			event.relative.y * forward.z  + 
#			event.relative.y * right.z  + 
#			event.relative.y * up.z 
#			) * 0.01 * axis.z
		
		#print("  translate",res)
		if istran == true:
			#target.transform = target.transform.translated_local(res)
			if is_global == true:
				target.global_translate(res)
#				target.global_position.x = target.global_position.x + res.x
#				target.global_position.y = target.global_position.y + res.y
#				target.global_position.z = target.global_position.z + res.z
			else:
				target.translate(res)
#				target.position.x = target.position.x + res.x
#				target.position.y = target.position.y + res.y
#				target.position.z = target.position.z + res.z
			print("target=", target.name, ",  transformed position",target.position)
		
	elif transformType == 1: #---rotation
		var res = Vector3.ZERO
		var relXY = event.relative.x + event.relative.y
		if axis.x == 1:
			res.x = -target.rotation.x + relXY * 0.1
		if axis.y == 1:
			res.y = -target.rotation.y + relXY * 0.1
		if axis.z == 1:
			res.z = target.rotation.z + relXY * 0.1
		
		target.transform = target.transform.rotated_local(axis, relXY * 0.01)

func _emit_gizmo_rotate(x, y, z) -> void:
	gizmo_rotate.emit(x, y, z, is_relative)
