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



extends CanvasLayer


# =================================================================
# EXPORT VARIABLES - Change Name In Editor Not Here
# =================================================================

@export var map_name = "Map Name Here"

@export var edge_offset = 20

# =================================================================
# NODE REFERENCES
# =================================================================

@onready var map_label = $MapName

# =================================================================
# _ready()
# =================================================================

func _ready():
	setup_labels()


# =================================================================
# setup_labels()
# =================================================================

func setup_labels():
	map_label.text = map_name
	
	var viewport_size = get_viewport().get_visible_rect().size
	
	var label_size = map_label.get_minimum_size()
	
	map_label.position = Vector2(
		viewport_size.x - label_size.x - edge_offset,
		edge_offset
	)
	
	map_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	map_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP


# =================================================================
# =================================================================
# End Of File
# =================================================================
# =================================================================
