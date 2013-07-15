ITEM.Name = 'Midna Hat'
ITEM.Price = 2000
ITEM.Model = 'models/gmod_tower/midnahat.mdl'
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -3.5)
	return model, pos, ang
end
