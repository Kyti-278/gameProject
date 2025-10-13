extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false
var speed = 200 
@onready var anim = $AnimatedSprite2D


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():	
		velocity.y += gravity * delta
	var player = $"../../Player2/Player"
	var direction = (player.position - self.position).normalized()
	if chase == true:
		velocity.x = direction.x * speed 
		anim.play("run")
	else:
		velocity.x = 0
		anim.play("Idle")
	if direction.x <0:
		$AnimatedSprite2D.flip_h = true
	elif direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	move_and_slide()

func _on_detector_body_entered(body):
	if body.name == "Player":
		chase = true 


func _on_detector_body_exited(body):
	if body.name == "Player":
		chase = false 
	pass # Replace with function body.


func _on_damag_body_entered(body):
	if body.name == "Player":
		body.health -= 4
