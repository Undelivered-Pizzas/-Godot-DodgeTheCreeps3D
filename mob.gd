extends CharacterBody3D

# Min and max speed of the mob in meters per second
@export var min_speed = 10
@export var max_speed = 18

func _physics_process(delta):
	move_and_slide()

func initialize(start_position, player_position):
	# Place the mob in the start position and rotate it towards the player_position
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Then we randomly rotate the mob between -45 and +45 degrees
	# so it doesn't move directly to the player.
	rotate_y(randf_range(-PI/4, PI/4))

	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
