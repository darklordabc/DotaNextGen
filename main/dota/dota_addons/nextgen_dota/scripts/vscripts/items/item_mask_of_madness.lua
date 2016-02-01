
--[[ ============================================================================================================
	Author: Rook
	Date: February 4, 2015
	Called when the unit lands an attack on a target.  Applies a brief lifesteal modifier if not attacking a structure 
	(Lifesteal blocks in KV files will normally allow the unit to heal when attacking these).
================================================================================================================= ]]
function modifier_item_mask_of_madness_datadriven_on_orb_impact(keys)
	if keys.target.GetInvulnCount == nil then
		keys.target:AddNewModifier(keys.attacker, keys.attacker, "modifier_item_mask_of_madness_lifesteal", {duration = 0.03})
	end
end