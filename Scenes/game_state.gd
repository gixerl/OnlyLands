extends Node

var selected_country: String = ""
var country_locked: bool = false
var selected_enemy: String = ""
var enemy_locked: bool = false
var show_attack: bool = false
var conquered_countries: PackedStringArray = PackedStringArray()
var attackable_neighbors: PackedStringArray = PackedStringArray()
var answer_locked = false
