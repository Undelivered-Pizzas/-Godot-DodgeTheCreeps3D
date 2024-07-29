extends CharacterBody3D

# How fast the player moves in meters per second
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared
@export var fall_acceleration = 75

# A 3D vector combining speed with direction, it'll be reused across frames
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# Local variable to store the input direction
	var direction = Vector3.ZERO
	
	# Note that in 3D we use vector's x and z axes, because these XZ are the ground plane
	if Input.is_action_pressed("move_right"):
		direction.x	+= 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node
		# Basis is a 3x3 matrix that represents XYZ axes, and determine rotation, scale and shear
		$Pivot.basis = Basis.looking_at(direction)
		
	# Ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# If in the air, fall towards the floor. We only apply gravity when Player is in the air.
	# is_on_floor() built-in function checks if player is in the air in this frame
	if not is_on_floor(): 
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# Moving the character
	velocity = target_velocity
	move_and_slide()
