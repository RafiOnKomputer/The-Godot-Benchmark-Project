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
# This Code Is For The Text On Display (Not The Map Name)
# Its The Version Name , The Music Tip and Socials
#
# =================================================================
# =================================================================

extends CanvasLayer

# =================================================================
# LABEL REFERENCES
# =================================================================

onready var version_label = $Version

onready var mute_label = $Mute

onready var credit_label = $Credit

# =================================================================
# CONFIG
# =================================================================

export var edge_offset = 20

# =================================================================
# _ready() - Runs ONCE When UI Loads
# =================================================================

func _ready():

	setup_labels()

# =================================================================
# setup_labels() - Positions And Configures All Text Labels
# =================================================================

func setup_labels():

# =================================================================
# Version Label (Top Left)
# =================================================================

	version_label.text = "Godot 3.6  |  OpenGL ES 2"

	version_label.rect_position = Vector2(edge_offset, edge_offset)

	version_label.align = Label.ALIGN_LEFT

	version_label.valign = Label.VALIGN_TOP

# =================================================================
# Mute Label (Bottom Right)
# =================================================================

	mute_label.text = "Press M to Toggle Music On or Off"

	var viewport_size = get_viewport().size

	var mute_label_size = mute_label.get_minimum_size()

	mute_label.rect_position = Vector2(
			viewport_size.x - mute_label_size.x - edge_offset,
			viewport_size.y - mute_label_size.y - edge_offset
			)

	mute_label.align = Label.ALIGN_RIGHT

	mute_label.valign = Label.VALIGN_BOTTOM

# =================================================================
# Credit Label (Bottom Left)
# =================================================================

	credit_label.text = "Github:              RafiOnKomputer\nYoutube:           RafiOnKomputer\nInstragram:     rafionkomputer"

		# Creates 3 lines of text:
		# Line 1: Github:              RafiOnKomputer
		# Line 2: Youtube:           RafiOnKomputer
		# Line 3: Instragram:     rafionkomputer
		# Spaces Are Used To Align The Usernames (manual alignment)

	var credit_label_size = credit_label.get_minimum_size()

	credit_label.rect_position = Vector2(
		edge_offset,
		viewport_size.y - credit_label_size.y - edge_offset
		)

	credit_label.align = Label.ALIGN_LEFT

	credit_label.valign = Label.VALIGN_BOTTOM


# =================================================================
# =================================================================
#
# End Of File..Imma Sleep
#
# =================================================================
# =================================================================






