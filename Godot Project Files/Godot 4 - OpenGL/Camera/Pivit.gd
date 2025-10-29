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

extends Node3D


# =================================================================
# EXPORT VARIABLES
# =================================================================

@export var rotation_speed_degrees : float = 45
@export var max_rotations : int = 3

# =================================================================
# VARIABLES
# =================================================================

var current_speed : float = 0.0
var total_rotation : float = 0.0
var is_ignoring_rotation : bool = true
var completion_signal_connected = false

# =================================================================
# SIGNALS
# =================================================================

signal rotation_complete

# =================================================================
# _ready()
# =================================================================

func _ready():
	is_ignoring_rotation = true
	total_rotation = 0.0
	current_speed = rotation_speed_degrees

# =================================================================
# connect_completion()
# =================================================================

func connect_completion(target, method):
	if not completion_signal_connected:
		connect("rotation_complete", Callable(target, method))
		completion_signal_connected = true

# =================================================================
# _process() - ROTATION LOGIC
# =================================================================

func _process(delta):
	if is_ignoring_rotation:
		current_speed = rotation_speed_degrees
		var rotation_this_frame = current_speed * delta
		rotate_y(deg_to_rad(rotation_this_frame))
		total_rotation += rotation_this_frame

	if total_rotation >= 360.0 * max_rotations:
		is_ignoring_rotation = false
		emit_signal("rotation_complete")
		set_process(false)
# =================================================================
# =================================================================
# End Of File...
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢴⣤⣦⣴⣤⣦⡄⢀⠠⣀⠀⠰⢤⣦⡄⢰⣤⠦⠐⣀
#⠄⠀⠀⠀⠀⠀⢀⠀⠀⡀⠀⢀⠀⠀⡀⠀⢀⠀⠀⡀⠀⢀⠀⠀⠀⠀⠀⠀⣨⣿⣿⣿⣿⣿⣿⡇⢀⠣⢄⡉⢆⠈⢛⣣⣌⡰⠊⠉⠄
#⣭⣛⣒⠶⠶⢦⣤⣤⣤⣄⣀⣀⣀⣀⣀⣀⣀⣀⣀⣠⣤⣤⣤⣶⣶⡶⠏⣾⣿⣿⣿⡿⠿⠿⠿⠟⠒⠒⢂⠀⠀⢶⣯⣙⠛⠃⠠⢉⠒
#⠻⠿⠿⣿⣿⣿⣿⣿⠟⠛⠻⠿⠿⠿⠟⠛⠛⠛⠛⠛⠋⠉⠉⠀⠀⣀⡀⢿⣿⣿⣿⣿⣿⠯⠥⠜⠀⢉⠀⠤⣘⡄⠉⠙⠂⠑⢄⡀⠄
#⠒⠤⠤⢤⣀⣀⣀⣐⣈⣡⣡⣉⣩⣔⣾⣶⣶⣾⣶⣶⣿⣿⣿⣿⡿⣿⣿⣶⣶⣄⣄⠠⡀⢄⠢⡌⠢⠕⠊⠉⠀⠀⠀⠀⠀⠀⠀⠉⠓
#⠀⠀⠀⠀⠀⠈⠉⠉⠉⠙⠛⠛⠛⠛⠋⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠋⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡠⠀⠤⢄⡐⡤⡔⠒⢲⢂⡻⡜⣄⠻⡀⠒⢦⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⣤⣀⠀
#⠀⠀⣀⣀⣀⣀⣤⣤⣶⠖⢡⡂⣻⠍⠀⣊⣼⡡⣥⣦⢔⠻⠖⡷⢶⣽⣢⠤⣌⡀⠙⡇⠠⠉⠷⣶⣤⣄⣀⠀⠀⠀⠀⣀⠀⠈⠻⢿⣿
#⣴⠀⣿⠃⡼⣩⡿⠞⢁⡠⣤⣁⡀⢼⠻⣼⣷⣯⢅⡒⠢⠆⠲⢌⠳⣽⣾⣿⡶⢿⣷⣶⡯⢚⡤⡈⠛⠽⣿⣆⠀⠀⢘⠸⣿⣦⡐⠀⣿
#⡟⡄⢻⠀⢧⠋⠑⡜⠎⠓⠀⠉⠁⠀⠀⠉⠉⣻⣏⣭⣁⠨⠥⠭⣽⣾⣿⢛⠁⢈⣁⡈⠁⠈⠁⠉⠂⢔⡤⣉⢂⠂⠀⣭⣷⢯⣷⠀⣿
#⡭⣟⡈⠰⢃⠌⠁⠀⣠⠤⠖⠒⠚⠛⠛⠶⣶⣿⣿⣿⣭⣭⣭⡷⠾⣿⣿⣿⠿⠛⠉⠉⠁⠈⠁⠀⠀⠀⣹⣿⡆⢻⣿⡘⣯⠛⡝⠀⣿
#⣧⠛⡄⡔⢹⣦⠖⠁⠀⢀⣀⣤⣀⠳⠶⠄⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⣶⣶⣶⣦⠐⣿⣦⡀⠘⢿⣿⠀⣿⡇⡧⠃⠘⠀⣿
#⠙⢧⡘⠁⢿⣏⠀⠀⠰⣿⣿⣿⣿⣿⠋⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⢻⣿⣿⣿⣷⣦⠭⠁⠀⢸⡟⢰⡿⠀⣡⠃⡈⢰⣿
#⠰⡀⠉⢂⡘⣿⣆⡀⠀⠹⠛⠛⠋⢉⣀⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣬⣉⣉⣉⠉⢛⡀⠀⣤⣚⡀⠉⢐⡈⢀⠆⢁⣾⣿
#⠄⠀⠀⣷⣿⣾⠿⡷⣖⠶⡶⢾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡻⣏⡝⣳⠹⣏⡇⣰⣋⣤⢴⡦⣉⠻⣿
#⠁⡄⠀⣿⣟⣮⢳⡱⢎⡳⣭⣻⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣾⣼⣣⣿⣼⢃⡈⠿⣽⢪⡑⠆⢢⠼
#⢰⣷⡀⠘⣿⣾⣷⣿⣯⣿⣷⣿⠿⠟⣋⣭⣴⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣮⣭⣭⣍⣉⡛⠻⠿⢿⣿⣿⣿⡇⣡⣶⣭⡶⢺⣁⡈⢏
#⣼⣧⢳⢀⠘⢻⣿⣿⣿⣿⣿⣧⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣤⣾⣿⣿⡟⡀⢻⢣⣏⡗⣸⢁⠀⠀
#⣿⢾⣻⢸⠁⡄⠈⠙⠛⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠛⠃⠁⢂⣙⡻⢰⢡⠀⢀⣴
#⣿⣻⢿⡘⡰⠀⣎⡁⠀⠄⠀⠀⠀⠈⢉⣉⠉⠉⠉⢉⠉⠛⠛⠻⠿⠟⠛⠛⠛⠛⠉⠉⣉⠁⠀⠀⠀⠀⠀⢂⠠⣿⣻⣽⡙⢣⠍⠄⠙
#⡽⣯⡗⡰⡉⢆⠱⣀⠀⠀⠀⠀⠀⢿⣿⣦⣄⡀⠉⠺⡹⣜⢣⡛⣬⠳⠀⠀⣀⣤⣾⡿⠃⠀⠀⠀⠀⠀⡁⢀⠀⠉⠓⠈⢁⠀⡈⠄
#⣿⡽⣷⣏⢳⡡⠄⠃⢆⠈⠀⠀⠀⠀⠳⣍⡻⢿⣿⣷⣦⣀⠘⢃⣉⣤⣤⣶⡿⠿⠛⠁⠀⠒⠀⠀⠀⠘⡐⠌⡄⠀⠀⢀⠀⠀⠀⠀⠌
#⠙⠻⢷⣻⣆⠙⠰⠀⠃⠀⠀⠀⠀⠀⠀⠀⠈⠀⠩⠙⢛⣛⣛⣛⠛⠋⠍⠁⣂⠁⠒⠈⠀⠀⠀⠀⠀⠀⠀⢈⠄⠁⣠⢻⢑⡀⢀⠘⠄
#⣡⣴⣶⣍⠫⡐⠈⢁⠀⠀⠀⠀⣾⡿⠏⡆⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠀⠀⠀⢀⢺⡿⠄⠀⠀⠀⠀⠀⠀⠄⢰⣿⡈⠆⠨⠄⢈⡐
# =================================================================
# =================================================================
