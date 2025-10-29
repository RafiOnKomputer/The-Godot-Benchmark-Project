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
# =================================================================
#
# This Code Is Used To Pause/UnPause Music
#
# =================================================================
# =================================================================

extends AudioStreamPlayer

# =================================================================
# VARIABLES
# =================================================================

var is_paused = false

# =================================================================
# Input Handling
# =================================================================

func _input(event):

	if event is InputEventKey and event.pressed and event.scancode == KEY_M:

		toggle_music()

# =================================================================
# Switches Music Between Playing And Paused State
# =================================================================

func toggle_music():

	if is_paused:

		stream_paused = false

		is_paused = false

		print("Music resumed")

	else:

		stream_paused = true

		is_paused = true

		print("Music paused")

# =================================================================
# =================================================================
#
# End Of File...I Have Nothing To Say...This One Was Simple
# There is Barely Anything If You Remove Comments...
# But The Comments Look Good :3
#
# =================================================================
# =================================================================
