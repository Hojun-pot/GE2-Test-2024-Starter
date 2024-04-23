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

func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	var sphere_pos = Vector3(0, sin(time * 4), 0)
	draw_gizmos()
	var angle_increment = 2 * PI * Frequency / Length
	for i in range(Length):
		var size = BaseSize + sin(StartAngle) * BaseSize * Mult
		StartAngle += angle_increment
	
func _ready():
	if not Engine.is_editor_hint():
		head_instance = HeadScene.instantiate()
		add_child(head_instance)
		head_instance.set("paused", true)
		#segment
		for i in range(Length):
			var body_instance = BodyScene.instantiate()
			var size = BaseSize + sin(StartAngle + i * 2 * PI * Frequency / Length) * BaseSize * Mult
			body_instance.set("size", Vector3(size, size, size))
			body_instance.set_position(Vector3(i * size, 0, 0))
			add_child(body_instance)
			body_instances.append(body_instance)
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

func create_creature():
	var head = HeadScene.instantiate()
	var body = BodyScene.instantiate()

	head.size = BaseSize
	body.size = BaseSize * Mult

	var boid = Boid.new()
	boid.add_child(CSGBox3D.new())
	head.add_child(boid)
	head.paused = true

	for i in range(Frequency):
		var segment = CSGBox3D.new()
		segment.size = remap(i, 0, Frequency, BaseSize, BaseSize * Mult)
		segment.translation = Vector3(0, 0, i * Length / Frequency)
		add_child(segment)
		segment.add_child(head)
		segment.add_child(body)
#

