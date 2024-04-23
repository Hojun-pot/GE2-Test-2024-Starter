@tool
extends Node3D

@export var Length : float
@export var StartAngle : float
@export var Frequency : float
@export var BaseSize : float
@export var Mult : float
@export var HeadScene : PackedScene
@export var BodyScene : PackedScene

var head_instance
var body_instances = []
func _ready():
	if not Engine.is_editor_hint():
		create_creature()

func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	update_creature(time)
	draw_gizmos()

func update_creature(time):
	var angle = StartAngle
	var angle_increment = 2 * PI * Frequency / Length
	for i in range(len(body_instances)):
		var size = BaseSize + sin(angle + time * Frequency) * BaseSize * Mult
		body_instances[i].scale = Vector3(size, size, size)
		body_instances[i].position = Vector3(i * size, 0, 0) 
		angle += angle_increment

func create_creature():
	head_instance = HeadScene.instantiate()
	add_child(head_instance)
	head_instance.position = Vector3(0, 0, 0)  
	head_instance.set("paused", true)

	var previous_instance = head_instance  

	for i in range(Length):
		var body_instance = BodyScene.instantiate()
		var size = BaseSize + sin(StartAngle + i * 2 * PI * Frequency / Length) * BaseSize * Mult
		body_instance.scale = Vector3(size, size, size)  
		body_instance.position = Vector3(previous_instance.position.x + size, 0, 0)
		head_instance.add_child(body_instance)  
		body_instances.append(body_instance)  
		previous_instance = body_instance  
		
func _input(event):
	if event.is_action_pressed("p"):
		head_instance.set("paused", not head_instance.get("paused"))	

func draw_gizmos():
	#var size = BaseSize + sin(StartAngle) * BaseSize * Mult
	#draw_cube(position, Vector3(size, size, size), Color(0.8, 0.4, 0.2))
	DebugDraw3D.draw_line(transform.origin, transform.origin + transform.basis.z * 10.0, Color(0, 0, 1))
	DebugDraw3D.draw_line(transform.origin, transform.origin + transform.basis.x * 10.0, Color(1, 0, 0))
	DebugDraw3D.draw_line(transform.origin, transform.origin + transform.basis.y * 10.0, Color(0, 1, 0))
	# DebugDraw3D.draw_line(transform.origin, transform.origin + (force * 20), Color(1, 1, 0))
	# DebugDraw3D.draw_box(sphere_pos, Vector3(1, 2, 1), Color(0, 1, 0))
	# DebugDraw3D.draw_line(line_begin, line_end, Color(1, 1, 0))

