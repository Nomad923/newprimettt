
if SERVER then

   AddCSLuaFile( "shared.lua" )
   
end

SWEP.HoldType           = "crossbow"

BOLT_MODEL			= "models/crossbow_bolt.mdl"

BOLT_AIR_VELOCITY	= 4000
BOLT_WATER_VELOCITY	= 1500
BOLT_SKIN_NORMAL	= 0
BOLT_SKIN_GLOW		= 1

CROSSBOW_GLOW_SPRITE	= "sprites/light_glow02_noz.vmt"
CROSSBOW_GLOW_SPRITE2	= "sprites/blueflare1.vmt"

if CLIENT then
   
   SWEP.PrintName          = "Crossbow"           
   SWEP.Author             = "Urban"
   SWEP.Slot               = 6
   SWEP.SlotPos            = 1
   SWEP.IconLetter         = "w"
   SWEP.Icon = "VGUI/ttt/icon_crossbow"
   
   SWEP.ViewModelFlip = false
end

if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_wds_crossbow.vmt")
end

SWEP.Base               = "weapon_tttbase"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_ROLE

SWEP.AutoReload = true

SWEP.Primary.Tracer = 1
SWEP.Primary.Delay          = 2
SWEP.Primary.Recoil         = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Damage = 1000
SWEP.Primary.NumShots		= 1
SWEP.Primary.NumAmmo		= SWEP.Primary.NumShots
SWEP.Primary.Force = 100
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.ClipMax = 1
SWEP.AutoReload          = true
SWEP.AmmoEnt = ""
SWEP.Primary.AmmoType		= "crossbow_bolt"
SWEP.AutoSpawnable      = false
SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 50

SWEP.Primary.Reload	= Sound( "Weapon_Crossbow.Reload" )
SWEP.Primary.Sound = Sound ("Weapon_Crossbow.Single")
SWEP.Primary.Special1		= Sound( "Weapon_Crossbow.BoltElectrify" )
SWEP.Primary.Special2		= Sound( "Weapon_Crossbow.BoltFly" )

--SWEP.IronSightsPos        = Vector( 5, 0, 1 )
SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true

SWEP.fingerprints = {}

SWEP.EquipMenuData = {
   type = "Weapon",
   model="models/weapons/w_crossbow.mdl",
   desc = "Crossbow Silenced. \n Bam and they're dead!\nMade by Urban."

};
SWEP.AllowDrop = true 
SWEP.AllowPickup = false
SWEP.IsSilent = true

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED
   
function SWEP:Precache()

	util.PrecacheSound( "Weapon_Crossbow.BoltHitBody" );
	util.PrecacheSound( "Weapon_Crossbow.BoltHitWorld" );
	util.PrecacheSound( "Weapon_Crossbow.BoltSkewer" );

	util.PrecacheModel( CROSSBOW_GLOW_SPRITE );
	util.PrecacheModel( CROSSBOW_GLOW_SPRITE2 ); 

	self.BaseClass:Precache();

end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
      
	if ( self.m_bInZoom && IsMultiplayer() ) then
//		self:FireSniperBolt();
		self:FireBolt();
	else
		self:FireBolt();
	end
	
	// Signal a reload
	self.m_bMustReload = true;

end

function SWEP:Deploy()
   self.Weapon:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return true
end

function SWEP:SetZoom(state)
    if CLIENT then 
       return
    else
       if state then
          self.Owner:SetFOV(30, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end
    
    bIronsights = not self:GetIronsights()
    
    self:SetIronsights( bIronsights )
    
    if SERVER then
        self:SetZoom(bIronsights)
    end
    
    self.Weapon:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
    self:SetIronsights( false )
    self:SetZoom(false)
end  

function SWEP:Reload()
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
    self:SetIronsights( false )
    self:SetZoom(false)
end


function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local x = ScrW() / 2.0
         local y = ScrH() / 2.0
         local scope_size = ScrH()

         -- crosshair
         local gap = 1000
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 0
         length = 0
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)

         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x - 20, y, x + 20, y + 0)
		 surface.DrawLine(x - 15, y + 10, x + 15, y + 10)
		 surface.DrawLine(x - 10, y + 20, x + 10, y + 20)
		 surface.DrawLine(x - 5, y + 30, x + 5, y + 30)
		 surface.DrawLine(x - 2.5, y + 40, x + 3, y + 40)
		 surface.DrawLine(x, y - 15, x + 0, y + 55)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)

      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end

   function SWEP:FireBolt()

	if ( self.Weapon:Clip1() <= 0 && self.Primary.ClipSize > -1 ) then
		if ( self:Ammo1() > 3 ) then
			self:Reload();
	        self:ShootBullet( 150, 1, 0.01 )
		else
			self.Weapon:SetNextPrimaryFire( 5 );
		
		end

		return;
	end

	local pOwner = self.Owner;

	if ( pOwner == NULL ) then
		return;
	end

if ( !CLIENT ) then
	local vecAiming		= pOwner:GetAimVector();
	local vecSrc		= pOwner:GetShootPos();

	local angAiming;
	angAiming = vecAiming:Angle();

	local pBolt = ents.Create ( self.Primary.AmmoType );
	pBolt:SetPos( vecSrc );
	pBolt:SetAngles( angAiming );
	pBolt.Damage = self.Primary.Damage;
		self:ShootBullet( 150, 1, 0.01 )
    pBolt.AmmoType = self.Primary.Ammo;
	pBolt:SetOwner( pOwner );
	pBolt:Spawn()

	if ( pOwner:WaterLevel() == 3 ) then
		pBolt:SetVelocity( vecAiming * BOLT_WATER_VELOCITY );
	else
		pBolt:SetVelocity( vecAiming * BOLT_AIR_VELOCITY );
	end

end

	self:TakePrimaryAmmo( self.Primary.NumAmmo );

	if ( !pOwner:IsNPC() ) then
		pOwner:ViewPunch( Angle( -2, 0, 0 ) );
	end

	self.Weapon:EmitSound( self.Primary.Sound );
	self.Owner:EmitSound( self.Primary.Special2 );

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay );
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay );

	// self:DoLoadEffect();
	// self:SetChargerState( CHARGER_STATE_DISCHARGE );

end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:SetDeploySpeed( speed )

	self.m_WeaponDeploySpeed = tonumber( speed / GetConVarNumber( "phys_timescale" ) )

	self.Weapon:SetNextPrimaryFire( CurTime() + speed )
	self.Weapon:SetNextSecondaryFire( CurTime() + speed )

end

function SWEP:WasBought(buyer)
   if IsValid(buyer) then -- probably already self.Owner
      buyer:GiveAmmo( 6, "XBowBolt" )
   end
end 