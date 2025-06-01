extends Node2D

@onready var player:CharacterBody2D = $Player
@onready var basic_enemy:= preload("res://Scenes/enemy.tscn")

@export var min_spawn_distance:float
@export var max_spawn_distance:float

@export var basic_enemy_timer:Timer
@export var basic_enemy_spawn_rate:float
@export var max_basic_enemy:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	basic_enemy_timer.wait_time = basic_enemy_spawn_rate
	basic_enemy_timer.start()

func _on_basic_enemy_timeout() -> void:
	var enemy := basic_enemy.instantiate()
	add_child(enemy)
	var random_dir = Vector2(randf_range(-1,1), randf_range(-1,1))
	var random_distance = randi_range(min_spawn_distance, max_spawn_distance)
	enemy.position = player.position + random_dir * random_distance
	enemy.player = player
