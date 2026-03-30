extends RichTextLabel

@export var game_controller: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Slammer Hits: %d 
	\n Disk Hits: %d
	\n Points: %d" % [game_controller.slammer_hits, game_controller.hits, game_controller.points]
	pass
