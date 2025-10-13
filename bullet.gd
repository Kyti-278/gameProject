# bullet.gd
extends CharacterBody2D

@export var speed: float = 500.0
@export var lifetime: float = 3.0
@export var direction: Vector2 = Vector2.RIGHT

func _ready():
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

func _on_timer_timeout():
	queue_free()
