extends Node2D

var level: int = 0
var xp: int = 0
var round_number: int = 0
const DEF_SLAMMER: PackedScene = preload("res://assets/disks/slammer.tscn")
const DEF_DISK: PackedScene = preload("res://assets/disks/disk.tscn")
var slammer: Slammer = null
var deck: Array[Disk] = []
var deck_size: int = 8
var disks_in_play: Array[Disk] = []
var slammer_hits: int = 0
var hits: float = 0
var total_hits: float = 0
var points: float = 0
var time_since_flick: int = 0
var time_since_last_hit: int = 0
var flick_timer: bool = false
var hit_timer: bool = false

func _ready() -> void:
	if not slammer or slammer == null:
		var default_slammer = DEF_SLAMMER.instantiate()
		slammer = default_slammer
		add_child(slammer)
		slammer.global_position = Vector2()
		slammer.disk_hit.connect(_on_slammer_hit)
		slammer.slammer_flicked.connect(_on_slammer_flicked)
	make_test_deck_by_array()
	pass # Replace with function body.

func _process(delta: float) -> void:
	if hit_timer:
		time_since_last_hit += 1
	if flick_timer:
		time_since_flick += 1

func _on_slammer_hit(disk, hit_by) -> void:
	print('slammer')
	if not hit_timer:
		hit_timer = true
		time_since_last_hit = 0
	slammer_hits += 1
	points += disk.points_per_hit

func _on_slammer_flicked() -> void:
	print('flicked')
	if not flick_timer:
		flick_timer = true
		time_since_flick = 0

func _on_disk_hit(disk, hit_by) -> void:
	print("%s hit by %s" % [disk, hit_by])
	if not hit_timer:
		hit_timer = true
		time_since_last_hit = 0
	if hit_by.is_in_group("disk"):
		print("add 0.5 pts")
		hits += 0.5
		points += disk.points_per_hit/2
	else:
		print("add 1 pts")
		hits += 1
		points += disk.points_per_hit
	#gotta decide how you get points
	# points when  hit?
	# how to deal with 2 things hitting each other (a 2 points and a 3 points = 5 points?)
	# maybe adjust physics so slammer moves crazy and other disks don't

func random_position() -> Vector2:
	var rng = RandomNumberGenerator.new()
	var rand_x: int = rng.randf_range(-256, 256)
	var rand_y: int = rng.randf_range(-256, 256)
	return Vector2(rand_x, rand_y)

func next_round(prev_round) -> void:
	round_number += 1

func make_test_deck() -> void:
	var disk_1 = DEF_DISK.instantiate()
	var disk_2 = DEF_DISK.instantiate()
	var disk_3 = DEF_DISK.instantiate()
	var disk_4 = DEF_DISK.instantiate()
	add_child(disk_1)
	add_child(disk_2)
	add_child(disk_3)
	add_child(disk_4)
	disk_1.global_position = Vector2(128, 128)
	disk_2.global_position = Vector2(-128, -128)
	disk_3.global_position = Vector2(-128, 128)
	disk_4.global_position = Vector2(128, -128)
	disk_1.disk_hit.connect(_on_disk_hit)
	disk_2.disk_hit.connect(_on_disk_hit)
	disk_3.disk_hit.connect(_on_disk_hit)
	disk_4.disk_hit.connect(_on_disk_hit)

func make_test_deck_by_array() -> void:
	var test_size = 8
	var test_deck: Array[Disk] = []
	for i in test_size:
		var disk = DEF_DISK.instantiate()
		test_deck.append(disk)
		add_child(disk)
		disk.disk_hit.connect(_on_disk_hit)
		disk.global_position = random_position()
		print(disk.get_groups())
