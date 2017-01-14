class 'ReverseThrust'

function ReverseThrust:__init()
	
	Network:Subscribe("ReverseThrust", self, self.ReverseThrust)
	
end


function ReverseThrust:ReverseThrust(args)

	if IsValid(args.vehicle) then
		args.vehicle:SetLinearVelocity(args.velocity)
	end
	
end

ReverseThrust = ReverseThrust()