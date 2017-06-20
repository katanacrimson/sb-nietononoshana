require "/scripts/util.lua"
require "/scripts/rect.lua"
require "/items/active/weapons/weapon.lua"
require "/items/active/weapons/melee/abilities/hammer/shockwave/shockwave.lua"

BurnUp = WeaponAbility:new()

function BurnUp:init()
  self.cooldownTimer = self.cooldownTime
end

function BurnUp:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  self.cooldownTimer = math.max(0, self.cooldownTimer - self.dt)

  if self.weapon.currentAbility == nil
      and self.cooldownTimer == 0
      and self.fireMode == (self.activatingFireMode or self.abilitySlot)
      and mcontroller.onGround()
      and not status.resourceLocked("energy") then

    self:setState(self.windup)
  end
end

-- Attack state: windup
function BurnUp:windup()
  self.weapon:setStance(self.stances.windup)
  self.weapon:updateAim()

  util.wait(self.stances.windup.duration)

  self:setState(self.fire)
end

-- Attack state: fire
function BurnUp:fire()
  self.weapon:setStance(self.stances.fire)

  self:fireShockwave()
  animator.playSound("fire")

  util.wait(self.stances.fire.duration)

  self.cooldownTimer = self.cooldownTime
end

function BurnUp:reset()

end

function BurnUp:uninit()
  self:reset()
end

-- Helper functions
function BurnUp:fireShockwave()
  return ShockWave.fireShockwave(self, 1.0)
end

function BurnUp:impactPosition()
  return ShockWave.impactPosition(self)
end

function BurnUp:shockwaveProjectilePositions(impactPosition, maxDistance, directions)
  return ShockWave.shockwaveProjectilePositions(self, impactPosition, maxDistance, directions)
end
