class_name Disk
extends RigidBody2D

var mouse_on: bool = false
var speed: float = 58.0
var acceleration: float = 12.5
var friction: float = 0.015
var size: float = 1
const DEF_LINEAR_DAMP: float = 0.75
const DEF_GRAVITY: int = 0
const DEF_FRICTION: float = 1.5
const DEF_BOUNCE: float = 0.5
var points_per_hit: float = 1

signal disk_hit(disk: Disk, hit_by: CollisionObject2D)

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
	
func _physics_process(delta: float) -> void:
	linear_velocity = lerp(linear_velocity, Vector2.ZERO, friction)

func _on_body_entered(body: Node) -> void:
	disk_hit.emit(self, body)
	pass # Replace with function body.

func _on_mouse_entered() -> void:
	print("mouse on ", name)
	mouse_on = true
	$Sprite2D.modulate = Color.GREEN
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	print("mouse off ", name)
	mouse_on = false
	$Sprite2D.modulate = Color.WHITE
	pass # Replace with function body.
