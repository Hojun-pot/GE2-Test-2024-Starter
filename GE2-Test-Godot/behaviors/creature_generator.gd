@tool
extends Node3D

var Length : float
@export var StartAngle : float
@export var Frequency : float
@export var BaseSize : float
@export var Mult : float
@export var HeadScene : PackedScene
@export var BodyScene : PackedScene

var force = 5
var sphere_pos

func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	sphere_pos = Vector3(0, sin(time * 4), 0)
	draw_gizmos()

func _ready():
	if not Engine.is_editor_hint():
		create_creature()

func draw_gizmos():
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

