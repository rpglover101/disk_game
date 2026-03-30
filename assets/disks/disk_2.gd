extends RigidBody2D

var is_dragging: bool = false
var mouse_on: bool = false
var flick_power = 100
var drag_distance: float = 0
var drag_direction := Vector2.ZERO
var time_since_last_hit: float = 0
var hit_timer := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton: 
		print("click")
		if event.is_pressed() and mouse_on:
			print("drag")
			is_dragging = true
		elif is_dragging:
			var velocity: Vector2 =  drag_direction * drag_distance * flick_power
			is_dragging = false
			input_pickable = false
			time_since_last_hit = 0
			apply_force(velocity)
			$CollisionShape2D.modulate = Color.RED

func _physics_process(delta) -> void:
	if hit_timer:
		time_since_last_hit += 1
	if is_dragging:
		drag_direction = get_global_mouse_position().direction_to(global_position)
		drag_distance = get_global_mouse_position().distance_to(global_position)
		print(drag_distance)
		# if you want to do something while dragging, put it here
	if not input_pickable and linear_velocity.abs() < Vector2(5, 5):
		if time_since_last_hit > 150 and linear_velocity.abs() < Vector2(5, 5): 
			print("pickable")
			linear_velocity = Vector2(0,0)
			input_pickable = true
			$CollisionShape2D.modulate = Color.BLUE
			print("Time since last hit ", time_since_last_hit)
			time_since_last_hit = 0
			hit_timer = false

func _on_mouse_entered() -> void:
	mouse_on = true
	print('mouse_on')

func _on_mouse_exited() -> void:
	mouse_on = false
	print('mouse_off')

func _on_body_entered(body: Node) -> void:
	print("Collided with: ", body.name)
	if not hit_timer:
		hit_timer = true
	time_since_last_hit = 0
