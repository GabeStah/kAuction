-- Author      : Gabe
-- Create Date : 2/19/2009 12:42:59 AM
function kAuction:Wishlist_AddItem(wishlistId, name, itemId)
	local iIndex = kAuction:Wishlist_GetIndexById(wishlistId);
	-- Ensure proper wishlist is manipulated
	if self.db.profile.wishlists[iIndex] then
		if not self.db.profile.wishlists[iIndex].items then
			self.db.profile.wishlists[iIndex].items = {};
		end
		local bidType = "normal";
		if strlower(self.db.profile.wishlists[iIndex].name) == "normal" then
			bidType = strlower(self.db.profile.wishlists[iIndex].name);
		elseif strlower(self.db.profile.wishlists[iIndex].name) == "offspec" then
			bidType = strlower(self.db.profile.wishlists[iIndex].name);
		elseif strlower(self.db.profile.wishlists[iIndex].name) == "rot" then
			bidType = strlower(self.db.profile.wishlists[iIndex].name);
		end 
		local itemLevel = nil;
		local itemSlot = nil;
		if GetItemInfo(itemId) then
			itemLevel = select(4, GetItemInfo(itemId));
			itemSlot = kAuction:Item_GetEquipSlotNumberOfItem(select(2, GetItemInfo(itemId)), 'formattedName');
		end
		tinsert(self.db.profile.wishlists[iIndex].items, {
			alert = true,
			autoBid = true,
			autoRemove = true,
			bestInSlot = false,
			bidType = bidType,
			id = itemId,
			level = itemLevel,
			name = name,
			setBonus = false,
			slot = itemSlot,
		});
	end
end
function kAuction:Wishlist_CreateOptionTable()
	self.options.args.wishlist.args = {};
	self.options.args.wishlist.args.header = {
		name = 'General Settings',
		type = 'header',
		order = 1,
	};		
	self.options.args.wishlist.args.enabled = {
		name = 'Enabled',
		type = 'toggle',
		desc = 'Enable Wishlist functionality.',
		set = function(info,value) self.db.profile.wishlist.enabled = value end,
		get = function(info) return self.db.profile.wishlist.enabled end,
		order = 2,
	};
	self.options.args.wishlist.args.autoUpdate = {
		name = 'Auto-Update',
		type = 'toggle',
		desc = 'Allow kAuction to automatically update your Wishlist data from AtlasLoot Wishlist data.',
		set = function(info,value)
			self.db.profile.wishlist.autoUpdate = value;
		end,
		get = function(info) return self.db.profile.wishlist.autoUpdate end,
		order = 3,
	};
	self.options.args.wishlist.args.forceUpdate = {
		name = 'Force Update',
		type = 'execute',
		desc = 'Manually force kAuction to update wishlist data from AtlasLoot Wishlists.',
		func = function() kAuction:Wishlist_UpdateFromAtlasLoot() end,
		order = 4,
	};
	if self.db.profile.wishlists and #self.db.profile.wishlists > 0 then
		for iList, vList in pairs(self.db.profile.wishlists) do
			self.options.args.wishlist.args[tostring(vList.id)] = {
				name = vList.name,
				type = 'group',
				cmdHidden = true,
				args = {
					items = {
						name = 'Items',
						type = 'group',
						guiInline = true,
						childGroups = 'tab',
						args = {},
					},
				},
			};			
			for iItem, vItem in pairs(vList.items) do
				self.options.args.wishlist.args[tostring(vList.id)].args.items.args[tostring(vItem.id)] = {
					name = vItem.name,
					type = 'group',
					args = {
						removeItem = {
							name = 'Remove Item',
							type = 'execute',
							desc = 'Remove this item from the Wishlist.',
							func = function()
								kAuction:Wishlist_RemoveItem(vList.id, vItem.id);
								kAuction:Wishlist_CreateOptionTable(); -- Refresh options
							end,
							order = 1,
						},			
						alert = {
							name = 'Alert',
							type = 'toggle',
							desc = 'Determines if kAuction will alert you when this item drops.  If Auto-bid is enabled, Alert will make kAuction provide a popup window alerting you that the item dropped and you auto-bid.  If auto-bid is not enabled, Alert will create a popup informing you the item dropped and asking if you want to bid.',
							set = function(info,value)
								kAuction:Wishlist_SetItemFlag(vList.id, vItem.id, 'alert', value);
							end,
							get = function(info)
								return kAuction:Wishlist_GetItemFlag(vList.id, vItem.id, 'alert');
							end,
							order = 2,
						},	
						autoBid = {
							name = 'Auto-bid',
							type = 'toggle',
							desc = 'Determines if kAuction will automatically bid for you when this item drops, using the Bid Type specified for the item.',
							set = function(info,value)
								kAuction:Wishlist_SetItemFlag(vList.id, vItem.id, 'autoBid', value);
							end,
							get = function(info)
								return kAuction:Wishlist_GetItemFlag(vList.id, vItem.id, 'autoBid');
							end,
							order = 3,
						},	
						bestInSlot = {
							name = 'Best In Slot',
							type = 'toggle',
							desc = 'Determines if this item is a Best in Slot drop for this wishlist.  The Best in Slot flag is transmitted to the raid during bidding to assist in decision making during Loot Council voting.',
							set = function(info,value)
								kAuction:Wishlist_SetItemFlag(vList.id, vItem.id, 'bestInSlot', value);
							end,
							get = function(info)
								return kAuction:Wishlist_GetItemFlag(vList.id, vItem.id, 'bestInSlot');
							end,
							order = 4,
						},
						bidType = {
							name = 'Auto-Bid Type',
							desc = 'Type of bid that will be used for this item.',
							type = 'select',
							values = {
								normal = 'Normal',
								offspec = 'Offspec',
								rot = 'Rot',
							},
							style = 'dropdown',
							set = function(info,value)
								kAuction:Debug("set bidtype: " .. value, 3);
								kAuction:Wishlist_SetItemFlag(vList.id, vItem.id, 'bidType', value);
							end,
							get = function(info)
								return kAuction:Wishlist_GetItemFlag(vList.id, vItem.id, 'bidType');
							end,
							order = 5,
						},
						setBonus = {
							name = 'Set Bonus',
							type = 'toggle',
							desc = 'Determines if this item will complete a set bonus for you.',
							set = function(info,value)
								kAuction:Wishlist_SetItemFlag(vList.id, vItem.id, 'setBonus', value);
							end,
							get = function(info)
								return kAuction:Wishlist_GetItemFlag(vList.id, vItem.id, 'setBonus');
							end,
							order = 6,
						},
					},
				};
			end
			--[[
			alert = true,
			autoBid = true,
			bestInSlot = false,
			bidType = bidType,
			id = id,
			name = name,
			setBonus = false,
			]]
		end
	end
	-- Check if AtlasLoot loaded
	if (IsAddOnLoaded("AtlasLoot")) then
		
	else
	--[[
		StaticPopupDialogs["kAuctionPopup_EnableAtlasLoot"] = {
			text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r|nWishlists are currently disabled as the AtlasLoot addon is not enabled.  Would you like to enable AtlasLoot now (Warning: Clicking 'Yes' will reload your User Interface)?",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				EnableAddOn("AtlasLoot");
				ReloadUI();
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1
		};
		StaticPopup_Show("kAuctionPopup_EnableAtlasLoot");
		]]
	end
end
-- PURPOSE: Creates a new Wishlist, else if wishlist exists by name, returns that list
function kAuction:Wishlist_Create(name, enabled, icon)
	-- Check if exists
	local iId = kAuction:Wishlist_GetIdByName(name);
	local iIndex = kAuction:Wishlist_GetIndexById(iId);
	if self.db.profile.wishlists[iIndex] then -- Exists, return id
		return iId;	
	else -- Doesn't exist, create
		local id = kAuction:Wishlist_GetUniqueWishlistId();
		tinsert(self.db.profile.wishlists, {
			id = id,
			name = name,
			enabled = true,
			icon = icon,
		});
		return id;		
	end
end
function kAuction:Wishlist_DoesWishlistExistInAtlas(wishlistId)
	local iIndex = kAuction:Wishlist_GetIndexById(wishlistId);
	-- Ensure proper wishlist is manipulated
	if self.db.profile.wishlists[iIndex] then
		local oAtlas = _G[self.const.wishlist.atlasLootTableName];
		if oAtlas then
			if oAtlas.Own[self.playerName] then
				for iList, vList in pairs(oAtlas.Own[self.playerName]) do
					if strlower(vList.info[1]) == strlower(self.db.profile.wishlists[iIndex].name) then
						return true;
					end
				end				
			end
		end
	end
	return false;
end
function kAuction:Wishlist_DoesWishlistItemExistInAtlas(wishlistId, itemId)
	local iIndex = kAuction:Wishlist_GetIndexById(wishlistId);
	-- Ensure proper wishlist is manipulated
	if self.db.profile.wishlists[iIndex] then
		local oAtlas = _G[self.const.wishlist.atlasLootTableName];
		if oAtlas then
			if oAtlas.Own[self.playerName] then
				for iList, vList in pairs(oAtlas.Own[self.playerName]) do
					if strlower(vList.info[1]) == strlower(self.db.profile.wishlists[iIndex].name) then
						-- Matching list, check for item
						for iItem, vItem in pairs(vList) do
							if iItem ~= "info" then
								if tonumber(vItem[2]) == tonumber(itemId) then
									return true;
								end
							end
						end
					end
				end				
			end
		end
	end
	return false;
end
function kAuction:Wishlist_FindItemByFlags(itemList, flags)
	for iItem, vItem in pairs(itemList) do
		local booMatchAllFlags = true;
		for iFlag, vFlag in pairs(flags) do
			if vItem[iFlag] ~= vFlag then
				booMatchAllFlags = false;				
			end
		end
		if booMatchAllFlags == true then
			return vItem;
		end
	end
end
function kAuction:Wishlist_GetHighestPriorityItemFromSet(itemList)
	local oPriorities = {
		{autoBid = true, bidType = 'normal', bestInSlot = true, setBonus = true},
		{alert = true, bidType = 'normal', bestInSlot = true, setBonus = true},
		{autoBid = true, bidType = 'normal', bestInSlot = true},
		{alert = true, bidType = 'normal', bestInSlot = true},
		{autoBid = true, bidType = 'normal', setBonus = true},
		{alert = true, bidType = 'normal', setBonus = true},
		{autoBid = true, bidType = 'normal'},
		{alert = true, bidType = 'normal'},
		{bidType = 'normal'},
		{autoBid = true, bidType = 'offspec', bestInSlot = true, setBonus = true},
		{alert = true, bidType = 'offspec', bestInSlot = true, setBonus = true},
		{autoBid = true, bidType = 'offspec', bestInSlot = true},
		{alert = true, bidType = 'offspec', bestInSlot = true},
		{autoBid = true, bidType = 'offspec', setBonus = true},
		{alert = true, bidType = 'offspec', setBonus = true},
		{autoBid = true, bidType = 'offspec'},
		{alert = true, bidType = 'offspec'},
		{bidType = 'offspec'},
		{autoBid = true, bidType = 'rot', bestInSlot = true, setBonus = true},
		{alert = true, bidType = 'rot', bestInSlot = true, setBonus = true},
		{autoBid = true, bidType = 'rot', bestInSlot = true},
		{alert = true, bidType = 'rot', bestInSlot = true},
		{autoBid = true, bidType = 'rot', setBonus = true},
		{alert = true, bidType = 'rot', setBonus = true},
		{autoBid = true, bidType = 'rot'},
		{alert = true, bidType = 'rot'},
		{bidType = 'rot'},
	};
	for i, v in pairs(oPriorities) do
		if kAuction:Wishlist_FindItemByFlags(itemList, v) then
			kAuction:Debug("Wishlist_GetHighestPriorityItemFromSet - priority match index " .. i, 1);
			return kAuction:Wishlist_FindItemByFlags(itemList, v);
		end
	end
end
function kAuction:Wishlist_GetIdByName(name)
	for i,wishlist in pairs(self.db.profile.wishlists) do
		if strlower(wishlist.name) == strlower(name) then
			-- Item exists already
			return wishlist.id;
		end
	end	
	return nil;
end
function kAuction:Wishlist_GetIndexById(id)
	for i,wishlist in pairs(self.db.profile.wishlists) do
		if tonumber(wishlist.id) == tonumber(id) then
			-- Item exists already
			return i;
		end
	end	
	return nil;
end
function kAuction:Wishlist_GetItemFlag(wishlistId, itemId, flagType)
	local listIndex = kAuction:Wishlist_GetIndexById(wishlistId);
	local itemIndex = kAuction:Wishlist_IsItemInList(wishlistId, itemId);
	if itemIndex then
		return self.db.profile.wishlists[listIndex].items[itemIndex][flagType];
	end
	return false;
end
function kAuction:Wishlist_GetLists()
	return self.db.profile.wishlists;
end
function kAuction:Wishlist_GetListById(id)
	if self.db.profile.wishlists and id then
		for i,v in pairs(self.db.profile.wishlists) do
			if id == v.id then
				return v;
			end
		end
	end
	return nil;
end
function kAuction:Wishlist_GetNameById(id)
	for i,wishlist in pairs(self.db.profile.wishlists) do
		if wishlist.id == id then
			-- Item exists already
			return wishlist.name;
		end
	end	
	return nil;
end
function kAuction:Wishlist_GetFilterIndexById(id)
	for i,v in pairs(self.db.profile.wishlist.config.searchFilters) do
		if v.id == id then
			return i;		
		end
	end
	return nil;
end
function kAuction:Wishlist_GetFilterIndexByKey(key)
	for i,v in pairs(self.db.profile.wishlist.config.searchFilters) do
		if v.key == key then
			return i;		
		end
	end
	return nil;
end
function kAuction:Wishlist_GetFilterValueIndexByValueAndType(filterId, value, type)
	local iFilter = kAuction:Wishlist_GetFilterIndexById(filterId);
	if iFilter then -- Exists
		for i,v in pairs(self.db.profile.wishlist.config.searchFilters[iFilter].values) do
			if v.type == type and v.value == value then
				return i;		
			end
		end
	end
	return nil;
end
function kAuction:Wishlist_GetFilterValueIndexById(id)
	for i,v in pairs(self.db.profile.wishlist.config.searchFilters) do
		if v.values then
			for iVal, vVal in pairs(v.values) do
				if vVal.id == id then
					return i;		
				end
			end
		end
	end
	return nil;
end
function kAuction:Wishlist_AddValidSearchFilter(key, value, type, name)
	-- TODO: Allow column hide/show in search results
	--[[
		-- Type: match
		-- Type: equation
		{
			id = 1, key = 'equipSlot', values = {
				{id = 1, type = 'match', name = 'Back', value = 'Back'}
			},
		},	
	]]
	-- Check if key exists
	local iFilter = kAuction:Wishlist_GetFilterIndexByKey(key);
	if iFilter then -- Exists
		-- Check if value and type exists
		local iValue = kAuction:Wishlist_GetFilterValueIndexByValueAndType(self.db.profile.wishlist.config.searchFilters[iFilter].id, value, type);
		if not iValue then -- Doesn't exist, create
			if type == 'match' then
				tinsert(self.db.profile.wishlist.config.searchFilters[iFilter].values, {
					id = kAuction:Wishlist_GetUniqueSearchFilterId(),
					type = type,
					name = name,
					value = value,
					enabled = true,
				});
			else
				tinsert(self.db.profile.wishlist.config.searchFilters[iFilter].values, {
					id = kAuction:Wishlist_GetUniqueSearchFilterId(),
					type = type,
					name = name,
					value = value,
				});
			end
			-- Sort
			table.sort(self.db.profile.wishlist.config.searchFilters[iFilter].values, function(a,b)
				if a.name and b.name then
					if tostring(a.name) < tostring(b.name) then
						return true;
					else
						return false;
					end
				elseif a.name then
					return true
				elseif b.name then
					return false;
				end
			end);
		end
	else -- Create
		tinsert(self.db.profile.wishlist.config.searchFilters, {
			id = kAuction:Wishlist_GetUniqueSearchFilterId(),
			key = key,
			values = {},
		});
	end
end
function kAuction:Wishlist_GetUniqueSearchFilterId()
	local newId
	local isValidId = false;
	while isValidId == false do
		matchFound = false;
		newId = (math.random(0,2147483647) * -1);
		for i,val in pairs(self.db.profile.wishlist.config.searchFilters) do
			if val.id == newId then
				matchFound = true;
			end
			for iVal, vVal in pairs(val.values) do
				if vVal.id == newId then
					matchFound = true;
				end
			end
		end
		if matchFound == false then
			isValidId = true;
		end
	end
	return newId;
end
function kAuction:Wishlist_GetUniqueWishlistId()
	local newId
	local isValidId = false;
	while isValidId == false do
		matchFound = false;
		newId = (math.random(0,2147483647) * -1);
		for i,val in pairs(self.db.profile.wishlists) do
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
function kAuction:Wishlist_GetWishlistItemMatches(itemId)
	local items = {};
	if self.db.profile.wishlists then
		-- Loop through lists
		for iList, vList in pairs(self.db.profile.wishlists) do
			-- Loop through items
			if vList.items then
				for iItem, vItem in pairs(vList.items) do
					if tonumber(vItem.id) == tonumber(itemId) then
						vItem.wishlistId = vList.id;
						tinsert(items, vItem);
					end	
				end
			end			
		end
	end	
	if #items > 0 then
		return items;
	else
		return nil;	
	end
end
function kAuction:Wishlist_GetWishlistsWithItem(itemId)
	local lists = {};
	if self.db.profile.wishlists then
		-- Loop through lists
		for iList, vList in pairs(self.db.profile.wishlists) do
			-- Loop through items
			if vList.items then
				for iItem, vItem in pairs(vList.items) do
					if tonumber(vItem.id) == tonumber(itemId) then
						tinsert(lists, vList);
					end	
				end
			end			
		end
	end	
	if #lists > 0 then
		return lists;
	else
		return nil;	
	end
end
function kAuction:Wishlist_GetWishlistsWithoutItem(itemId)
	local lists = {};
	if self.db.profile.wishlists then
		-- Loop through lists
		for iList, vList in pairs(self.db.profile.wishlists) do
			local booFound = false;
			-- Loop through items
			if vList.items then
				for iItem, vItem in pairs(vList.items) do
					if tonumber(vItem.id) == tonumber(itemId) then
						booFound = true;
					end	
				end
			end		
			if booFound == false then
				tinsert(lists, vList);				
			end	
		end
	end	
	if #lists > 0 then
		return lists;
	else
		return nil;	
	end
end
function kAuction:Wishlist_IsEnabled()
	return self.db.profile.wishlist.enabled;
end
function kAuction:Wishlist_IsItemInList(wishlistId, itemId)
	local iIndex = kAuction:Wishlist_GetIndexById(wishlistId);
	-- Ensure proper wishlist is manipulated
	if self.db.profile.wishlists[iIndex] then
		-- Loop through items
		if self.db.profile.wishlists[iIndex].items then
			for iItem, vItem in pairs(self.db.profile.wishlists[iIndex].items) do
				if tonumber(vItem.id) == tonumber(itemId) then
					return iItem;
				end	
			end
		end
		return false;
	end	
end
function kAuction:Wishlist_RemoveItem(wishlistId, itemId)
	kAuction:Debug("FUNC: kAuction:Wishlist_RemoveItem, list id: " .. wishlistId .. ", item id: " .. itemId, 1);
	local index = kAuction:Wishlist_GetIndexById(wishlistId);
	local itemIndex = kAuction:Wishlist_IsItemInList(wishlistId, itemId);
	if itemIndex then
		kAuction:Debug("FUNC: kAuction:Wishlist_RemoveItem, index found " .. itemIndex, 3);
		if self.db.profile.wishlists[index].items[itemIndex] then
			kAuction:Debug("FUNC: kAuction:Wishlist_RemoveItem, list ("..index..") and item found " .. itemIndex, 1);
			-- Remove item from local
			tremove(self.db.profile.wishlists[index].items, itemIndex);
		end
	end	
end
function kAuction:Wishlist_RemoveList(wishlistId)
	local index = kAuction:Wishlist_GetIndexById(wishlistId);
	if index then
		-- Remove item from local
		tremove(self.db.profile.wishlists, index);
	end	
end
function kAuction:Wishlist_SetItemFlag(wishlistId, itemId, flagType, value)
	local listIndex = kAuction:Wishlist_GetIndexById(wishlistId);
	local itemIndex = kAuction:Wishlist_IsItemInList(wishlistId, itemId);
	if itemIndex then
		self.db.profile.wishlists[listIndex].items[itemIndex][flagType] = value;
		return true;
	end
	return false;
end
function kAuction:Wishlist_SetListFlag(wishlistId, flagType, value)
	local listIndex = kAuction:Wishlist_GetIndexById(wishlistId);
	if listIndex then
		self.db.profile.wishlists[listIndex][flagType] = value;
		return true;
	end
	return false;
end
function kAuction:Wishlist_SetFilterValueFlag(valueId, flagType, value)
	local iValue = kAuction:Wishlist_GetFilterValueIndexById(valueId);
	for iF, vF in pairs(self.db.profile.wishlist.config.searchFilters) do
		for iV, vV in pairs(vF.values) do
			if vV.id == valueId then
				vV[flagType] = value;
			end
		end
	end
	return false;
end
function kAuction:Wishlist_SortList(listId, sortKey)
	local index = kAuction:Wishlist_GetIndexById(listId);
	if index then
		if self.db.profile.wishlists[index].items and #self.db.profile.wishlists[index].items > 0 then
			-- Verify key exists
			--if self.db.profile.wishlists[index].items[1][sortKey] then
				-- Check if current sort key matches this sort key, if so, reverse the sort order, if not, set order normal
				if self.db.profile.wishlist.config.listSortKey == sortKey then
					-- Reverse current sort flag due to click
					if self.db.profile.wishlist.config.listSortOrderNormal then
						self.db.profile.wishlist.config.listSortOrderNormal = false
					else
						self.db.profile.wishlist.config.listSortOrderNormal = true;
					end
				else
					self.db.profile.wishlist.config.listSortOrderNormal = true;
				end
				-- Set key
				self.db.profile.wishlist.config.listSortKey = sortKey;
				table.sort(self.db.profile.wishlists[index].items, function(a,b)
					if a[self.db.profile.wishlist.config.listSortKey] and b[self.db.profile.wishlist.config.listSortKey] then
						if self.db.profile.wishlist.config.listSortOrderNormal then
							if a[self.db.profile.wishlist.config.listSortKey] < b[self.db.profile.wishlist.config.listSortKey] then
								return true;
							else
								return false;
							end
						else
							if a[self.db.profile.wishlist.config.listSortKey] > b[self.db.profile.wishlist.config.listSortKey] then
								return true;
							else
								return false;
							end
						end
					elseif a[self.db.profile.wishlist.config.listSortKey] then
						return true
					elseif b[self.db.profile.wishlist.config.listSortKey] then
						return false;
					end
				end);		
			--end
		end
	end
end
--[[ DEPRECATED
function kAuction:Wishlist_UpdateFromAtlasLoot()
	if kAuction:Wishlist_IsEnabled() then -- Check if enabled
		local oAtlas = _G[self.const.wishlist.atlasLootTableName];
		if oAtlas then
			if oAtlas.Own[self.playerName] then
				-- Loop through each list
				for iList, vList in pairs(oAtlas.Own[self.playerName]) do
					-- Add wishlist
					local iListId = kAuction:Wishlist_Create(vList.info[1], true, vList.info[3]);
					local iListIndex = kAuction:Wishlist_GetIndexById(iListId);
					-- Ensure proper wishlist is manipulated
					if self.db.profile.wishlists[iListIndex] then
						for iItem, vItem in pairs(vList) do
							-- Check for actual item entry
							if iItem ~= "info" then
								local itemId = vItem[2];
								local itemName = '';
								if GetItemInfo(itemId) then
									itemName = GetItemInfo(itemId);
								else
									itemName = strsub(vItem[4], 11);
								end
								-- Ensure item doesn't exist, then add
								if kAuction:Wishlist_IsItemInList(self.db.profile.wishlists[iListIndex].id, itemId) == false then
									kAuction:Wishlist_AddItem(self.db.profile.wishlists[iListIndex].id, itemName, itemId);
								end
							end
						end												
					end
				end
			end
		end
	end
	-- Create options table
	kAuction:Wishlist_CreateOptionTable();
end
]]