extends CharacterBody2D

@export var SPEED: float = 300.0
@onready var camera: Camera2D = $Camera2D 

var is_in_cutscene: bool = false

func _ready() -> void:
	# activating the camera at the start
	camera.enabled = true

func _physics_process(_delta: float) -> void:
	if is_in_cutscene:
		return
		
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * SPEED
	move_and_slide()

# A method to track whether a cutscene is playing and detach the camera from the player. In `_physics_process`, I check if it's `false`, then the player is controlled; if `true`, control is removed.
func set_cutscene_mode(enabled: bool) -> void:
	is_in_cutscene = enabled
	# turning off the player's camera during the cutscene
	camera.enabled = !enabled
