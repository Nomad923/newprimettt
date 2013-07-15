ITEM.Name = 'Dunce Hat'
ITEM.Price = 2000
ITEM.Model = 'models/duncehat/duncehat.mdl'
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	--model:SetModelScale(1.6, 0)
	ang:RotateAroundAxis(ang:Right(), 25)
	return model, pos, ang
end
