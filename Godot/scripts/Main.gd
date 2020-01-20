extends Node2D

var cellmap = preload("res://scenes/Cellmap.tscn").instance()

# scalar for cell and grid sizes
# use 1, 2, 4 (or 8 or 16, if you like slide shows)
# 1 means big cells and faster performance, 16 means 1px cells, nightmare performance
var m:int = 4   # 4 is already a bit heavy on my pc (~20fps)

# Do not edit these
var CS:int = 16.0 / m
var GW:int = 80 * m
var GH:int = 50 * m


func _ready() -> void:
	add_child(cellmap)
	cellmap.init(GW, GH, CS, 75)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		cellmap.toggle_pause()
	elif event.is_action_pressed("quit"):
		get_tree().quit()
