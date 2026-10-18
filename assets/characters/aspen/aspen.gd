extends Node2D


func play_walk_animation():
	$AnimationPlayer.play("walk")
	
func play_idle_animation():
	$AnimationPlayer.play("idle")
	
