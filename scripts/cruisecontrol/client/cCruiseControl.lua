active = false

cruising = false


unit = {
	kmph = {
			name = "km/h",
			multiplier = 1.000000	
			},
	mps = {
			name = "m/s",
			multiplier = 0.277777
			},
	mph = {
			name = "mph",
			multiplier = 0.621371
			}
		}

activeunit = unit.kmph


window = Window.Create()
window:SetTitle("Cruise Control")
window:SetSize(Vector2(340, 100))
window:SetPosition(Vector2(0.85 * Render.Size.x, 0.3 * Render.Size.y) - window:GetSize()/2)
window:SetVisible(active)
window:SetClosable(false)

slider = HorizontalSlider.Create(window)
slider:SetSize(window:GetSize() - Vector2(30, 0))
slider:SetPosition(Vector2(window:GetSize().x/2 - slider:GetSize().x/2, 0) - Vector2(5, 30))
slider:SetMinimum(0)
slider:SetMaximum(250)
slider:Subscribe("ValueChanged", function() UpdateDisplay() end)

speeddisplay = Label.Create(window)
speeddisplay:SetText("0 "..activeunit.name)
speeddisplay:SizeToContents()
speeddisplay:SetPositionRel(Vector2(0.05, 0.45))

rect = Rectangle.Create(slider)
rect:SetColor(Color(64, 64, 64))
rect:SetSize(speeddisplay:GetSize() + Vector2(30, 4))
rect:SetPosition(speeddisplay:GetPosition() - rect:GetSize()/2 + Vector2(4, 35))

unitselector = ComboBox.Create(window)
unitselector:AddItem("km/h")
unitselector:AddItem("mph")
unitselector:AddItem("m/s")
unitselector:SetSize(Vector2(50, 20))
unitselector:SetPosition(rect:GetPosition() - unitselector:GetSize()/2 + Vector2(140, -22))
unitselector:Subscribe("Selection", function() selectunit() end)

togglebutton = Button.Create(window)
togglebutton:SetText("Turn Cruise Control On")
togglebutton:SizeToContents()
togglebutton:SetSize(togglebutton:GetSize() + Vector2(4, 8))
togglebutton:SetPosition(unitselector:GetPosition() - Vector2(togglebutton:GetSize().x/2, 0) + Vector2(140, 0.5))
togglebutton:Subscribe("Press", function() toggleCC() end)

Events:Subscribe("KeyUp", function(args)

	if args.key == string.byte("Z") then

		if LocalPlayer:InVehicle() then

			local v = LocalPlayer:GetVehicle()
			local vmod = v:GetModelId()

			if Vehicle.GetClassByModelId(vmod) == 2 then

				SetVisible(not active)

			end

		end

	end

end)

Events:Subscribe("LocalPlayerExitVehicle", function()

	SetVisible(false)

	if cruising then

		toggleCC()

	end

end)

Events:Subscribe("LocalPlayerInput", function(args)

	local i = args.input

	if active then
		if i == 3 or i == 4 or i == 5 or i == 6 or i == 11 or i == 12 or i == 13 or i == 14 or i == 137 or i == 138 or i == 139 then
			return false
		end
	end

end)

Events:Subscribe("InputPoll", function()
	
	if cruising then

		if LocalPlayer:GetLinearVelocity():Length() * 3.6 < slider:GetValue() and LocalPlayer:GetLinearVelocity():Length() * 3.6 > slider:GetValue() - 10 then

			Input:SetValue(39, 0.9)

		elseif LocalPlayer:GetLinearVelocity():Length() * 3.6 < slider:GetValue() then

			Input:SetValue(39, 1)

		elseif LocalPlayer:GetLinearVelocity():Length() * 3.6 < slider:GetValue() + 5 and LocalPlayer:GetLinearVelocity():Length() * 3.6 < slider:GetValue() - 5 then

			Input:SetValue(39, 0.5)

		else

			Input:SetValue(39, 0)

		end

	end

end)

function SetVisible(visible)

	active = visible
	window:SetVisible(visible)
	Mouse:SetVisible(visible)

end

function UpdateDisplay()

	speeddisplay:SetText((math.floor(slider:GetValue() * activeunit.multiplier)).." "..activeunit.name)
	speeddisplay:SizeToContents()
	rect:SetSize(speeddisplay:GetSize() + Vector2(30, 4))

end

function toggleCC()

	cruising = not cruising

	if cruising then

		togglebutton:SetText("Turn Cruise Control Off")

	else

		togglebutton:SetText("Turn Cruise Control On")

	end

	togglebutton:SizeToContents()
	togglebutton:SetSize(togglebutton:GetSize() + Vector2(4, 8))
	togglebutton:SetPosition(unitselector:GetPosition() - Vector2(togglebutton:GetSize().x/2, 0) + Vector2(140, 0.5))

end

function selectunit()

	local selectedunit = unitselector:GetSelectedItem():GetText()

	for _, v in pairs(unit) do

		if selectedunit == v.name then

			activeunit = v

			speeddisplay:SetText((math.floor(slider:GetValue() * activeunit.multiplier)).." "..activeunit.name)
			speeddisplay:SizeToContents()
			rect:SetSize(speeddisplay:GetSize() + Vector2(30, 4))

		end

	end

end