@tool
extends Node3D

@export var Length : float	
@export var StartAngle : float
@export var Frequency : float
@export var BaseSize : float
@export var Multiplier : float
@export var HeadScene : PackedScene
@export var BodyScene : PackedScene
var force = 5
func _process(delta):
	draw_gizmos()

func _ready():
	if not Engine.is_editor_hint():
		create_creature()

func draw_gizmos():
	DebugDraw3D.draw_line(transform.origin,  transform.origin + transform.basis.z * 10.0 , Color(0, 0, 1))
	DebugDraw3D.draw_line(transform.origin,  transform.origin + transform.basis.x * 10.0 , Color(1, 0, 0))
	DebugDraw3D.draw_line(transform.origin,  transform.origin + transform.basis.y * 10.0 , Color(0, 1, 0))
	DebugDraw3D.draw_line(transform.origin, transform.origin + (force * 20), Color(1, 1, 0))
	

func create_creature():
	var head = HeadScene.instance()
	var body = BodyScene.instance()

	head.size = BaseSize
	body.size = BaseSize * Multiplier

	head.add_child(Boid.new())
	
	head.add_child(Harmonic.new())
	head.add_child(NoiseWander.new())
	
	head.paused = true

	for i in range(Frequency):
		var segment = CSGBox3D.new()
		segment.size = remap(i, 0, Frequency, BaseSize, BaseSize * Multiplier)
		segment.translation = Vector3(0, 0, i * Length / Frequency)
		add_child(segment)
		segment.add_child(head)
		segment.add_child(body)

