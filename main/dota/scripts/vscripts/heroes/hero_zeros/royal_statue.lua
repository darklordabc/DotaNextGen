function FaceDirectionOfCaster( keys )
	local caster = keys.caster
	local target = keys.target
	local casterVec = caster:GetForwardVector()
	local ability = keys.ability
	local health = ability:GetLevelSpecialValueFor("health", ability:GetLevel() - 1)
	local bounty = ability:GetLevelSpecialValueFor("bounty", ability:GetLevel() - 1)

	target:SetForwardVector(casterVec)
	target:SetBaseMaxHealth(health)
	target:SetMinimumGoldBounty(bounty)
	target:SetMaximumGoldBounty(bounty)
end

function FindAbilityMalice( keys )
	local caster = keys.caster
	local target = keys.target
	local attacker = keys.attacker
	local ability = keys.ability

	local maliceAbility = caster:FindAbilityByName("zeros_blade_of_malice")

	if maliceAbility and maliceAbility:GetLevel() > 0 and not attacker:IsMagicImmune() then
		maliceAbility:ApplyDataDrivenModifier(caster, attacker, "modifier_malice_debuff", {duration=8.0})
	end
end

function BonusGold (keys )
	local caster = keys.caster
	local target = keys.unit
	local attacker = keys.attacker
	local ability = keys.ability

	if target:HasModifier("modifier_statue_effect_creep") then

		local player = PlayerResource:GetPlayer( attacker:GetPlayerID() )
		local playerID = attacker:GetPlayerOwnerID()

		local bonus_gold = ability:GetLevelSpecialValueFor("bonus_gold", ability:GetLevel() - 1)
		attacker:ModifyGold(bonus_gold, false, 0)

		local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"		
		local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, target, player )
		ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin() )


		local value = bonus_gold
		local symbol = 0 -- "+" presymbol
		local color = Vector(255, 200, 33) -- Gold
		local lifetime = 2.0
		local digits = string.len(value) + 1
		local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"
		local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, target, player )
		ParticleManager:SetParticleControl( particle, 1, Vector( symbol, value, symbol) )
	    ParticleManager:SetParticleControl( particle, 2, Vector( lifetime, digits, 0) )
	    ParticleManager:SetParticleControl( particle, 3, color )
	end
end

function ApplyDamageReductionStacks( keys )
	local caster = keys.caster
	local target = keys.target
	local attacker = keys.attacker
	local ability = keys.ability
	local modifierName = "modifier_statue_debuff_stack"
	local duration = ability:GetLevelSpecialValueFor("debuff_duration", ability:GetLevel() - 1)

	if not attacker:IsBuilding() and not attacker:IsMagicImmune() then
		local stack = attacker:GetModifierStackCount(modifierName, ability)
		ability:ApplyDataDrivenModifier(target, attacker, modifierName, {Duration = duration})
		attacker:SetModifierStackCount(modifierName, ability, stack + 1)
	end
end

