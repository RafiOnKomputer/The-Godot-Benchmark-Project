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

extends Control

# =================================================================
# CONFIG - Change This To Match  Godot Version And Api
# =================================================================

var current_version = "Godot 3.6 | OpenGL ES 2"

# =================================================================
# NODE REFERENCES
# =================================================================

onready var background = $Background
onready var results_label = $ResultsLabel

# =================================================================
# VARIABLES
# =================================================================

var display_time = 10

# =================================================================
# _ready()
# =================================================================

func _ready():
	load_and_display_results()
	
	yield(get_tree().create_timer(display_time), "timeout")
	get_tree().quit()

# =================================================================
# Reads JSON and formats display
# =================================================================

func load_and_display_results():

	var file_path = ""
	
	if OS.has_feature("editor"):

		file_path = "res://benchmark_results.json"

	else:

		file_path = OS.get_executable_path().get_base_dir() + "/benchmark_results.json"
	
	var file = File.new()
	

	if not file.file_exists(file_path):

		results_label.text = "No benchmark results found!\n\nPlease run the benchmark first."

		results_label.align = Label.ALIGN_CENTER

		results_label.valign = Label.VALIGN_CENTER

		return
	

	file.open(file_path, File.READ)

	var json_text = file.get_as_text()

	file.close()
	
	var parse_result = JSON.parse(json_text)
	
	if parse_result.error != OK:

		results_label.text = "Error reading benchmark results!"

		return
	
	var all_data = parse_result.result
	
	var display_text = ""
	
	var current_benchmark = null

	for i in range(all_data.size() - 1, -1, -1):

		if all_data[i]["version"] == current_version:

			current_benchmark = all_data[i]
			break
	
	if current_benchmark:

		display_text += current_version + "\n\n"

		display_text += "CPU: " + current_benchmark["cpu"] + "\n\n"

		display_text += "RESULTS:\n"
		
		for map_name in current_benchmark["results"]:

			var fps = current_benchmark["results"][map_name]

			if typeof(fps) == TYPE_STRING:

				display_text += map_name + ": " + fps + "\n"

			else:

				display_text += map_name + ": " + str(fps) + " FPS\n"

		display_text += "\n"
	
	display_text += "COMPLETED BENCHMARKS:\n"
	
	var completed_versions = []

	for entry in all_data:

		completed_versions.append(entry["version"])
	
	# Known benchmark versions to check
	var known_versions = [
		"Godot 3.6 | OpenGL ES 2",
		"Godot 3.6 | OpenGL ES 3",
		"Godot 4.5.1 | OpenGLES",
		"Godot 4.5.1 | OpenGL",
		"Godot 4.5.1 | Vulkan",
		"Godot 4.5.1 | Vulkan Mobile"

		]
	
	for version in known_versions:

		if version in completed_versions:

			display_text += version + " - Done\n"

		else:

			display_text += version + " - Not Done (Please Run)\n"
	
	results_label.text = display_text
	results_label.align = Label.ALIGN_CENTER
	results_label.valign = Label.VALIGN_CENTER

# =================================================================
# End of File
# =================================================================
