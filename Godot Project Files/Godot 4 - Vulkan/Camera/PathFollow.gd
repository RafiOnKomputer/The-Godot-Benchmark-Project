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


# =================================================================
# Path Following Script - Camera Moves Along Path With Smooth Rotation
# =================================================================

extends PathFollow3D

# =================================================================
# Export Variables - Can Be Changed From Editor
# =================================================================

@export var speed = 20

@export var rotation_smoothness = 10

# =================================================================
# Node References
# =================================================================

@onready var camera = $Camera3D

# =================================================================
# Variables
# =================================================================

var last_position

var current_velocity

var completion_signal_connected = false

# =================================================================
# Signals
# =================================================================

signal path_complete

# =================================================================
# _ready() - Runs ONCE at start
# =================================================================

func _ready():

	loop = false

	progress = 0.0

	last_position = global_transform.origin

# =================================================================
# Connect Completion
# =================================================================

func connect_completion(target, method):

	if not completion_signal_connected:

		connect("path_complete", Callable(target, method))

		completion_signal_connected = true

# =================================================================
# _process() - Runs EVERY FRAME
# =================================================================

func _process(delta):

	progress += speed * delta

	var current_position = global_transform.origin

	current_velocity = (current_position - last_position) / delta

	last_position = current_position

	if current_velocity.length() > 0.1:

		var target_look = current_position + current_velocity.normalized()

		var target_basis = camera.global_transform.looking_at(target_look, Vector3.UP).basis


		camera.global_transform.basis = camera.global_transform.basis.slerp(target_basis, rotation_smoothness * delta)

	if progress >= get_parent().curve.get_baked_length():

						emit_signal("path_complete")

						set_process(false)

# =================================================================
# =================================================================
# End Of File. Its a Mess
# =================================================================
# =================================================================
