if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile("sound/siege/jihad.wav");
   resource.AddFile("sound/siege/gay.wav");
   resource.AddFile("sound/siege/big_explosion.wav");
end

// Variables that are used on both client and server

SWEP.Author			= "Gaz492"
SWEP.Contact		= "gaz492@gaz492.co.uk"
SWEP.Purpose		= "Sacrifice yourself for Allah."
SWEP.Instructions	= "Left Click to make yourself EXPLODE. Right click to taunt."
SWEP.DrawCrosshair		= false

SWEP.EquipMenuData = {
      type="Weapon",
      model="models/weapons/w_jb.mdl",
      name="Jihad Bomb",
      desc="Suicude bomb that will hug your friends. /n Please note this is non-refundable after use."
   };

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy

SWEP.ViewModel  = Model("models/weapons/v_jb.mdl")
SWEP.WorldModel = Model("models/weapons/w_jb.mdl")

SWEP.PrintName			= "Jihad Bomb"			
SWEP.Slot				= 3
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 2.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.0

SWEP.NoSights = true
/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
end   

function SWEP:Initialize()
    util.PrecacheSound("siege/big_explosion.wav")
    util.PrecacheSound("siege/jihad.wav")
	util.PrecacheSound("siege/gay.wav")
end


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
self.Weapon:SetNextPrimaryFire(CurTime() + 3)

	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetPos() )
		effectdata:SetNormal( self.Owner:GetPos() )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )
	util.Effect( "Sparks", effectdata )
	
	self.BaseClass.ShootEffects( self )
	
	
	// The rest is only done on the server
	if (SERVER) then
		timer.Simple(2, function() self:Asplode() end )
		self.Owner:EmitSound( "siege/jihad.wav" , 511 , 100 )
	end

end

--The asplode function
function SWEP:Asplode()
local k, v
	
	// Make an explosion at your position
	local ent = ents.Create( "env_explosion" )
		ent:SetPos( self.Owner:GetPos() )
		ent:SetOwner( self.Owner )
		ent:Spawn()
		ent:SetKeyValue( "iMagnitude", "250" )
		ent:Fire( "Explode", 0, 0 )
		ent:EmitSound( "siege/big_explosion.wav", 511, 100 )		
		self.Owner:Kill( )
		self:Remove()
 
		for k, v in pairs( player.GetAll( ) ) do
		  v:ConCommand( "play siege/big_explosion.wav\n" )
		end

end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()	
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	
	local TauntSound = Sound( "vo/npc/male01/overhere01.wav" )

	self.Weapon:EmitSound( TauntSound )
	
	// The rest is only done on the server
	if (!SERVER) then return end
	
	self.Weapon:EmitSound( TauntSound )


end