Network:Subscribe("Poke", function()
	local spawnArgs = {
		position = LocalPlayer:GetPosition(),
		bank_id = 17,
		sound_id = 35,
		variable_id_focus = 0
			}
	ClientSound.Play(AssetLocation.Game, spawnArgs)
end)

Network:Subscribe("StaffPoke", function()
	local spawnArgs = {
		position = LocalPlayer:GetPosition(),
		bank_id = 6,
		sound_id = 5,
		variable_id_focus = 0
			}
	ClientSound.Play(AssetLocation.Game, spawnArgs)
end)