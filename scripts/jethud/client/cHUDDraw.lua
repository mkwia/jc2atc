
function HUD:DrawHUD()
	
	local roll = self:GetRoll()
	local pitch = self:GetPitch()
	
	--
	-- Draw crosshair at center.
	--
	self:DrawLineHUD(
		Vector2(-0.09 , 0) ,
		Vector2(0.09 , 0)
	)
	self:DrawLineHUD(
		Vector2(0 , 0) ,
		Vector2(0 , 0.09)
	)
	
	--
	-- Draw pitch elements.
	--
	local pitchLineX1 = 0.5
	local pitchLineX2 = 0.21
	local DrawPitchLine = function(y , text , num)
		
		-- Draw a special line if y is near 0
		-- Draw a solid line if y is above 1
		-- Draw a dashed line if y is below 0.
		-- FIXME: The dotted lines make up way too many lines.
		if num == 0 then
			self:DrawLineHUD(
				Vector2(-pitchLineX1*1.1 , y) ,
				Vector2(-pitchLineX2*1.1 , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(-pitchLineX1*1.1 , y) ,
				Vector2(-pitchLineX1*1.1 , y - 0.06) ,
				true
			)
			
			self:DrawLineHUD(
				Vector2(pitchLineX2*1.1 , y) ,
				Vector2(pitchLineX1*1.1 , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(pitchLineX1*1.1 , y) ,
				Vector2(pitchLineX1*1.1 , y - 0.06) ,
				true
			)
		elseif num > 0 then
			self:DrawLineHUD(
				Vector2(-pitchLineX1 , y) ,
				Vector2(-pitchLineX2 , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(pitchLineX2 , y) ,
				Vector2(pitchLineX1 , y) ,
				true
			)
		else
			self:DrawLineHUD(
				Vector2(math.lerp(-pitchLineX1 , -pitchLineX2 , 0.04) , y) ,
				Vector2(math.lerp(-pitchLineX1 , -pitchLineX2 , 0.16) , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(math.lerp(-pitchLineX1 , -pitchLineX2 , 0.24) , y) ,
				Vector2(math.lerp(-pitchLineX1 , -pitchLineX2 , 0.36) , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(math.lerp(-pitchLineX1 , -pitchLineX2 , 0.44) , y) ,
				Vector2(math.lerp(-pitchLineX1 , -pitchLineX2 , 0.56) , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(math.lerp(-pitchLineX1 , -pitchLineX2 , 0.64) , y) ,
				Vector2(math.lerp(-pitchLineX1 , -pitchLineX2 , 0.76) , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(math.lerp(-pitchLineX1 , -pitchLineX2 , 0.84) , y) ,
				Vector2(math.lerp(-pitchLineX1 , -pitchLineX2 , 0.96) , y) ,
				true
			)
			
			self:DrawLineHUD(
				Vector2(math.lerp(pitchLineX1 , pitchLineX2 , 0.04) , y) ,
				Vector2(math.lerp(pitchLineX1 , pitchLineX2 , 0.16) , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(math.lerp(pitchLineX1 , pitchLineX2 , 0.24) , y) ,
				Vector2(math.lerp(pitchLineX1 , pitchLineX2 , 0.36) , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(math.lerp(pitchLineX1 , pitchLineX2 , 0.44) , y) ,
				Vector2(math.lerp(pitchLineX1 , pitchLineX2 , 0.56) , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(math.lerp(pitchLineX1 , pitchLineX2 , 0.64) , y) ,
				Vector2(math.lerp(pitchLineX1 , pitchLineX2 , 0.76) , y) ,
				true
			)
			self:DrawLineHUD(
				Vector2(math.lerp(pitchLineX1 , pitchLineX2 , 0.84) , y) ,
				Vector2(math.lerp(pitchLineX1 , pitchLineX2 , 0.96) , y) ,
				true
			)
		end
		
		if text and num ~= 0 then
			self:DrawTextHUD(text , Vector2(-pitchLineX1 - 0.01 , y) , "right" , true)
			self:DrawTextHUD(text , Vector2(pitchLineX1 + 0.01 , y) , "left" , true)
		end
		
	end
	
	local pitchDeg = math.deg(pitch)
	local pitchLineSpacingDegrees = 5
	local numPitchLines = 90 / pitchLineSpacingDegrees
	local pitchLineScale = 8
	local pitchLineSpacing = pitchLineScale / numPitchLines
	local pitchLineCutoff = 0.9
	
	for n = -numPitchLines , numPitchLines , 1 do
		local y = (n * pitchLineSpacing) + (-pitchDeg / pitchLineSpacingDegrees) * pitchLineSpacing
		if y > -pitchLineCutoff and y < pitchLineCutoff then
			local text = string.format("%i" , n * pitchLineSpacingDegrees)
			DrawPitchLine(y , text , n)
		end
	end
	
	
	--
	-- Draw velocity vector.
	--
	
	local velocityRaw = self.vehicle:GetLinearVelocity()
	
	local velocityRelative = self.vehicle:GetAngle():Inverse() * velocityRaw
	
	local velocityPitch = math.asin(velocityRelative.y / -velocityRelative.z)
	local velocityYaw = math.asin(velocityRelative.x / -velocityRelative.z)
	
	velocityPitch = math.deg(velocityPitch)
	velocityYaw = math.deg(velocityYaw)
	
	local velocityVector = Vector2(velocityYaw , velocityPitch)
	velocityVector = velocityVector * (pitchLineSpacing / pitchLineSpacingDegrees)
	-- velocityVector = GUIUtil.Rot(velocityVector , Vector2(0 , 0) , -roll)
	
	-- printC(ColorF(0.3 , 0.4 , 1) , "Raw velocity: " , velocityRaw)
	-- printC(ColorF(1 , 0.5 , 0) , "Relative velocity: " , velocityRelative)
	-- printC(ColorF(0.5 , 1 , 0.5) , "Velocity vector pitch: " , velocityPitch)
	
	if velocityRaw:Length() > 0.5 then
		self:DrawCircleHUD(0.03 , velocityVector , 9)
	end
	
	
	--
	-- Altitude
	--
	
	-- Sea level.
	local altitude = self.vehicle:GetPosition().y - 200
	
	local altBoxCenter = Vector2(0.8 , 0.3)
	local altBoxSizeX = 0.1
	local altBoxSizeY = 0.05
	
	-- Top.
	self:DrawLineHUD(
		Vector2(-altBoxSizeX , altBoxSizeY) + altBoxCenter ,
		Vector2(altBoxSizeX , altBoxSizeY) + altBoxCenter
	)
	-- Bottom.
	self:DrawLineHUD(
		Vector2(-altBoxSizeX , -altBoxSizeY) + altBoxCenter ,
		Vector2(altBoxSizeX , -altBoxSizeY) + altBoxCenter
	)
	-- Left.
	self:DrawLineHUD(
		Vector2(-altBoxSizeX , altBoxSizeY) + altBoxCenter ,
		Vector2(-altBoxSizeX , -altBoxSizeY) + altBoxCenter
	)
	-- Right.
	self:DrawLineHUD(
		Vector2(altBoxSizeX , altBoxSizeY) + altBoxCenter ,
		Vector2(altBoxSizeX , -altBoxSizeY) + altBoxCenter
	)
	-- Text
	self:DrawTextHUD(
		string.format("%i" , altitude) ,
		altBoxCenter + Vector2(altBoxSizeX * 1 , 0.0) ,
		"right"
	)
	
	
	--
	-- Speedometer
	--
	
	local speedForward = -velocityRelative.z
	if settings.useKPH then
		speedForward = speedForward * 3.6
	end
	
	local speedBoxCenter = Vector2(-0.8 , 0.3)
	local speedBoxSizeX = 0.1
	local speedBoxSizeY = 0.05
	
	-- Top.
	self:DrawLineHUD(
		Vector2(-speedBoxSizeX , speedBoxSizeY) + speedBoxCenter ,
		Vector2(speedBoxSizeX , speedBoxSizeY) + speedBoxCenter
	)
	-- Bottom.
	self:DrawLineHUD(
		Vector2(-speedBoxSizeX , -speedBoxSizeY) + speedBoxCenter ,
		Vector2(speedBoxSizeX , -speedBoxSizeY) + speedBoxCenter
	)
	-- Left.
	self:DrawLineHUD(
		Vector2(-speedBoxSizeX , speedBoxSizeY) + speedBoxCenter ,
		Vector2(-speedBoxSizeX , -speedBoxSizeY) + speedBoxCenter
	)
	-- Right.
	self:DrawLineHUD(
		Vector2(speedBoxSizeX , speedBoxSizeY) + speedBoxCenter ,
		Vector2(speedBoxSizeX , -speedBoxSizeY) + speedBoxCenter
	)
	-- Text
	local speedString = string.format("%i" , speedForward)
	self:DrawTextHUD(
		speedString ,
		speedBoxCenter + Vector2(speedBoxSizeX * 1 , 0.0) ,
		"right"
	)
	
	
	--
	-- Compass
	--
	
	local compassY = 0.85
	local compassWidth = 0.7
	local compassSizeDegrees = 30
	
	-- Arrow.
	self:DrawLineHUD(
		Vector2(0 , compassY) ,
		Vector2(0 , compassY) + Vector2(-0.05 , -0.05)
	)
	self:DrawLineHUD(
		Vector2(0 , compassY) ,
		Vector2(0 , compassY) + Vector2(0.05 , -0.05)
	)
	
	-- Heading lines.
	
	local heading = math.deg(self:GetYaw())
	if heading < 0 then
		heading = -heading
	else
		heading = 180 + (180 - heading)
	end
	local leftValue = (heading - compassSizeDegrees*0.5)
	local rightValue = (heading + compassSizeDegrees*0.5)
	local leftX = -compassWidth*0.5
	local rightX = compassWidth*0.5
	local textY = 0.1
	
	local from , to = -compassSizeDegrees*0.5 , 360 + compassSizeDegrees*0.5
	for n = from , to , 5 do
		if n >= leftValue and n <= rightValue then
			local normPos = (n - leftValue) / compassSizeDegrees
			local pos = math.lerp(leftX , rightX , normPos)
			local lineHeight = 0.05
			
			n = n % 360
			
			if n % 10 == 0 then
				-- Big lines with numbers.
				self:DrawTextHUD(
					string.format("%i" , n) ,
					Vector2(pos , compassY + textY) ,
					"center"
				)
			else
				-- Small lines.
				lineHeight = lineHeight / 2
			end
			
			self:DrawLineHUD(
				Vector2(pos , compassY) ,
				Vector2(pos , compassY + lineHeight)
			)
		end
	end
	
	
	--
	-- Roll indicator
	--
	
	--
	-- G indicator
	--
	
	-- local gIndicatorPos = Vector2(-0.75 , -0.3)
	
	-- local g = gAcceleration / 9.81
	-- g = math.round(g * 100) / 100
	-- self:DrawTextHUD(
		-- string.format("%.2f" , g) ,
		-- gIndicatorPos ,
		-- "right"
	-- )
	
	-- self:DrawTextHUD(
		-- "G" ,
		-- gIndicatorPos + Vector2(-0.02 , 0) ,
		-- "left"
	-- )
	
end
