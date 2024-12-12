extends AnimatableBody2D

var tier = 0

func upgradeTower() -> void:
	if tier <= 7:
		$Animations.play("Lv"+str(tier)+str(tier+1)+"-Upgrade")
		await $Animations.animation_finished
		tier += 1
		$Animations.play("Lv"+str(tier)+"-Idle")
