if SERVER then
   resource.AddFile("models/grim/grim.mdl")
end

ITEM.Name = 'Grim Reaper'
ITEM.Price = 99999999
ITEM.Model = 'models/grim/grim.mdl'
ITEM.AdminOnly = true
ITEM.Karma = 150

function ITEM:OnEquip(ply, modifications)
		if not ply._OldModel then
			ply._OldModel = ply:GetModel()
		end	
		timer.Simple(1, function() ply:SetModel(self.Model) end)
end

function ITEM:OnHolster(ply)
	if ply._OldModel then
		ply:SetModel(ply._OldModel)
	end
end
