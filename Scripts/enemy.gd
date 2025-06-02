extends CharacterBody2D

@export var player:CharacterBody2D

@export var points:int
@export var speed:float
@export var hp:int
@export var damage:int

var isTouchingPlayer:bool = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if hp <= 0:
		die()
	
	var direction := player.position - position
	rotation = direction.angle()
	
	velocity = direction.normalized() * speed
	move_and_slide()
	
	if isTouchingPlayer:
		player.hurt(damage)

func _on_hitbox_collision(body: Node2D) -> void:
	if body.is_in_group("Player"):
		isTouchingPlayer = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		isTouchingPlayer = false

func die():
	SignalBus.enemy_died.emit(points)
	queue_free()
