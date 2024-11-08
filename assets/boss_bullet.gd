extends Node3D

const SPEED = 60.0
@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D
var hit = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if not hit:
		if ray.is_colliding():
			hit = true
			if ray.get_collider().is_in_group("player"):
				$hit_sound.play()
				
				ray.get_collider().hit(10)
				particles.emitting = true
			mesh.visible = false
			
			#print("hello world")
			await get_tree().create_timer(1.0).timeout
			queue_free()

func _on_timer_timeout():
	queue_free()
