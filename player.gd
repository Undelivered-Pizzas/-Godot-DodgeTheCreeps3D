extends CharacterBody3D

# Emitted when the enemy was hit by a mob.
signal hit

# How fast the player moves in meters per second
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared
@export var fall_acceleration = 75
# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 20
# Vertical impulse applied to the character upon bouncing over a mob in
# meters per second.
@export var bounce_impulse = 16



# A 3D vector combining speed with direction, it'll be reused across frames
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# Local variable to store the input direction
	var direction = Vector3.ZERO
	
	# Note that in 3D we use vector's x and z axes, because these XZ are the
	# ground plane
	if Input.is_action_pressed("move_right"):
		direction.x	+= 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	# Prevent player to be faster in diagonal with normalized()
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node
		# Basis is a 3x3 matrix that represents XYZ axes, and determine rotation, scale and shear
		$Pivot.basis = Basis.looking_at(direction)
		
	# Ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	# If in the air, fall towards the floor. We only apply gravity when Player is in the air.
	# is_on_floor() built-in function checks if player is in the air in this frame
	if not is_on_floor(): 
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# Iterate through all collisions that occurred this frame
	for i in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(i)
		
		# If the collision is with the ground, and we also prevent
		# calling is_in_group() on a null Node object
		if collision.get_collider() == null:
			continue

		# If the collision is with a mob.
		# is_in_group() method is available in every Node
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# We check that we are hitting it from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we can squash it and bounce.
				mob.squash()
				target_velocity.y = bounce_impulse
				break

	# Moving the character
	velocity = target_velocity
	move_and_slide()

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	die()
