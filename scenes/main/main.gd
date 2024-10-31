extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var lever_marker: Marker2D = $Lever
@onready var cutscene_trigger: Area2D = $CutsceneTrigger
#Here I'm creating a camera for the cutscene because I had issues with the existing one. It’s probably possible to use it, but I went for the simpler route.
@onready var cutscene_camera: Camera2D = Camera2D.new()



func _ready() -> void:
	# adding the camera for the cutscene to the scene
	add_child(cutscene_camera)
	cutscene_camera.enabled = false
	
	# connecting a signal from the trigger
	cutscene_trigger.body_entered.connect(_on_cutscene_trigger_body_entered)

# when entering the trigger, start the cutscene
func _on_cutscene_trigger_body_entered(body: Node2D) -> void:
	start_cutscene()



func start_cutscene() -> void:

	player.set_cutscene_mode(true)  # Disables the player's camera and sets their marker to indicate they're in a cutscene, disabling their controls.
	
	# The cutscene camera is activated.
	cutscene_camera.enabled = true
	cutscene_camera.position = player.position
	
	# starting the camera movement
	move_camera_to_lever()

func move_camera_to_lever() -> void:
	var tween = create_tween()
	
# Here I'm using a Tween
# Tween is an object that allows for smooth property changes over time
# https://docs.godotengine.org/en/4.3/classes/class_tween.html
	
	# camera movement towards the marker
	tween.tween_property(cutscene_camera, "position", lever_marker.position, 2.0)\
		 .set_trans(Tween.TRANS_CUBIC)\
		 .set_ease(Tween.EASE_IN_OUT)
	
	# pause at the marker
	tween.tween_interval(1.0)
	
	# returning the camera to the player
	tween.tween_property(cutscene_camera, "position", player.position, 2.0)\
		 .set_trans(Tween.TRANS_CUBIC)\
		 .set_ease(Tween.EASE_IN_OUT)
	
	# calling the end of the cutscene after all animations
	tween.tween_callback(end_cutscene)

func end_cutscene() -> void:
	player.set_cutscene_mode(false)  # turns the player's camera and controls back on
	cutscene_camera.enabled = false  # disables the cutscene camera
