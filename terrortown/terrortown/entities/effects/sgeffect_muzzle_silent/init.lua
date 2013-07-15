/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data)
	
	self.WeaponEnt 		= data:GetEntity()
	self.Attachment 		= data:GetAttachment()
	
	self.Position 		= self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward 		= data:GetNormal()
	self.Angle 			= self.Forward:Angle()
	self.Right 			= self.Angle:Right()
	self.Up 			= self.Angle:Up()
	
//	local AddVel 		= self.WeaponEnt:GetOwner():GetVelocity()
	
	local emitter 		= ParticleEmitter(self.Position)	

		local particle = emitter:Add("particle/particle_smokegrenade", self.Position)

			particle:SetVelocity(100 * self.Forward + 8 * VectorRand())
			particle:SetAirResistance(400)
			particle:SetGravity(Vector(0, 0, math.Rand(25, 100)))

			particle:SetDieTime(math.Rand(1.0, 2.0))

			particle:SetStartAlpha(25)
			particle:SetEndAlpha(0)

			particle:SetStartSize(math.Rand(2, 7))
			particle:SetEndSize(math.Rand(15, 25))

			particle:SetRoll(math.Rand(-25, 25))
			particle:SetRollDelta(math.Rand(-0.05, 0.05))

			particle:SetColor(250, 250, 250)
			
		for i = 1, 4 do
	
			local particle = emitter:Add("effects/yellowflare", self.Position)
		
				particle:SetVelocity(((self.Forward + VectorRand() * 3) * math.Rand(50, 100)))
				particle:SetDieTime(math.Rand(0.1,0.1))
				particle:SetStartAlpha(255)
				particle:SetStartSize(1)
				particle:SetEndSize(0)
				particle:SetRoll(0)
				particle:SetGravity(Vector(0, 0, 0))
				particle:SetCollide(false)
				particle:SetBounce(0.8)
				particle:SetAirResistance(375)
				particle:SetStartLength(2.5)
				particle:SetEndLength(0)
				particle:SetVelocityScale(false)
		end

	emitter:Finish()
end

/*---------------------------------------------------------
	EFFECT:Think()
---------------------------------------------------------*/
function EFFECT:Think()

	return false
end

/*---------------------------------------------------------
	EFFECT:Render()
---------------------------------------------------------*/
function EFFECT:Render()
end
