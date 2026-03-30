class_name Slammer
extends Disk
#test change
var is_dragging: bool = false
var flick_power: int = 200
var drag_distance: float = 0
var drag_direction: Vector2 = Vector2.ZERO
var time_since_last_hit: int = 0
var hit_timer: bool = false
const DEF_SPRITE: CompressedTexture2D = preload("res://assets/disks/slammer.png")
var sprite: CompressedTexture2D = null
var hits: int = 0
var time_since_flick: int = 0
var flicked: bool = false
const DEF_POINTS_PER_HIT: int = 0
var max_speed: float = 100.0

signal slammer_flicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points_per_hit = 0
	contact_monitor = true
	max_contacts_reported = 4
	sprite = DEF_SPRITE
	$Sprite2D.texture = sprite

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
			$HitBox.modulate = Color.RED
			flicked = true
			slammer_flicked.emit()

func _physics_process(delta) -> void:
	if flicked:
		time_since_flick += 1
	if hit_timer:
		time_since_last_hit += 1
		#print(time_since_last_hit)
	if is_dragging:
		drag_direction = get_global_mouse_position().direction_to(global_position)
		drag_distance = get_global_mouse_position().distance_to(global_position)
		#print(drag_distance)
	if flicked:
		$Sprite2D.modulate = Color.WHITE
		if not input_pickable and linear_velocity.abs() < Vector2(5, 5): #check if going very slow
			if time_since_last_hit > 200: #must have hit something
				make_pickable()
			elif hits == 0 and time_since_flick > 200: #no hit (bad flick)
				print("force pick")
				make_pickable()
	linear_velocity = lerp(linear_velocity, Vector2.ZERO, friction) #friction

func _on_mouse_exited() -> void:
	print("mouse off ", name)
	mouse_on = false
	if is_dragging == true:
		$Sprite2D.modulate = Color.GREEN
	else:
		$Sprite2D.modulate = Color.WHITE

func _on_body_entered(body: Node) -> void:
	disk_hit.emit(self, body)
	print('slammer was hit')
	if body.is_in_group("disk") and linear_velocity.length() < max_speed:
		print('speed ', linear_velocity)
		linear_velocity *= Vector2(10,10)
	pass # Replace with function body.

func make_pickable() -> void:
	$Sprite2D.modulate = Color.BLUE
	print("pickable")
	linear_velocity = Vector2(0,0)
	input_pickable = true
	time_since_last_hit = 0
	hit_timer = false
	hits = 0
	time_since_flick = 0
	flicked = false
