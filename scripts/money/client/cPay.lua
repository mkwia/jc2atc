tick = "✔"
cross = "✘"

refresh_timer = Timer()

window = Window.Create()
window:SetTitle("The Royal Bank of Panau")
window:SetSize(Vector2(250, 260))
window:SetPositionRel(Vector2(0.5, 0.5) - window:GetSizeRel()/2)
window:SetVisible(false)

bal = Label.Create(window)
bal:SetText("Balance: £"..LocalPlayer:GetMoney())
bal:SizeToContents()
bal:SetPositionRel(Vector2(0.075, 0.1))

amt = Label.Create(window)
amt:SetText("Amount to pay:")
amt:SizeToContents()
amt:SetPositionRel(Vector2(0.075, 0.2))

amount = TextBoxNumeric.Create(window)
amount:SetSize(Vector2(amount:GetSize().x/2, amount:GetSize().y))
amount:SetPositionRel(Vector2(0.075, 0.275))
amount:SetText("")

correct_ammount = Label.Create(window)
correct_ammount:SetPositionRel(amount:GetPositionRel() + Vector2(amount:GetSizeRel().x + 0.05, 0.025))

rec = Label.Create(window)
rec:SetText("Recipient/Firm Account Number:")
rec:SizeToContents()
rec:SetPositionRel(Vector2(0.075, 0.4))

recipient = TextBoxNumeric.Create(window)
recipient:SetSize(Vector2(recipient:GetSize().x/2, recipient:GetSize().y))
recipient:SetPositionRel(Vector2(0.075, 0.475))
recipient:SetText("")

correct_recipient = Label.Create(window)
correct_recipient:SetPositionRel(recipient:GetPositionRel() + Vector2(recipient:GetSizeRel().x + 0.05, 0.025))

ref = Label.Create(window)
ref:SetText("Payment Reference/Reason:")
ref:SizeToContents()
ref:SetPositionRel(Vector2(0.075, 0.6))

reference = TextBox.Create(window)
reference:SetSize(Vector2(reference:GetSize().x/2, recipient:GetSize().y))
reference:SetPositionRel(Vector2(0.075, 0.675))
reference:SetText("")

correct_reference = Label.Create(window)
correct_reference:SetPositionRel(reference:GetPositionRel() + Vector2(reference:GetSizeRel().x + 0.05, 0.025))

send = Button.Create(window)
send:SetText("Send Money")
send:SetPositionRel(Vector2(0.075, 0.8))

window:SetSize(Vector2(230, 270))

Events:Subscribe("KeyUp", function(args)

	if args.key == string.byte("7") then

		togglewindow(open())

		return false

	end

end)

function togglewindow(enable)

	window:SetVisible(enable)
	Mouse:SetVisible(enable)

end

function open()

	return (not window:GetVisible())

end

function checkamount()

	if amount:GetText() == "" or amount:GetText() == nil then

		incorrectvalue(correct_ammount)

		return false

	end

	local amount = tonumber(amount:GetText())

	if amount >= 1 and amount <= LocalPlayer:GetMoney() then

		correctvalue(correct_ammount)

		return true

	else

		incorrectvalue(correct_ammount)

		return false

	end

end

function checkrecipient()

	if recipient:GetText() == "" then

		incorrectvalue(correct_recipient)

		return false

	end

	local recipient = Player.GetById(tonumber(recipient:GetText()))

	if recipient then

		correctvalue(correct_recipient)

		return true

	else

		incorrectvalue(correct_recipient)

		return false

	end

end

function checkreference()

	if reference:GetText() == "" then

		incorrectvalue(correct_reference)

		return false

	else

		correctvalue(correct_reference)

		return true

	end

end

function correctvalue(item)

	item:SetText(tick)
	item:SetTextColor(Color.Lime)

end

function incorrectvalue(item)

	item:SetText(cross)
	item:SetTextColor(Color.Red)

end

function sendmoney()

	local amount = tonumber(amount:GetText())

	local recipient = Player.GetById(tonumber(recipient:GetText()))

	local reference = reference:GetText()

	if not checkamount() then

		Chat:Print("You don't have enough money for that!", Color.Red)

	else

		if not checkrecipient() then

			Chat:Print("That ID isn't valid! (Press F6 for player IDs, and 8 for firm IDs)", Color.Red)

		else

			if not checkreference() then

				Chat:Print("Please include a reason/reference for the payment!", Color.Red)

			else

				Network:Send("Transaction", {money = amount, player = recipient, reason = reference})

			end

		end

	end

end

Events:Subscribe("LocalPlayerInput", function()

	if not open() then

		return false

	end

end)

Events:Subscribe("LocalPlayerMoneyChange", function(args)

	bal:SetText("Balance: £"..args.new_money)
	bal:SizeToContents()

end)

window:Subscribe("WindowClosed", function() togglewindow(false) end)
amount:Subscribe("TextChanged", function() checkamount() end)
recipient:Subscribe("TextChanged", function() checkrecipient() end)
reference:Subscribe("TextChanged", function() checkreference() end)
incorrectvalue(correct_ammount)
incorrectvalue(correct_recipient)
incorrectvalue(correct_reference)
send:Subscribe("Down", function() sendmoney() end)