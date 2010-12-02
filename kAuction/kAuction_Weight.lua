-- Author      : Gabe
-- Create Date : 9/23/2009 3:35:29 AM
function kAuction:Weight_AddStat(weightId, statId, value)
	local iIndex = kAuction:Weight_GetIndexById(weightId);
	-- Ensure proper wishlist is manipulated
	if kAuction.db.profile.weights[iIndex] then
		if not kAuction.db.profile.weights[iIndex].stats then
			kAuction.db.profile.weights[iIndex].stats = {};
		end
		-- Check if stat exists
		if not kAuction:Weight_IsStatInWeight(weightId, statId) then
			local uid = kAuction:Weight_GetUniqueStatId(weightId);
			tinsert(kAuction.db.profile.weights[iIndex].stats, {
				id = statId,
				uid = uid,
				value = value,
			});
		else
			kAuction:Print("Stat Id: " .. statId .. " already exists in Weight Scale " .. kAuction.db.profile.weights[iIndex].name .. " -- cancelling addition.");
		end
	end
end
function kAuction:Weight_AddNextValidStat(weightId)
	-- Loop through stat types, check for stat not found in weight scale
	local iIndex = kAuction:Weight_GetIndexById(weightId);
	-- Ensure proper wishlist is manipulated
	if iIndex then
		for iId,vId in pairs(kAuction.gui.stats.ids) do
			if not kAuction:Weight_IsStatInWeight(weightId, vId) then
				-- Found non-match
				kAuction:Weight_AddStat(weightId, vId, 1);
				return true;
			end
		end
		-- All stats exist, abort
		kAuction:Print("All Valid Statistic types exist for Weight Scale " .. kAuction.db.profile.weights[iIndex].name .. " -- cancelling addition.");
	end
	return false;
end
function kAuction:Weight_Create(name, enabled)
	-- Check if exists
	local iId = kAuction:Weight_GetIdByName(name);
	local iIndex = kAuction:Weight_GetIndexById(iId);
	if kAuction.db.profile.weights[iIndex] then -- Exists, return id
		return iId;	
	else -- Doesn't exist, create
		local id = kAuction:Weight_GetUniqueId();
		local tGems = kAuction:Weight_GetGemDropdownTable();
		if tGems then
			local gemName = nil;
			for i,v in pairs(tGems) do
				gemName = i;
			end
			local tGemMeta = kAuction:Weight_GetGemDropdownTable(true);
			local gemMeta = nil;
			for i,v in pairs(tGemMeta) do
				gemMeta = i;
			end
			tinsert(kAuction.db.profile.weights, {
				id = id,
				name = name,
				enabled = enabled,
				comparison = false,
				gems = {red = {id = kAuction:Weight_GetGemItemIdByName(gemName), name = gemName, itemLinkId = kAuction.StatLogic:GetGemID(kAuction:Weight_GetGemItemIdByName(gemName))}, blue = {id = kAuction:Weight_GetGemItemIdByName(gemName), name = gemName, itemLinkId = kAuction.StatLogic:GetGemID(kAuction:Weight_GetGemItemIdByName(gemName))}, yellow = {id = kAuction:Weight_GetGemItemIdByName(gemName), name = gemName, itemLinkId = kAuction.StatLogic:GetGemID(kAuction:Weight_GetGemItemIdByName(gemName))}, meta = {id = kAuction:Weight_GetGemItemIdByName(gemMeta), name = gemMeta, itemLinkId = kAuction.StatLogic:GetGemID(kAuction:Weight_GetGemItemIdByName(gemMeta))}},
			});
		else
			tinsert(kAuction.db.profile.weights, {
				id = id,
				name = name,
				enabled = enabled,
				comparison = false,
				gems = {},
			});
		end
		-- Add default stat
		kAuction:Weight_AddNextValidStat(id);
		return id;		
	end
end
function kAuction:Weight_GetActiveWeightList()
	local tOutput = {};
	for i,v in pairs(kAuction.db.profile.weights) do
		if v.enabled then
			if v.defaultClass then
				if v.defaultClass == UnitClass("player") then
					tinsert(tOutput, v);
				end
			else
				tinsert(tOutput, v);
			end
		end
	end
	if tOutput and #tOutput > 0 then
		return tOutput;
	else
		return nil;
	end
end
function kAuction:Weight_GetIdByName(name)
	for i,weight in pairs(kAuction.db.profile.weights) do
		if strlower(weight.name) == strlower(name) then
			-- Item exists already
			return wishlist.id;
		end
	end	
	return nil;
end
function kAuction:Weight_GetIndexById(id)
	for i,weight in pairs(kAuction.db.profile.weights) do
		if tonumber(weight.id) == tonumber(id) then
			-- Item exists already
			return i;
		end
	end	
	return nil;
end
function kAuction:Weight_GetStatIndexByUid(weightId, statUid)
	local iIndex = kAuction:Weight_GetIndexById(weightId);
	if iIndex then
		for i,stat in pairs(kAuction.db.profile.weights[iIndex].stats) do
			if tonumber(stat.uid) == tonumber(statUid) then
				-- Item exists already
				return i;
			end
		end	
		return nil;
	end
end
function kAuction:Weight_ShowSummaryTooltip(weightId, itemId, widget, comparison)
	if comparison then
		local iSlot = kAuction:Item_GetEquipSlotNumberOfItem(itemId);
		local currItemId = kAuction:Item_GetItemIdFromItemLink(GetInventoryItemLink("player", iSlot));
		local oSumCurr = kAuction:Weight_GetItemScoreSummaryTable(weightId, currItemId);
		local oSumCurr2;
		local currItemId2;
		if iSlot == 11 or iSlot == 13 then -- Finger or Trinket
			currItemId2 = kAuction:Item_GetItemIdFromItemLink(GetInventoryItemLink("player", iSlot + 1));
			oSumCurr2 = kAuction:Weight_GetItemScoreSummaryTable(weightId, currItemId2);
		end
		local oSum = kAuction:Weight_GetItemScoreSummaryTable(weightId, itemId);
		GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
		GameTooltip:ClearLines();
		GameTooltip:SetPoint("TOPRIGHT", widget, "TOPLEFT");
		GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Weight Score Summary|n|r");
		if oSumCurr then
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0) .. "Equipped Item -|r " .. select(2, GetItemInfo(currItemId)));
			local iScore = 0;
			table.sort(oSumCurr, function(a,b)
				if tostring(a.id) < tostring(b.id) then
					return true;
				else
					return false;
				end
			end);
			for i,v in pairs(oSumCurr) do
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1) .. kAuction:Weight_GetStatNameFromId(v.id) .. " - |r |cFF"..kAuction:RGBToHex(255,255,255,1).."Weight:|r " .. v.weight .. "|cFF"..kAuction:RGBToHex(255,255,255,1)..", Sum:|r " .. v.sum .. "|cFF"..kAuction:RGBToHex(255,255,255,1).." = " .. v.weight .. " * " .. v.sum .. " =|r " .. v.score);
				iScore = iScore + v.score;
			end
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1) .. "Total Score:|r " .. iScore .. "|n|n");
		else
			if iSlot == 11 or iSlot == 13 then -- Finger or Trinket
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0) .. "No Currently Equipped Item #1|r|n|n");
			else
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0) .. "No Currently Equipped Item|r|n|n");
			end
		end	
		if oSumCurr2 then
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0) .. "Equipped Item -|r " .. select(2, GetItemInfo(currItemId2)));
			local iScore = 0;
			table.sort(oSumCurr2, function(a,b)
				if tostring(a.id) < tostring(b.id) then
					return true;
				else
					return false;
				end
			end);
			for i,v in pairs(oSumCurr2) do
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1) .. kAuction:Weight_GetStatNameFromId(v.id) .. " - |r |cFF"..kAuction:RGBToHex(255,255,255,1).."Weight:|r " .. v.weight .. "|cFF"..kAuction:RGBToHex(255,255,255,1)..", Sum:|r " .. v.sum .. "|cFF"..kAuction:RGBToHex(255,255,255,1).." = " .. v.weight .. " * " .. v.sum .. " =|r " .. v.score);
				iScore = iScore + v.score;
			end
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1) .. "Total Score:|r " .. iScore .. "|n|n");
		else
			if iSlot == 11 or iSlot == 13 then -- Finger or Trinket
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0) .. "No Currently Equipped Item #2|r|n|n");
			end
		end	
		if oSum then
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0) .. "This Item - |r " .. select(2, GetItemInfo(itemId)));
			local iScore = 0;
			table.sort(oSum, function(a,b)
				if tostring(a.id) < tostring(b.id) then
					return true;
				else
					return false;
				end
			end);
			for i,v in pairs(oSum) do
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1) .. kAuction:Weight_GetStatNameFromId(v.id) .. " - |r |cFF"..kAuction:RGBToHex(255,255,255,1).."Weight:|r " .. v.weight .. "|cFF"..kAuction:RGBToHex(255,255,255,1)..", Sum:|r " .. v.sum .. "|cFF"..kAuction:RGBToHex(255,255,255,1).." = " .. v.weight .. " * " .. v.sum .. " =|r " .. v.score);
				iScore = iScore + v.score;
			end
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1) .. "Total Score:|r " .. iScore);
			GameTooltip:Show();
		end	
	else
		local oSum = kAuction:Weight_GetItemScoreSummaryTable(weightId, itemId);
		if oSum then
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:ClearLines();
			GameTooltip:SetPoint("TOPRIGHT", widget, "TOPLEFT");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Weight Score Summary|n|r");
			GameTooltip:AddLine(select(2, GetItemInfo(itemId)));
			local iScore = 0;
			table.sort(oSum, function(a,b)
				if tostring(a.id) < tostring(b.id) then
					return true;
				else
					return false;
				end
			end);
			for i,v in pairs(oSum) do
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1) .. kAuction:Weight_GetStatNameFromId(v.id) .. " - |r |cFF"..kAuction:RGBToHex(255,255,255,1).."Weight:|r " .. v.weight .. "|cFF"..kAuction:RGBToHex(255,255,255,1)..", Sum:|r " .. v.sum .. "|cFF"..kAuction:RGBToHex(255,255,255,1).." = " .. v.weight .. " * " .. v.sum .. " =|r " .. v.score);
				iScore = iScore + v.score;
			end
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1) .. "Total Score:|r " .. iScore);
			GameTooltip:Show();
		end
	end
end
function kAuction:Weight_GetItemScoreSummaryTable(weightId, itemId)
	local iIndex = kAuction:Weight_GetIndexById(weightId);
	if iIndex and itemId then
		-- Build gemmed link
		local oSum = kAuction.StatLogic:GetSum("Hitem:"..itemId..":0:"..kAuction.db.profile.weights[iIndex].gems.red.itemLinkId..":"..kAuction.db.profile.weights[iIndex].gems.yellow.itemLinkId..":"..kAuction.db.profile.weights[iIndex].gems.blue.itemLinkId..":"..kAuction.db.profile.weights[iIndex].gems.meta.itemLinkId..":0:0");
		if oSum then
			if kAuction.db.profile.weights[iIndex].stats and #kAuction.db.profile.weights[iIndex].stats > 0 then
				local oOutput = {};
				-- Hack for ARMOR_BONUS
				if oSum['ARMOR_BONUS'] then
					if oSum['ARMOR'] then
						oSum['ARMOR'] = oSum['ARMOR'] + oSum['ARMOR_BONUS'];
					else
						oSum['ARMOR'] = oSum['ARMOR_BONUS'];
					end
				end
				-- Loop through item stats
				for iSum,vSum in pairs(oSum) do
					-- Check for valid StatId
					-- Loop through weight stats, check for match
					for iStat,vStat in pairs(kAuction.db.profile.weights[iIndex].stats) do
						if vStat.id == iSum then
							tinsert(oOutput, {id = vStat.id, weight = vStat.value, sum = vSum, score = vStat.value * vSum});
						end
					end
				end
				if #oOutput > 0 then
					return oOutput;
				end
			end
		end
	end
	return nil;
end
function kAuction:Weight_GetItemScore(weightId, itemId, comparison, comparisonItemId)
	local oSum = kAuction:Weight_GetItemScoreSummaryTable(weightId, itemId);
	local iScore = 0;
	local iScoreCurr = 0;	
	local iScoreCurr2 = 0;	
	if oSum then -- Summary exists
		-- Total score values
		for i,v in pairs(oSum) do
			iScore = iScore + v.score;
		end	
		if comparison then
			if comparisonItemId then
				local oSumCurr = kAuction:Weight_GetItemScoreSummaryTable(weightId, comparisonItemId);
				if oSumCurr then
					for i,v in pairs(oSumCurr) do
						iScoreCurr = iScoreCurr + v.score;
					end
				end
				return iScore - iScoreCurr;							
			else
				-- Get current item slot item
				local id = kAuction:Item_GetEquipSlotNumberOfItem(itemId);
				if id then
					-- Hack for finger/trinket double items
					if id == 11 or id == 13 then
						local currentItemLink1 = GetInventoryItemLink("player", id);
						if currentItemLink1 then
							local oSumCurr = kAuction:Weight_GetItemScoreSummaryTable(weightId, kAuction:Item_GetItemIdFromItemLink(currentItemLink1));
							if oSumCurr then
								for i,v in pairs(oSumCurr) do
									iScoreCurr = iScoreCurr + v.score;
								end
							end
						end
						local currentItemLink2 = GetInventoryItemLink("player", id + 1);
						if currentItemLink2 then
							local oSumCurr2 = kAuction:Weight_GetItemScoreSummaryTable(weightId, kAuction:Item_GetItemIdFromItemLink(currentItemLink2));
							if oSumCurr2 then
								for i,v in pairs(oSumCurr2) do
									iScoreCurr2 = iScoreCurr2 + v.score;
								end
							end
						end
						if iScore - iScoreCurr > iScore - iScoreCurr2 then
							return iScore - iScoreCurr;					
						else
							return iScore - iScoreCurr2;
						end
					else
						local currentItemLink = GetInventoryItemLink("player", id);
						if currentItemLink then
							local oSumCurr = kAuction:Weight_GetItemScoreSummaryTable(weightId, kAuction:Item_GetItemIdFromItemLink(currentItemLink));
							if oSumCurr then
								for i,v in pairs(oSumCurr) do
									iScoreCurr = iScoreCurr + v.score;
								end
								return iScore - iScoreCurr;
							end
						end
					end
				end
			end
		end	
		return iScore;
	end
	return nil;
end
function kAuction:Weight_GetGemDropdownTable(meta)
	local tTemp = {};
	table.sort(kAuction.gui.gems, function(a,b)
		if strlower(a.name) < strlower(b.name) then
			return true;
		else
			return false;
		end
	end);	
	for i,v in pairs(kAuction.gui.gems) do
		-- Check rarity and item level
		if v.level >= kAuction.db.profile.wishlist.config.gemMinItemLevel then
			-- Check if meta
			if meta then
				if v.subType == "Meta" then
					tTemp[v.name] = v.name; 
				end
			elseif v.rarity >= kAuction.db.profile.wishlist.config.gemMinRarity then
				tTemp[v.name] = v.name; 
			end
		end
	end
	return tTemp;
end
function kAuction:Weight_GetGemItemIdByName(name)
	for i,v in pairs(kAuction.gui.gems) do
		if v.name == name then
			return v.id;
		end
	end
	return nil;
end
function kAuction:Weight_GetStatNameFromId(id)
	local strName = kAuction.StatLogic:GetStatNameFromID(id);
	if strName then
		-- Hack for spell pretext removal
		if strName == 'Spell Crit Rating' then
			strName = 'Crit Rating';
		end
		if strName == 'Spell Hit Rating' then
			strName = 'Hit Rating';
		end
		if strName == 'Spell Haste Rating' then
			strName = 'Haste Rating';
		end
		if strName == 'Spell Damage' then
			strName = 'Spell Power';
		end
		return strName;
	end
	return nil;
end
function kAuction:Weight_GetStatDropdownTable()
	local tTemp = {};
	for i,v in pairs(kAuction.gui.stats.ids) do
		local strName = kAuction:Weight_GetStatNameFromId(v);
		if strName then
			tTemp[v] = strName; 
		end
	end
	--table.sort(tTemp);
	return tTemp;
end
function kAuction:Weight_GetUniqueId()
	local newId
	local isValidId = false;
	while isValidId == false do
		matchFound = false;
		newId = (math.random(0,2147483647) * -1);
		for i,val in pairs(kAuction.db.profile.weights) do
			if val.id == newId then
				matchFound = true;
			end
		end
		if matchFound == false then
			isValidId = true;
		end
	end
	return newId;
end
function kAuction:Weight_GetUniqueStatId(weightId)
	local newId
	if not kAuction:Weight_GetIndexById(weightId) then
		return nil;
	end
	local iWeight = kAuction:Weight_GetIndexById(weightId);
	local isValidId = false;
	while isValidId == false do
		matchFound = false;
		newId = (math.random(0,2147483647) * -1);
		for i,val in pairs(kAuction.db.profile.weights[iWeight].stats) do
			if val.id == newId then
				matchFound = true;
			end
		end
		if matchFound == false then
			isValidId = true;
		end
	end
	return newId;
end
function kAuction:Weight_GetWeightById(id)
	if kAuction.db.profile.weights and id then
		for i,v in pairs(kAuction.db.profile.weights) do
			if id == v.id then
				return v;
			end
		end
	end
	return nil;
end
function kAuction:Weight_GetNameById(id)
	for i,weight in pairs(kAuction.db.profile.weights) do
		if weight.id == id then
			-- Item exists already
			return weight.name;
		end
	end	
	return nil;
end
function kAuction:Weight_GetWeights()
	local tReturn = {};
	for i,v in pairs(kAuction.db.profile.weights) do
		if v.defaultClass then
			if v.defaultClass == UnitClass("player") then
				tinsert(tReturn, v);
			end
		else
			tinsert(tReturn, v);
		end
	end
	if tReturn and #tReturn > 0 then
		return tReturn;
	else
		return nil;
	end
end
function kAuction:Weight_IsStatInWeight(weightId, statId)
	local iIndex = kAuction:Weight_GetIndexById(weightId);
	-- Ensure proper weight is manipulated
	if kAuction.db.profile.weights[iIndex] then
		-- Loop through stats
		if kAuction.db.profile.weights[iIndex].stats then
			for iStat, vStat in pairs(kAuction.db.profile.weights[iIndex].stats) do
				if vStat.id == statId then
					return iStat;
				end	
			end
		end
		return false;
	end	
end
function kAuction:Weight_SetStatFlag(weightId, statId, flagType, value)
	local listIndex = kAuction:Weight_GetIndexById(weightId);
	if listIndex then
		kAuction.db.profile.weights[listIndex][flagType] = value;
		return true;
	end
	return false;
end
function kAuction:Weight_SetWeightFlag(weightId, flagType, value)
	local listIndex = kAuction:Weight_GetIndexById(weightId);
	if listIndex then
		kAuction.db.profile.weights[listIndex][flagType] = value;
		return true;
	end
	return false;
end
function kAuction:Weight_RemoveWeight(id)
	local index = kAuction:Weight_GetIndexById(id);
	if index then
		-- Remove item from local
		tremove(kAuction.db.profile.weights, index);
	end	
end
function kAuction:Weight_RemoveStat(weightId, statId)
	local index = kAuction:Weight_GetIndexById(weightId);
	local statIndex = kAuction:Weight_IsStatInWeight(weightId, statId);
	if statIndex then
		if kAuction.db.profile.weights[index].stats[statIndex] then
			-- Remove stat from local
			tremove(kAuction.db.profile.weights[index].stats, statIndex);
		end
	end	
end