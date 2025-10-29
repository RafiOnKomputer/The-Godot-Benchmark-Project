# ╔══════════════════════════════════════════════════════════════════════╗
# ║                             MIT License                              ║
# ║                                                                      ║
# ║                   Copyright (c) 2025 RafiOnKomputer                  ║
# ║                                                                      ║
# ║ Permission is hereby granted, free of charge, to any person          ║
# ║ obtaining a copy of this software and associated documentation files ║
# ║ (the "Software"), to deal in the Software without restriction,       ║
# ║ including without limitation the rights to use, copy, modify, merge, ║
# ║ publish, distribute, sublicense, and/or sell copies of the Software, ║
# ║ and to permit persons to whom the Software is furnished to do so,    ║
# ║ subject to the following conditions:                                 ║
# ║                                                                      ║
# ║ The above copyright notice and this permission notice shall be       ║
# ║ included in all copies or substantial portions of the Software.      ║
# ║                                                                      ║
# ║ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,      ║
# ║ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF   ║
# ║ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                ║
# ║ NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS  ║
# ║ BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN   ║
# ║ ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN    ║
# ║ CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     ║
# ║ SOFTWARE.                                                            ║
# ╚══════════════════════════════════════════════════════════════════════╝

# ==========================================
# ==========================================
# This One FathFollows But At Fixed
# Camera Angle
# ==========================================
# ==========================================

extends PathFollow3D

# ==========================================
# SETTINGS
# ==========================================

@export var speed = 20.0

@export var pause_duration = 3.0

@onready var camera = $Camera3D

# ==========================================
# VARIABLES
# ==========================================

var initial_camera_rotation = Basis()

var completion_signal_connected = false

var is_paused = false

var pause_timer = 0.0

var current_point_index = 0

signal path_complete

# ==========================================
# SETUP
# ==========================================

func _ready():

	loop = false

	# FIXED: Changed offset to progress for Godot 4
	progress = 0.0

	# FIXED: Added null check for camera in Godot 4
	if camera != null:
		initial_camera_rotation = camera.global_transform.basis
	else:
		push_error("Camera3D not found! Make sure it's a child of this PathFollow3D node.")

# ==========================================
# CONNECT SIGNAL
# ==========================================

func connect_completion(target, method):

	if not completion_signal_connected:

		connect("path_complete", Callable(target, method))

		completion_signal_connected = true

# ==========================================
# MOVEMENT
# ==========================================

func _process(delta):

	var curve = get_parent().curve

	if is_paused:

		pause_timer -= delta

		if pause_timer <= 0:

			is_paused = false

			current_point_index += 1

		if camera != null:
			camera.global_transform.basis = initial_camera_rotation

		return

	var old_offset = progress

	progress += speed * delta

	if camera != null:
		camera.global_transform.basis = initial_camera_rotation

	var total_points = curve.get_point_count()

	for i in range(current_point_index, total_points):

		var point_pos = curve.get_point_position(i)

		var point_offset = curve.get_closest_offset(point_pos)

		if old_offset < point_offset and progress >= point_offset:

			is_paused = true

			pause_timer = pause_duration

			current_point_index = i

			return

	if progress >= curve.get_baked_length():

		emit_signal("path_complete")

		set_process(false)

# ==========================================
# ==========================================
# End Of File....
# ==========================================
# ==========================================
