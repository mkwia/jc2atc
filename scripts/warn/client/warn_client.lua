--Settings
textsize = 50
color = Color(255, 0, 0, 255)

function Rendering()
	if AlertTimer ~= nil then
		if AlertTimer:GetSeconds() <= 10 then
		
			--word wrapping
			local words = string.split(AlertMessage, " ")
			local linelist = {}
			linelist[1] = ""
			local linelistpos = 1
			
			for i, v in ipairs(words) do
			
				local newline = linelist[linelistpos].." "..v
			
				if Render:GetTextWidth(newline, textsize) < Render.Width then
				
					linelist[linelistpos] = newline
				
				else
				
					linelistpos = linelistpos + 1
					linelist[linelistpos] = v
				
				end
			
			end
			
			--concatenating the lines
			local finalmsg = ""
			for i, v in ipairs(linelist) do
				finalmsg = finalmsg.."\n"..v
			end
			finalmsg = string.sub(finalmsg, 3)
		
			--fadein/out
			if AlertTimer:GetSeconds() <= 1 then
				color.a = 255 * AlertTimer:GetMilliseconds()/1000
			elseif AlertTimer:GetSeconds() >= 9 then
				color.a = 255 * (11 - AlertTimer:GetMilliseconds()/1000)
			end
			color.a = color.a/3

			--rendering the text
			Render:DrawText(Render.Size/2 - Render:GetTextSize(finalmsg, textsize)/2 + Vector2(2, 2), finalmsg, Color(20, 20, 20, color.a), textsize)
			color.a = color.a*2
			Render:DrawText(Render.Size/2 - Render:GetTextSize(finalmsg, textsize)/2 + Vector2(1, 1), finalmsg, Color(10, 10, 10, color.a * 2), textsize)
			color.a = color.a*3/2
			Render:DrawText(Render.Size/2 - Render:GetTextSize(finalmsg, textsize)/2, finalmsg, color, textsize)
			
			
		else
			AlertTimer = nil
			AlertMessage = nil
		end
	end
end
Events:Subscribe("PostRender", Rendering)

Network:Subscribe("alert!", function(text) AlertMessage = text AlertTimer = Timer() print("Message from the server: "..text) end)