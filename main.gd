extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	# Choose a random locaiton on the SpawnPath and store its reference
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# randf() produces a number between 0 and 1, which is what the Path Follow
	# node's expect: 0 is the start of the path and 1 is the end of it.
	mob_spawn_location.progress_ratio = randf()
	
	# Get the player's actual position and call initialize method on Mob's
	# scene
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# Spawn the Mob by adding it to the Main scene
	add_child(mob)
