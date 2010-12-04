-- Author      : Gabe
-- Create Date : 9/3/2009 3:25:32 PM
kAuction.gui.frames.list = {};
kAuction.gui.frames.list.selectedWishlist = nil;
kAuction.gui.stats = {};
kAuction.gui.gems = {};
kAuction.gui.searchEquipmentLevels = {
	[1] = {min=1,max=90000}, -- All
	[2] = {min=1,max=25000}, -- Classic
	[3] = {min=10000,max=40000}, -- TBC
	[4] = {min=30000,max=60000}, -- WotLK
	[5] = {min=50000,max=90000}, -- Cataclysm
	[6] = {min=1,max=40000}, -- Classic & TBC
	[7] = {min=10000,max=60000}, -- TBC & WotLK
	[8] = {min=30000,max=90000}, -- WotLK & Cataclysm
};
local sharedMedia = kAuction.sharedMedia
local ITEMS_PER_RUN = 10
local TIMER_THROTTLE = 0.001
local SESSION_LOADED_ITEM_CACHE = false;
function kAuction:WishlistGui_InitializeFrames()
	-- Main frame
	self.gui.frames.list.main = self.AceGUI:Create("Frame")
	self.gui.frames.list.main:SetCallback("OnClose",function(widget,event) self.AceGUI:Release(widget) end);
	self.gui.frames.list.main:SetTitle("kAuction Wishlist")
	self.gui.frames.list.main:SetLayout("Fill")
	self.gui.frames.list.main:SetWidth(900);
	-- Create main frame
	if SESSION_LOADED_ITEM_CACHE == false then
		SESSION_LOADED_ITEM_CACHE = true;
		kAuction:WishlistGui_RefreshMainFrame(true);		
		--kAuction:WishlistGui_LoadItems();
	else
		kAuction:WishlistGui_RefreshMainFrame();
	end
	--kAuction:WishlistGui_LoadSpells();
end
kAuction.temp = {};
function kAuction:WishlistGui_LoadItems()
	if self.db.profile.wishlist.config.selectedSection == 'search' then
		self.gui.frames.list.main.searchBox:SetDisabled(true);
		self.gui.frames.list.main.searchSummary:SetText('Generating Item Database');
	end
	if self.gui.frames.list.main.refreshButton then
		self.gui.frames.list.main.refreshButton:SetDisabled(true);
	end
	self.itemLoader = {};
	self.itemLoader.items = {};
	self.itemLoader.itemsLoaded = 0;
	local timeElapsed, totalInvalid, currentIndex = 0, 0, self.gui.searchEquipmentLevels[self.db.profile.wishlist.config.searchThrottleEquipmentLevel].min
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice;
	self.loader = CreateFrame("Frame")
	self.loader:SetScript("OnUpdate", function(self, elapsed)
		timeElapsed = timeElapsed + elapsed
		if( timeElapsed < TIMER_THROTTLE ) then return end
		timeElapsed = timeElapsed - TIMER_THROTTLE
		if( totalInvalid >= 15000 or currentIndex >= self.gui.searchEquipmentLevels[self.db.profile.wishlist.config.searchThrottleEquipmentLevel].max ) then
			kAuction:Item_PopulateItemData(self.itemLoader.items);		
			kAuction:Wishlist_UpdateFromCacheData(self.itemLoader.items);	
			table.sort(self.itemLoader.items, function(a,b)
				if strlower(a.name) < strlower(b.name) then
					return true;
				else
					return false;
				end
			end);
			if self.db.profile.wishlist.config.selectedSection == 'search' then
				self.gui.frames.list.main.searchBox:SetDisabled(false);
				self.gui.frames.list.main.searchSummary:SetText('Complete, Search is Now Enabled');
				kAuction:WishlistGui_SearchQuery(self.gui.frames.list.main.searchBox['editbox']['obj'].lasttext, self.gui.frames.list.main.searchScroll);
			end
			if self.gui.frames.list.main.refreshButton then
				self.gui.frames.list.main.refreshButton:SetDisabled(false);
			end
			self:Hide()
			return;
		end
		for itemId = currentIndex + 1, currentIndex + self.db.profile.wishlist.config.searchThrottleLevel do
			itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemId);
			if itemName then
				if itemType == 'Gem' then
					if itemSubType then
						tinsert(self.gui.gems, {id = itemId, name = itemName, rarity = itemRarity, level = itemLevel, minLevel = itemMinLevel, subType = itemSubType});
					end
				elseif itemRarity >= self.db.profile.wishlist.config.searchMinRarity and itemLevel >= self.db.profile.wishlist.config.searchMinItemLevel then
					if kAuction:Item_CanPlayerEquip(itemId) then
						if kAuction:Item_IsItemClassSpecific(itemId) then -- Class specific, check if player matches
							if kAuction:Item_IsPlayerInClassSpecificList(itemId) then
								tinsert(self.itemLoader.items, {id = itemId, name = itemName});
							end
						else
							tinsert(self.itemLoader.items, {id = itemId, name = itemName});
						end
					end
				end
				totalInvalid = 0
			else
				totalInvalid = totalInvalid + 1
			end
		end
		-- Increment and do it all over!
		currentIndex = currentIndex + self.db.profile.wishlist.config.searchThrottleLevel
		if self.db.profile.wishlist.config.selectedSection == 'search' then
			local shift = 10 ^ 2
			local percentComplete = floor( ((currentIndex - self.gui.searchEquipmentLevels[self.db.profile.wishlist.config.searchThrottleEquipmentLevel].min) / (self.gui.searchEquipmentLevels[self.db.profile.wishlist.config.searchThrottleEquipmentLevel].max - self.gui.searchEquipmentLevels[self.db.profile.wishlist.config.searchThrottleEquipmentLevel].min))*100*shift + 0.5 ) / shift
			if percentComplete <= 40 then
				percentComplete = "|cFF"..kAuction:RGBToHex(255,0,0)..percentComplete.."%|r";
			elseif percentComplete <= 70 then
				percentComplete = "|cFF"..kAuction:RGBToHex(200,150,0)..percentComplete.."%|r";
			else
				percentComplete = "|cFF"..kAuction:RGBToHex(0,255,0)..percentComplete.."%|r";
			end
			self.gui.frames.list.main.searchSummary:SetText('Generating Item Database '..percentComplete..'');
		end
	end)
end
function kAuction:WishlistGui_LoadSpells()
	if self.db.profile.wishlist.config.selectedSection == 'spellsearch' then
		self.gui.frames.list.main.spellSearchBox:SetDisabled(true);
		self.gui.frames.list.main.spellSearchSummary:SetText('Generating Spell Database');
	end
	if self.gui.frames.list.main.spellRefreshButton then
		self.gui.frames.list.main.spellRefreshButton:SetDisabled(true);
	end
	self.spellLoader = {};
	self.spellLoader.spells = {};
	self.spellLoader.spellsLoaded = 0;
	local timeElapsed, totalInvalid, currentIndex = 0, 0, 0
	self.loader2 = CreateFrame("Frame")
	self.loader2:SetScript("OnUpdate", function(self, elapsed)
		timeElapsed = timeElapsed + elapsed
		if( timeElapsed < TIMER_THROTTLE ) then return end
		timeElapsed = timeElapsed - TIMER_THROTTLE
		if( totalInvalid >= 15000 ) then
			table.sort(self.spellLoader.spells, function(a,b)
				if strlower(a.name) < strlower(b.name) then
					return true;
				else
					return false;
				end
			end);
			if self.db.profile.wishlist.config.selectedSection == 'spellsearch' then
				self.gui.frames.list.main.spellSearchBox:SetDisabled(false);
				self.gui.frames.list.main.spellSearchSummary:SetText('Complete, Search is Now Enabled');
			end
			if self.gui.frames.list.main.spellRefreshButton then
				self.gui.frames.list.main.spellRefreshButton:SetDisabled(false);
			end
			self:Hide()
			return;
		end
		for spellId = currentIndex + 1, currentIndex + self.db.profile.wishlist.config.searchThrottleLevel do
			local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spellId);
			if name then
				tinsert(self.spellLoader.spells, {id = spellId, name = name, castTime = castTime/100, minRange = minRange, maxRange = maxRange});
				totalInvalid = 0
			else
				totalInvalid = totalInvalid + 1
			end
		end
		-- Increment and do it all over!
		currentIndex = currentIndex + self.db.profile.wishlist.config.searchThrottleLevel
		if self.db.profile.wishlist.config.selectedSection == 'spellsearch' then
			self.gui.frames.list.main.spellSearchSummary:SetText('Generating Spell Database ['..currentIndex..']');
		end
	end)
end
function kAuction:WishlistGui_RefreshMainFrame(initialLoad)
	self.gui.frames.list.main:ReleaseChildren();
	-- Build Section Dropdown
	local fSectionDropdown = kAuction:WishlistGui_CreateWidget_SectionDropdown(self.gui.frames.list.main);
	-- Build Tree if List
	if self.db.profile.wishlist.config.selectedSection == 'list' then -- Current Wishlists
		kAuction:WishlistGui_CreateWidget_ListTree(fSectionDropdown);
	elseif self.db.profile.wishlist.config.selectedSection == 'search' then -- Search
		kAuction:WishlistGui_CreateWidget_Search(fSectionDropdown, initialLoad);
	end
	self.gui.frames.list.main:Show()
end
function kAuction:WishlistGui_CreateWidget_Search(parent, initialLoad)
	parent:ReleaseChildren();	
	self.gui.frames.list.main.searchScroll = self.AceGUI:Create("ScrollFrame");
	self.gui.frames.list.main.searchScroll:SetLayout("Flow");
	self.gui.frames.list.main.searchBox:SetCallback('OnTextChanged', function(widget,event,val)
		kAuction:WishlistGui_SearchQuery(val, self.gui.frames.list.main.searchScroll);
	end);	
	parent:AddChild(self.gui.frames.list.main.searchScroll);
	kAuction:WishlistGui_SearchQuery(self.gui.frames.list.main.searchBox['editbox']['obj'].lasttext, self.gui.frames.list.main.searchScroll, initialLoad);
end
function kAuction:WishlistGui_CreateWidget_SpellSearch(parent, initialLoad)
	parent:ReleaseChildren();	
	self.gui.frames.list.main.spellSearchScroll = self.AceGUI:Create("ScrollFrame");
	self.gui.frames.list.main.spellSearchScroll:SetLayout("Flow");
	self.gui.frames.list.main.spellSearchBox:SetCallback('OnTextChanged', function(widget,event,val)
		kAuction:WishlistGui_SpellSearchQuery(val, self.gui.frames.list.main.spellSearchScroll);
	end);	
	parent:AddChild(self.gui.frames.list.main.spellSearchScroll);
	kAuction:WishlistGui_SpellSearchQuery(self.gui.frames.list.main.spellSearchBox['editbox']['obj'].lasttext, self.gui.frames.list.main.spellSearchScroll, initialLoad);
end
function kAuction:WishlistGui_CreateWidget_GemSets(parent, initialLoad)
	parent:ReleaseChildren();	
	self.gui.frames.list.main.gemSets = self.AceGUI:Create("SimpleGroup");
	self.gui.frames.list.main.gemSets:SetLayout("Flow");
	self.gui.frames.list.main.gemSets:SetFullHeight(true);
	parent:AddChild(self.gui.frames.list.main.gemSets);
	
	local f1 = self.AceGUI:Create("SimpleGroup");
	f1:SetLayout("Flow");
	f1:SetFullWidth(true);
	--f1:SetHeight(0.5);
	f1:SetHeight(250);
	f1.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
	kAuction:Gui_SetFrameBackdropColor(f1.frame,0,0.35,0.5,1);
	self.gui.frames.list.main.gemSets:AddChild(f1);	
	
	local fhName1 = self.AceGUI:Create("InteractiveLabel");
	fhName1:SetText('Name');
	f1:AddChild(fhName1);
	
	local f2 = self.AceGUI:Create("InlineGroup");
	--f2:SetLayout("Flow");
	f2:SetHeight(self.gui.frames.list.main.gemSets.frame:GetHeight()/2);
	--f2:SetPoint("TOPLEFT", f1.frame, "BOTTOMLEFT");
	f2:SetPoint("BOTTOMLEFT", self.gui.frames.list.main.gemSets.frame, "BOTTOMLEFT", 0, -50);
	f2:SetFullWidth(true);
	--f2:SetFullHeight(true);
	f2.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
	kAuction:Gui_SetFrameBackdropColor(f2.frame,1,0,0,1);
	self.gui.frames.list.main.gemSets:AddChild(f2);
	
	local fhName2 = self.AceGUI:Create("InteractiveLabel");
	fhName2:SetText('Date');
	f2:AddChild(fhName2);
	--kAuction:WishlistGui_SearchQuery(self.gui.frames.list.main.searchBox['editbox']['obj'].lasttext, self.gui.frames.list.main.searchScroll, initialLoad);
end
function kAuction:WishlistGui_UpdateSearchSortKey(key)
	-- Check if current sort key matches this sort key, if so, reverse the sort order, if not, set order normal
	if self.db.profile.wishlist.config.searchSortKey == key then
		-- Reverse current sort flag due to click
		if self.db.profile.wishlist.config.searchSortOrderNormal then
			self.db.profile.wishlist.config.searchSortOrderNormal = false
		else
			self.db.profile.wishlist.config.searchSortOrderNormal = true;
		end
	else
		self.db.profile.wishlist.config.searchSortOrderNormal = true;
	end
	-- Set key
	self.db.profile.wishlist.config.searchSortKey = key;
end
function kAuction:WishlistGui_UpdateSpellSearchSortKey(key)
	-- Check if current sort key matches this sort key, if so, reverse the sort order, if not, set order normal
	if self.db.profile.wishlist.config.spellSearchSortKey == key then
		-- Reverse current sort flag due to click
		if self.db.profile.wishlist.config.spellSearchSortOrderNormal then
			self.db.profile.wishlist.config.spellSearchSortOrderNormal = false
		else
			self.db.profile.wishlist.config.spellSearchSortOrderNormal = true;
		end
	else
		self.db.profile.wishlist.config.spellSearchSortOrderNormal = true;
	end
	-- Set key
	self.db.profile.wishlist.config.spellSearchSortKey = key;
end
function kAuction:WishlistGui_SearchQuery(query, parent, initialLoad)
	parent:ReleaseChildren();
	--if query ~= '' then
		local fHeader = self.AceGUI:Create("SimpleGroup");
		fHeader:SetHeight(70);
		fHeader:SetFullWidth(true);
		fHeader:SetLayout("Flow");
		parent:AddChild(fHeader);		
		
		-- Item Name
		local fhName = self.AceGUI:Create("InteractiveLabel");
		fhName:SetText('Name');
		fhName.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fhName.frame,0,0,0,0);
		fhName:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
			if self.db.profile.wishlist.config.searchSortKey == 'name' and self.db.profile.wishlist.config.searchSortOrderNormal then
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Left-Click to Reverse Sort by Name|r");
			else
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Left-Click to Sort by Name|r");
			end
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(fhName.frame,0.9,0.9,0.9,0.1);		
		end);
		fhName:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(fhName.frame,0,0,0,0);		
		end);
		fhName:SetCallback('OnClick', function(a,b,c,d)
			if c == 'LeftButton' then
				kAuction:WishlistGui_UpdateSearchSortKey('name');
				kAuction:WishlistGui_RefreshMainFrame();				
			end
		end);
		
		-- Equip Slot
		local fhSlot = self.AceGUI:Create("InteractiveLabel");
		fhSlot:SetText('Slot');
		fhSlot.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fhSlot.frame,0,0,0,0);
		fhSlot:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
			if self.db.profile.wishlist.config.searchSortKey == 'equipSlot' and self.db.profile.wishlist.config.searchSortOrderNormal then
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Left-Click to Reverse Sort by Slot|r");
			else
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Left-Click to Sort by Slot|r");
			end
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Right-Click to Filter Slot|r");
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(fhSlot.frame,0.9,0.9,0.9,0.1);		
		end);
		fhSlot:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(fhSlot.frame,0,0,0,0);		
		end);
		fhSlot:SetCallback('OnClick', function(a,b,c,d)
			if c == 'LeftButton' then
				kAuction:WishlistGui_UpdateSearchSortKey('equipSlot');
				kAuction:WishlistGui_RefreshMainFrame();				
			elseif c == 'RightButton' then
				kAuction:WishlistGui_CreateFilterMenu('equipSlot', a.frame);
			end
		end);
				
		-- Mob Name
		local fhMob = self.AceGUI:Create("InteractiveLabel");
		fhMob:SetText('Mob');
		fhMob.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fhMob.frame,0,0,0,0);
		fhMob:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
			if self.db.profile.wishlist.config.searchSortKey == 'mobName' and self.db.profile.wishlist.config.searchSortOrderNormal then
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Left-Click to Reverse Sort by Mob Name|r");
			else
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Left-Click to Sort by Mob Name|r");
			end
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Right-Click to Filter Mob Name|r");
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(fhMob.frame,0.9,0.9,0.9,0.1);		
		end);
		fhMob:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(fhMob.frame,0,0,0,0);		
		end);
		fhMob:SetCallback('OnClick', function(a,b,c,d)
			if c == 'LeftButton' then
				kAuction:WishlistGui_UpdateSearchSortKey('mobName');
				kAuction:WishlistGui_RefreshMainFrame();				
			elseif c == 'RightButton' then
				kAuction:WishlistGui_CreateFilterMenu('mobName', a.frame);
			end
		end);
		local fhZone = self.AceGUI:Create("InteractiveLabel");
		fhZone:SetText('Zone');
		fhZone.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fhZone.frame,0,0,0,0);
		fhZone:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
			if self.db.profile.wishlist.config.searchSortKey == 'zoneName' and self.db.profile.wishlist.config.searchSortOrderNormal then
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Left-Click to Reverse Sort by Zone|r");
			else
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Left-Click to Sort by Zone|r");
			end
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Right-Click to Filter Zone Name & Difficulty|r");
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(fhZone.frame,0.9,0.9,0.9,0.1);		
		end);
		fhZone:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(fhZone.frame,0,0,0,0);		
		end);
		fhZone:SetCallback('OnClick', function(a,b,c,d)
			if c == 'LeftButton' then
				kAuction:WishlistGui_UpdateSearchSortKey('zoneName');
				kAuction:WishlistGui_RefreshMainFrame();
			elseif c == 'RightButton' then
				kAuction:WishlistGui_CreateFilterMenu('zoneName', a.frame);				
			end
		end);
		local fhInList = self.AceGUI:Create("InteractiveLabel");
		fhInList:SetText('In List');
		fHeader:AddChild(fhName);	
		fHeader:AddChild(fhSlot);
		fHeader:AddChild(fhMob);
		fHeader:AddChild(fhZone);
		fHeader:AddChild(fhInList);
		
		fhName:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
		fhSlot:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
		fhMob:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
		fhZone:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
		fhInList:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
		-- Set Widths
		fhName:SetRelativeWidth((1 - (0.07)) * 0.366);		
		fhSlot:SetRelativeWidth((1 - (0.07)) * 0.1);		
		fhMob:SetRelativeWidth((1 - (0.07)) * 0.166);		
		fhZone:SetRelativeWidth((1 - (0.07)) * 0.266);		
		fhInList:SetRelativeWidth((1 - (0.07)) * 0.095);		
		local objItems = kAuction:WishlistGui_GetSearchQueryResultSet(query, initialLoad);
		if objItems and #objItems > 0 then
			self.gui.frames.list.main.searchSummary:SetText('Showing ' .. #objItems .. ' results of ' .. #self.itemLoader.items .. ' total');
			for i,v in pairs(objItems) do
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v.id)
				local fItem = self.AceGUI:Create("SimpleGroup");
				fItem:SetHeight(70);
				fItem:SetFullWidth(true);
				fItem:SetLayout("Flow");
				fItem.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
				kAuction:Gui_SetFrameBackdropColor(fItem.frame,0,0,0,0);
				parent:AddChild(fItem);		
				
				local name = self.AceGUI:Create("InteractiveLabel");
				name:SetText(v.name);
				--name:SetFont("Fonts\\FRIZQT__.TTF", 13);
				name:SetColor(GetItemQualityColor(itemRarity));
				name:SetImage(itemTexture);
				name:SetImageSize(self.db.profile.wishlist.config.iconSize,self.db.profile.wishlist.config.iconSize);
				name:SetCallback("OnEnter", function(widget,event,val)
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
					GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
					GameTooltip:SetHyperlink(itemLink);
					GameTooltip:Show();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
				end);
				name:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				name:SetCallback('OnClick', function(a,b,c,d)
					if c == 'LeftButton' then
						if IsControlKeyDown() then
							DressUpItemLink(itemLink);
						elseif IsShiftKeyDown() then
							kAuction:Item_SendHyperlinkToChat(itemLink);
						end
					elseif c == 'RightButton' then
						kAuction:WishlistGui_CreateSearchItemDropdown(v.id, a.frame);
					end
				end);
				fItem:AddChild(name);
				
				-- Slot
				local slot = self.AceGUI:Create("InteractiveLabel");
				slot:SetText(v.equipSlot);
				slot:SetCallback('OnClick', function(a,b,c,d)
					if c == 'RightButton' then
						kAuction:WishlistGui_CreateSearchItemDropdown(v.id, a.frame);
					end
				end);
				fItem:AddChild(slot);
				
				local lMob = self.AceGUI:Create("InteractiveLabel");
				lMob:SetText(v.mobName);
				lMob:SetCallback("OnEnter", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
				end);
				lMob:SetCallback("OnLeave", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				lMob:SetCallback('OnClick', function(a,b,c,d)
					if c == 'RightButton' then
						kAuction:WishlistGui_CreateSearchItemDropdown(v.id, a.frame);
					end
				end);
				fItem:AddChild(lMob);
				
				local lZone = self.AceGUI:Create("InteractiveLabel");
				if v.zoneName then
					local strZone = v.zoneName
					if v.difficulty == -2 then
						strZone = strZone .. ' [5H]'
					elseif v.difficulty == -1 then
						strZone = strZone .. ' [5N]'
					elseif v.difficulty == 1 then
						strZone = strZone .. ' [10N]'
					elseif v.difficulty == 2 then
						strZone = strZone .. ' [25N]'						
					elseif v.difficulty == 3 then
						strZone = strZone .. ' [10H]'						
					elseif v.difficulty == 4 then
						strZone = strZone .. ' [25H]'						
					end
					lZone:SetText(strZone);
				end
				lZone:SetCallback("OnEnter", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
				end);
				lZone:SetCallback("OnLeave", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				lZone:SetCallback('OnClick', function(a,b,c,d)
					if c == 'RightButton' then
						kAuction:WishlistGui_CreateSearchItemDropdown(v.id, a.frame);
					end
				end);
				fItem:AddChild(lZone);
				
				local lInList = self.AceGUI:Create("InteractiveLabel");
				if v.isInList then
					lInList:SetText('Yes');
					lInList:SetColor(0,1,0);
				else
					lInList:SetText('No');
				end
				lInList:SetCallback("OnEnter", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
				end);
				lInList:SetCallback("OnLeave", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				lInList:SetCallback('OnClick', function(a,b,c,d)
					if c == 'RightButton' then
						kAuction:WishlistGui_CreateSearchItemDropdown(v.id, a.frame);
					end
				end);
				fItem:AddChild(lInList);
								
				name:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				slot:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				lMob:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				lZone:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				lInList:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				
				-- Set Widths
				name:SetRelativeWidth((1 - (0.07)) * 0.366);
				slot:SetRelativeWidth((1 - (0.07)) * 0.1);
				lMob:SetRelativeWidth((1 - (0.07)) * 0.166);
				lZone:SetRelativeWidth((1 - (0.07)) * 0.266);
				lInList:SetRelativeWidth((1 - (0.07)) * 0.095);				
			end
		end
	--else
		--self.gui.frames.list.main.searchSummary:SetText('');
	--end
end
function kAuction:WishlistGui_CreateFilterMenu(key, anchorFrame)
	if key == 'equipSlot' then
		local menuData = {};
		local iIndex = kAuction:Wishlist_GetFilterIndexByKey(key);
		if self.db.profile.wishlist.config.searchFilters[iIndex] then
			-- Header
			tinsert(menuData, {
				func = function() end,
				isTitle = true,
				text = 'Filter by Equip Slot',
				hasArrow = false,
				notClickable = true,
				notCheckable = true,
				keepShownOnClick = true,
			});
			for i,v in pairs(self.db.profile.wishlist.config.searchFilters[iIndex].values) do
				tinsert(menuData,{
					func = function()
						kAuction:Wishlist_SetFilterValueFlag(v.id, 'enabled', not v.enabled);
						kAuction:WishlistGui_RefreshMainFrame();
					end,
					text = v.name,
					checked = v.enabled,
					hasArrow = false,
					tooltipTitle = v.name,
					tooltipText = "Click to set to Toggle the '" .. v.name .."' Slot Filter",
					keepShownOnClick = true,
				});
			end
		end
		if menuData and #menuData > 0 then
			kAuction:Gui_CreateDropdownMenuTimer()
			EasyMenu(menuData, self.menu, anchorFrame, 0, 0, "MENU", 1.5)
		end		
	elseif key == 'zoneName' then
		local menuData = {};
		local tZone = kAuction:WishlistGui_GetFilterSubMenu('zoneName');
		local tDifficulty = kAuction:WishlistGui_GetFilterSubMenu('difficulty');
		-- Header
		tinsert(menuData, {
			func = function() end,
			isTitle = true,
			text = 'Filter by Zone',
			hasArrow = false,
			notClickable = true,
			notCheckable = true,
			keepShownOnClick = true,
		});
		if tZone then
			tinsert(menuData,{
				func = function()
				end,
				text = "Zone Names",
				hasArrow = true,
				tooltipTitle = "Zone Names",
				tooltipText = "Filter by Zone Names",
				menuList = tZone,
			});	
		end
		if tDifficulty then
			tinsert(menuData,{
				func = function()
				end,
				text = "Zone Difficulty",
				hasArrow = true,
				tooltipTitle = "Zone Difficulty",
				tooltipText = "Filter by Zone Difficulty",
				menuList = tDifficulty,
			});	
		end
		if menuData and #menuData > 0 then
			kAuction:Gui_CreateDropdownMenuTimer()
			EasyMenu(menuData, self.menu, anchorFrame, 0, 0, "MENU", 1.5)
		end	
	elseif key == 'mobName' then
		local menuData = {};
		local iIndex = kAuction:Wishlist_GetFilterIndexByKey(key);
		if self.db.profile.wishlist.config.searchFilters[iIndex] then
			-- Header
			tinsert(menuData, {
				func = function() end,
				isTitle = true,
				text = 'Filter by Mob Name',
				hasArrow = false,
				notClickable = true,
				notCheckable = true,
				keepShownOnClick = true,
			});
			local iCount = 0;
			local oSubs = {};
			local iPerList = 20;
			for i,v in pairs(self.db.profile.wishlist.config.searchFilters[iIndex].values) do
				iCount = iCount + 1;
				if floor(iCount / iPerList) > 0 then
					if not oSubs[floor(iCount / iPerList)] then
						oSubs[floor(iCount / iPerList)] = {};
					end
					tinsert(oSubs[floor(iCount / iPerList)],{
						func = function()
							kAuction:Wishlist_SetFilterValueFlag(v.id, 'enabled', not v.enabled);
							kAuction:WishlistGui_RefreshMainFrame();
						end,
						text = v.name,
						checked = v.enabled,
						hasArrow = false,
						tooltipTitle = v.name,
						keepShownOnClick = true,
						tooltipText = "Click to set to Toggle the '" .. v.name .."' Filter",
					});
				else
					tinsert(menuData,{
						func = function()
							kAuction:Wishlist_SetFilterValueFlag(v.id, 'enabled', not v.enabled);
							kAuction:WishlistGui_RefreshMainFrame();
						end,
						text = v.name,
						checked = v.enabled,
						hasArrow = false,
						tooltipTitle = v.name,
						keepShownOnClick = true,
						tooltipText = "Click to set to Toggle the '" .. v.name .."' Filter",
					});				
				end
			end
			-- Count sub menus, create additions
			if oSubs and #oSubs > 0 then
				for i=#oSubs,1,-1 do
					if i == 1 then
						tinsert(menuData,{
							func = function()
							end,
							text = "More",
							hasArrow = true,
							tooltipTitle = "More",
							tooltipText = "See more options.",
							menuList = oSubs[i],
						});	
					else
						tinsert(oSubs[i-1],{
							func = function()
							end,
							text = "More",
							hasArrow = true,
							tooltipTitle = "More",
							tooltipText = "See more options.",
							menuList = oSubs[i],
						});
					end
				end
			end
		end
		if menuData and #menuData > 0 then
			kAuction:Gui_CreateDropdownMenuTimer()
			EasyMenu(menuData, self.menu, anchorFrame, 0, 0, "MENU", 1.5)
		end	
	end
end
function kAuction:WishlistGui_GetFilterSubMenu(key)
	local menuData = {};
	local iIndex = kAuction:Wishlist_GetFilterIndexByKey(key);
	if iIndex then
		for i,v in pairs(self.db.profile.wishlist.config.searchFilters[iIndex].values) do
			local name = v.name;
			if v.value == -2 then
				name = 'Heroic 5-Man';
			elseif v.value == -1 then
				name = 'Normal 5-Man';
			elseif v.value == 1 then
				name = 'Normal 10-Man';
			elseif v.value == 2 then
				name = 'Normal 25-Man';
			elseif v.value == 3 then
				name = 'Heroic 10-Man';						
			elseif v.value == 4 then
				name = 'Heroic 25-Man';
			end		
			tinsert(menuData,{
				func = function()
					kAuction:Wishlist_SetFilterValueFlag(v.id, 'enabled', not v.enabled);
					kAuction:WishlistGui_RefreshMainFrame();
				end,
				text = name,
				checked = v.enabled,
				hasArrow = false,
				tooltipTitle = name,
				tooltipText = "Click to set to Toggle the '" .. name .."' Filter",
				keepShownOnClick = true,
			});
		end
	end
	if menuData and #menuData > 0 then
		return menuData;
	else
		return nil;
	end
end
function kAuction:WishlistGui_SpellSearchQuery(query, parent, initialLoad)
	parent:ReleaseChildren();
	if query ~= '' then
		local fHeader = self.AceGUI:Create("SimpleGroup");
		fHeader:SetHeight(70);
		fHeader:SetFullWidth(true);
		fHeader:SetLayout("Flow");
		parent:AddChild(fHeader);		
		
		local fhName = self.AceGUI:Create("InteractiveLabel");
		fhName:SetText('Name');
		--fhName:SetFont("Fonts\\FRIZQT__.TTF", 13);
		fhName.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fhName.frame,0,0,0,0);
		fhName:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
			if self.db.profile.wishlist.config.spellSearchSortKey == 'name' and self.db.profile.wishlist.config.spellSearchSortOrderNormal then
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Reverse Sort by Name|r");
			else
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Sort by Name|r");
			end
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(fhName.frame,0.9,0.9,0.9,0.1);		
		end);
		fhName:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(fhName.frame,0,0,0,0);		
		end);
		fhName:SetCallback('OnClick', function(a,b,c,d)
			if c == 'LeftButton' then
				kAuction:WishlistGui_UpdateSpellSearchSortKey('name');
				kAuction:WishlistGui_RefreshMainFrame();				
			end
		end);		
		fHeader:AddChild(fhName);	
		
		local fhCastTime = self.AceGUI:Create("InteractiveLabel");
		fhCastTime:SetText('Cast Time');
		fhCastTime.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fhCastTime.frame,0,0,0,0);
		fhCastTime:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
			if self.db.profile.wishlist.config.spellSearchSortKey == 'castTime' and self.db.profile.wishlist.config.spellSearchSortOrderNormal then
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Reverse Sort by Cast Time|r");
			else
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Sort by Cast Time|r");
			end
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(fhCastTime.frame,0.9,0.9,0.9,0.1);		
		end);
		fhCastTime:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(fhCastTime.frame,0,0,0,0);		
		end);
		fhCastTime:SetCallback('OnClick', function(a,b,c,d)
			if c == 'LeftButton' then
				kAuction:WishlistGui_UpdateSpellSearchSortKey('castTime');
				kAuction:WishlistGui_RefreshMainFrame();				
			end
		end);		
		fHeader:AddChild(fhCastTime);
		
		local fhMinRange = self.AceGUI:Create("InteractiveLabel");
		fhMinRange:SetText('Min Range');
		fhMinRange.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fhMinRange.frame,0,0,0,0);
		fhMinRange:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
			if self.db.profile.wishlist.config.spellSearchSortKey == 'minRange' and self.db.profile.wishlist.config.spellSearchSortOrderNormal then
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Reverse Sort by Min Range|r");
			else
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Sort by Min Range|r");
			end
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(fhMinRange.frame,0.9,0.9,0.9,0.1);		
		end);
		fhMinRange:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(fhMinRange.frame,0,0,0,0);		
		end);
		fhMinRange:SetCallback('OnClick', function(a,b,c,d)
			if c == 'LeftButton' then
				kAuction:WishlistGui_UpdateSpellSearchSortKey('minRange');
				kAuction:WishlistGui_RefreshMainFrame();				
			end
		end);		
		fHeader:AddChild(fhMinRange);
		
		local fhMaxRange = self.AceGUI:Create("InteractiveLabel");
		fhMaxRange:SetText('Max Range');
		fhMaxRange.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fhMaxRange.frame,0,0,0,0);
		fhMaxRange:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:ClearLines();
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
			if self.db.profile.wishlist.config.spellSearchSortKey == 'maxRange' and self.db.profile.wishlist.config.spellSearchSortOrderNormal then
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Reverse Sort by Max Range|r");
			else
				GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Sort by Max Range|r");
			end
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(fhMaxRange.frame,0.9,0.9,0.9,0.1);		
		end);
		fhMaxRange:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(fhMaxRange.frame,0,0,0,0);		
		end);
		fhMaxRange:SetCallback('OnClick', function(a,b,c,d)
			if c == 'LeftButton' then
				kAuction:WishlistGui_UpdateSpellSearchSortKey('maxRange');
				kAuction:WishlistGui_RefreshMainFrame();				
			end
		end);		
		fHeader:AddChild(fhMaxRange);
		
		-- Set Widths
		fhName:SetRelativeWidth(0.64);		
		fhCastTime:SetRelativeWidth(0.12);
		fhMinRange:SetRelativeWidth(0.12);
		fhMaxRange:SetRelativeWidth(0.12);
	
		local objItems = kAuction:WishlistGui_GetSpellSearchQueryResultSet(query, initialLoad);
		if objItems and #objItems > 0 then
			self.gui.frames.list.main.spellSearchSummary:SetText('Showing ' .. #objItems .. ' results of ' .. #self.spellLoader.spells .. ' total');
			for i,v in pairs(objItems) do
				local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(v.id);
				local fItem = self.AceGUI:Create("SimpleGroup");
				fItem:SetHeight(70);
				fItem:SetFullWidth(true);
				fItem:SetLayout("Flow");
				fItem.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
				kAuction:Gui_SetFrameBackdropColor(fItem.frame,0,0,0,0);
				parent:AddChild(fItem);		
				
				local name = self.AceGUI:Create("InteractiveLabel");
				name:SetText(v.name);
				name:SetImage(icon);
				name:SetImageSize(20,20);
				name:SetCallback("OnEnter", function(widget,event,val)
					GameTooltip:ClearLines();
					GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
					GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
					if GetSpellLink(v.id) then
						GameTooltip:SetHyperlink(GetSpellLink(v.id));
					end
					GameTooltip:Show();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
				end);
				name:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				fItem:AddChild(name);
				
				local fCastTime = self.AceGUI:Create("InteractiveLabel");
				fCastTime:SetText(v.castTime);
				fItem:AddChild(fCastTime);
				
				local fMinRange = self.AceGUI:Create("InteractiveLabel");
				fMinRange:SetText(v.minRange);
				fItem:AddChild(fMinRange);
				
				local fMaxRange = self.AceGUI:Create("InteractiveLabel");
				fMaxRange:SetText(v.maxRange);
				fItem:AddChild(fMaxRange);
				
				-- Set Widths
				name:SetRelativeWidth(0.64);	
				fCastTime:SetRelativeWidth(0.12);	
				fMinRange:SetRelativeWidth(0.12);
				fMaxRange:SetRelativeWidth(0.12);	
			end
		end
	else
		self.gui.frames.list.main.spellSearchSummary:SetText('');
	end
end
function kAuction:WishlistGui_GetSearchQueryResultSet(query, initialLoad)
	if initialLoad == true then
		return nil;
	end
	objData = {};
	local iCount = 0;
	kAuction:WishlistGui_SortSearchResults(self.itemLoader.items);
	-- Check for matches with words as query
	local oFilterMatches = {};
	for i,v in pairs(self.itemLoader.items) do
		wipe(oFilterMatches);
		-- Loop filters
		for iFilter,vFilter in pairs(self.db.profile.wishlist.config.searchFilters) do
			-- For each filter key found in item data, run check
			oFilterMatches[vFilter.key] = false;
			for iV,vV in pairs(vFilter.values) do
				if vV.name == 'Empty' then
					if vV.type == 'match' then
						if v[vFilter.key] then
							if v[vFilter.key] == '' then 
								if vV.enabled then
									oFilterMatches[vFilter.key] = true;
									break;
								end
							end
						else
							if vV.enabled then
								oFilterMatches[vFilter.key] = true;
								break;
							end
						end
					end
				else
					-- Key exists
					if v[vFilter.key] and v[vFilter.key] ~= nil then
						if vV.type == 'match' then
							if vV.value == v[vFilter.key] then
								if vV.enabled then
									oFilterMatches[vFilter.key] = true;
									break;
								end
							end
						end
					end
				end
			end
		end
		local booFilterPass = true;
		-- Any mismatched filters?
		for iF,vF in pairs(oFilterMatches) do
			if vF == false then
				booFilterPass = false;
			end
		end
		if booFilterPass then
			local booMatch = false;
			for w in string.gmatch(strlower(v.name), "[%a%p]+") do
				if string.sub(w, 1, string.len(strlower(query))) == strlower(query) then
					booMatch = true;
				end
			end
			if string.match(strlower(v.name), strlower(query)) then
				booMatch = true;
			end
			if v.mobName then
				for w in string.gmatch(strlower(v.mobName), "[%a%p]+") do
					if string.sub(w, 1, string.len(strlower(query))) == strlower(query) then
						booMatch = true;
					end
				end
				if string.match(strlower(v.mobName), strlower(query)) then
					booMatch = true;
				end
			end
			if v.zoneName then
				for w in string.gmatch(strlower(v.zoneName), "[%a%p]+") do
					if string.sub(w, 1, string.len(strlower(query))) == strlower(query) then
						booMatch = true;
					end
				end
				if string.match(strlower(v.zoneName), strlower(query)) then
					booMatch = true;
				end
			end
			if booMatch then
				iCount = iCount + 1;
				if iCount > self.db.profile.wishlist.config.searchReturnLimit then
					break;
				end
				local vNew = {};
				for iOld,vOld in pairs(v) do
					vNew[iOld] = vOld;
				end
				local bIsInList = kAuction:Wishlist_GetWishlistItemMatches(vNew.id);
				if bIsInList then
					vNew.isInList = true;
				else
					vNew.isInList = false;
				end
				tinsert(objData, vNew);
			end
		end
	end
	if objData and #objData > 0 then
		for iD,vD in pairs(objData) do
			if vD.name then
				vD.name = kAuction:ColorizeSubstringInString(vD.name, query, 0.9, 0, 0);
			end
			if vD.mobName then
				vD.mobName = kAuction:ColorizeSubstringInString(vD.mobName, query, 0.9, 0, 0);
			end
			if vD.zoneName then
				vD.zoneName = kAuction:ColorizeSubstringInString(vD.zoneName, query, 0.9, 0, 0);
			end
		end
		return objData;
	else
		return nil;
	end
end
function kAuction:WishlistGui_GetSpellSearchQueryResultSet(query, initialLoad)
	if initialLoad == true then
		return nil;
	end
	objData = {};
	local iCount = 0;
	-- Check for matches with words as query
	for i,v in pairs(self.spellLoader.spells) do
		local booMatch = false;
		for w in string.gmatch(strlower(v.name), "[%a%p]+") do
			if string.sub(w, 1, string.len(strlower(query))) == strlower(query) then
				booMatch = true;
			end
		end
		if string.match(strlower(v.name), strlower(query)) then
			booMatch = true;
		end
		if booMatch then
			iCount = iCount + 1;
			if iCount > self.db.profile.wishlist.config.spellSearchReturnLimit then
				break;
			end
			local vNew = {};
			for iOld,vOld in pairs(v) do
				vNew[iOld] = vOld;
			end
			tinsert(objData, vNew);
		end
	end
	if objData and #objData > 0 then
		-- Sort data
		kAuction:WishlistGui_SortSpellSearchResults(objData);
		for iD,vD in pairs(objData) do
			if vD.name then
				vD.name = kAuction:ColorizeSubstringInString(vD.name, query, 0.9, 0, 0);
			end
		end
		return objData;
	else
		return nil;
	end
end
function kAuction:WishlistGui_CreateListItemBidTypeDropdown(listId, itemId, anchorFrame)	
	local bidType = kAuction:Wishlist_GetItemFlag(listId, itemId, 'bidType');	
	local menuData = {};
	tinsert(menuData, {
		func = function() end,
		isTitle = true,
		text = 'Bid Type',
		hasArrow = false,
		notClickable = true,
		notCheckable = true,
	});
	local bNormal = false;
	local bOffspec = false;
	local bRot = false;
	if bidType == 'normal' then
		bNormal = true;
	elseif bidType == 'offspec' then
		bOffspec = true;
	elseif bidType == 'rot' then
		bRot = true;
	end
	tinsert(menuData,{
		func = function()
			self.menu:Hide();
			kAuction:Wishlist_SetItemFlag(listId, itemId, 'bidType', 'normal');
			kAuction:WishlistGui_ShowList(nil, listId);
		end,
		text = "Normal",
		checked = bNormal,
		hasArrow = false,
		tooltipTitle = "Set to Normal",
		tooltipText = "Click to set to Normal Bid Type",
	});
	tinsert(menuData,{
		func = function()
			self.menu:Hide();
			kAuction:Wishlist_SetItemFlag(listId, itemId, 'bidType', 'offspec');
			kAuction:WishlistGui_ShowList(nil, listId);
		end,
		text = "Offspec",
		checked = bOffspec,
		hasArrow = false,
		tooltipTitle = "Set to Normal",
		tooltipText = "Click to set to Normal Bid Type",
	});
	tinsert(menuData,{
		func = function()
			self.menu:Hide();
			kAuction:Wishlist_SetItemFlag(listId, itemId, 'bidType', 'rot');
			kAuction:WishlistGui_ShowList(nil, listId);
		end,
		text = "Rot",
		checked = bRot,
		hasArrow = false,
		tooltipTitle = "Set to Rot",
		tooltipText = "Click to set to Rot Bid Type",
	});	
	if menuData and #menuData > 0 then
		kAuction:Gui_CreateDropdownMenuTimer()
		EasyMenu(menuData, self.menu, anchorFrame, 0, 0, "MENU", 1.5)
	end
end
function kAuction:WishlistGui_CreateListItemDropdown(listId, itemId, anchorFrame, itemName)	
	-- Check if item is in list
	local oWith = kAuction:Wishlist_GetWishlistsWithItem(itemId);
	local oWithout = kAuction:Wishlist_GetWishlistsWithoutItem(itemId);
	local tRemove = {};
	local tAdd = {};
	local menuListWith = {};
	local menuListWithout = {};	
	if oWith and #oWith > 0 then
		for i,v in pairs(oWith) do
			tinsert(menuListWith, {
				notCheckable = true,		
				func = function()
					self.menu:Hide();
					kAuction:Wishlist_RemoveItem(v.id, itemId);
					kAuction:WishlistGui_ShowList(nil, listId);
				end,
				text = v.name,
				tooltipTitle = "Remove from the " .. v.name .. " Wishlist",
				tooltipText = "Click to remove from the " .. v.name .. " wishlist.",
				value = "none",
			});
		end
	end
	if oWithout and #oWithout > 0 then
		for i,v in pairs(oWithout) do
			tinsert(menuListWithout, {
				notCheckable = true,		
				func = function()
					if GetItemInfo(itemId) then
						kAuction:Wishlist_AddItem(v.id, GetItemInfo(itemId), itemId);
					else
						kAuction:Wishlist_AddItem(v.id, itemName, itemId);
					end					
					kAuction:WishlistGui_ShowList(nil, listId);
					self.menu:Hide();
				end,
				text = v.name,
				tooltipTitle = "Add to the " .. v.name .. " Wishlist",
				tooltipText = "Click to add to the " .. v.name .. " wishlist,",
				value = "none",
			});
		end
	end
	local menuData = {};
	if menuListWithout and #menuListWithout > 0 or menuListWith and #menuListWith > 0 then
		tinsert(menuData,{
			func = function() end,
			isTitle = true,
			text = "Remove from Wishlist",
			hasArrow = true,
			menuList = menuListWith,
		});
		tinsert(menuData,{
			func = function() end,
			isTitle = true,
			text = "Add to Wishlist",
			hasArrow = true,
			menuList = menuListWithout,
		});
	elseif menuListWithout and #menuListWithout > 0 then
		tinsert(menuData,{
			func = function() end,
			isTitle = true,
			text = "Add to Wishlist",
			hasArrow = true,
			menuList = menuListWithout,
		});
	elseif menuListWith and #menuListWith > 0 then
		tinsert(menuData,{
			func = function() end,
			isTitle = true,
			text = "Remove from Wishlist",
			hasArrow = true,
			menuList = menuListWith,
		});
	end
	if (oWith and #oWith > 0) or (oWithout and #oWithout > 0) then
		kAuction:Gui_CreateDropdownMenuTimer()
		EasyMenu(menuData, self.menu, anchorFrame, 0, 0, "MENU", 1.5)
	end
end
function kAuction:WishlistGui_CreateSearchItemDropdown2(itemId, anchorFrame)	
	-- Check if item is in list
	local oWith = kAuction:Wishlist_GetWishlistsWithItem(itemId);
	local oWithout = kAuction:Wishlist_GetWishlistsWithoutItem(itemId);
	local tRemove = {};
	local tAdd = {};
	local menuListWith = {};
	local menuListWithout = {};	
	if oWith and #oWith > 0 then
		for i,v in pairs(oWith) do
			tinsert(menuListWith, {
				notCheckable = true,		
				func = function()
					self.menu:Hide();
					kAuction:Wishlist_RemoveItem(v.id, itemId);
					kAuction:WishlistGui_SearchQuery(self.gui.frames.list.main.searchBox['editbox']['obj'].lasttext, self.gui.frames.list.main.searchScroll);
				end,
				text = v.name,
				tooltipTitle = "Remove from the " .. v.name .. " Wishlist",
				tooltipText = "Click to remove " .. select(2, GetItemInfo(itemId)) .. " from the " .. v.name .. " wishlist.",
				value = "none",
			});
		end
	end
	if oWithout and #oWithout > 0 then
		for i,v in pairs(oWithout) do
			tinsert(menuListWithout, {
				notCheckable = true,		
				func = function()
					self.menu:Hide();
					kAuction:Wishlist_AddItem(v.id, GetItemInfo(itemId), itemId);
					kAuction:WishlistGui_SearchQuery(self.gui.frames.list.main.searchBox['editbox']['obj'].lasttext, self.gui.frames.list.main.searchScroll);
				end,
				text = v.name,
				tooltipTitle = "Add to the " .. v.name .. " Wishlist",
				tooltipText = "Click to add " .. select(2, GetItemInfo(itemId)) .. " to the " .. v.name .. " wishlist,",
				value = "none",
			});
		end
	end
	local menuData = {};
	tinsert(menuData, {
		func = function() end,
		isTitle = true,
		text = select(2, GetItemInfo(itemId)),
		hasArrow = false,
		notClickable = true,
		notCheckable = true,
	});
	if menuListWithout and #menuListWithout > 0 and menuListWith and #menuListWith > 0 then
		tinsert(menuData,{
			func = function() end,
			isTitle = true,
			text = "Remove from Wishlist",
			hasArrow = true,
			menuList = menuListWith,
		});
		tinsert(menuData,{
			func = function() end,
			isTitle = true,
			text = "Add to Wishlist",
			hasArrow = true,
			menuList = menuListWithout,
		});
	elseif menuListWithout and #menuListWithout > 0 then
		tinsert(menuData,{
			func = function() end,
			isTitle = true,
			text = "Add to Wishlist",
			hasArrow = true,
			menuList = menuListWithout,
		});
	elseif menuListWith and #menuListWith > 0 then
		tinsert(menuData,{
			func = function() end,
			isTitle = true,
			text = "Remove from Wishlist",
			hasArrow = true,
			menuList = menuListWith,
		});
	end
	if (oWith and #oWith > 0) or (oWithout and #oWithout > 0) then
		kAuction:Gui_CreateDropdownMenuTimer()
		EasyMenu(menuData, self.menu, anchorFrame, 0, 0, "MENU", 1.5)
	end
end
function kAuction:WishlistGui_CreateSearchItemDropdown(itemId, anchorFrame)	
	-- Get all lists
	local oLists = kAuction:Wishlist_GetLists();
	-- Check if item is in list
	local oWith = kAuction:Wishlist_GetWishlistsWithItem(itemId);

	local tRemove = {};
	local tAdd = {};
	local menuListWith = {};
	local menuListWithout = {};	
	
	local menuData = {};
	tinsert(menuData, {
		func = function() end,
		isTitle = true,
		text = select(2, GetItemInfo(itemId)),
		hasArrow = false,
		notClickable = true,
		notCheckable = true,
	});
	tinsert(menuData, {
		func = function() end,
		isTitle = true,
		text = 'Active Wishlists',
		hasArrow = false,
		notClickable = true,
		notCheckable = true,
	});
	if oLists and #oLists > 0 then
		for iL,vL in pairs(oLists) do
			local booMatch = false;
			-- If oWith has data
			if oWith and #oWith > 0 then
				for iW,vW in pairs(oWith) do
					-- Find matching wishlist
					if vW.id == vL.id then
						booMatch = true;
						-- Match, remove item
						tinsert(menuData,{
							func = function()
								kAuction:Wishlist_RemoveItem(vL.id, itemId);
								kAuction:WishlistGui_SearchQuery(self.gui.frames.list.main.searchBox['editbox']['obj'].lasttext, self.gui.frames.list.main.searchScroll);
							end,
							text = vL.name,
							tooltipTitle = "Remove from the " .. vL.name .. " Wishlist",
							tooltipText = "Click to remove " .. select(2, GetItemInfo(itemId)) .. " from the " .. vL.name .. " wishlist.",
							value = "none",						
							checked = true,
							hasArrow = false,
						});		
					end
				end
			end
			if booMatch == false then
				tinsert(menuData,{
					func = function()
						kAuction:Wishlist_AddItem(vL.id, GetItemInfo(itemId), itemId);
						kAuction:WishlistGui_SearchQuery(self.gui.frames.list.main.searchBox['editbox']['obj'].lasttext, self.gui.frames.list.main.searchScroll);
					end,
					text = vL.name,
					tooltipTitle = "Add to the " .. vL.name .. " Wishlist",
					tooltipText = "Click to add " .. select(2, GetItemInfo(itemId)) .. " to the " .. vL.name .. " wishlist,",
					value = "none",								
					checked = false,
					hasArrow = false,
				});			
			end	
		end
	end
	if (oLists and #oLists > 0) then
		kAuction:Gui_CreateDropdownMenuTimer()
		EasyMenu(menuData, self.menu, anchorFrame, 0, 0, "MENU", 1.5)
	end
end
function kAuction:WishlistGui_CreateWidget_SectionDropdown(parent)
	local f = self.AceGUI:Create("DropdownGroup")
	f:SetLayout("Fill")
	f:SetGroupList({list = "Wishlists", search = "Search"})
	f:SetGroup(self.db.profile.wishlist.config.selectedSection);
	f:SetDropdownWidth(150);
	--f:SetTitle("Select Section")
	f:SetCallback('OnGroupSelected', function(widget,event,val)
		self.db.profile.wishlist.config.selectedSection = val;
		kAuction:WishlistGui_RefreshMainFrame();
	end);
	parent:AddChild(f);
	if self.db.profile.wishlist.config.selectedSection == 'search' then
		self.gui.frames.list.main.searchBox = self.AceGUI:Create('EditBox');
		self.gui.frames.list.main.searchBox:SetWidth(190);
		self.gui.frames.list.main.searchBox:SetLabel('Search');
		self.gui.frames.list.main.searchBox:SetPoint("TOPRIGHT", f.frame, "TOPRIGHT", 0, 15);
		parent:AddChild(self.gui.frames.list.main.searchBox);	
			
		self.gui.frames.list.main.refreshButton = self.AceGUI:Create('Button');
		self.gui.frames.list.main.refreshButton:SetWidth(85);
		self.gui.frames.list.main.refreshButton:SetText('Refresh');
		self.gui.frames.list.main.refreshButton:SetPoint("RIGHT", self.gui.frames.list.main.searchBox.frame, "LEFT", 0, -7);
		self.gui.frames.list.main.refreshButton:SetCallback("OnClick", function(widget,event,val)
			--kAuction:WishlistGui_LoadItems();
		end);
		parent:AddChild(self.gui.frames.list.main.refreshButton);	
		
		self.gui.frames.list.main.searchSummary = self.AceGUI:Create('InteractiveLabel');
		self.gui.frames.list.main.searchSummary:SetWidth(230);
		self.gui.frames.list.main.searchSummary:SetText('');
		self.gui.frames.list.main.searchSummary:SetPoint("TOP", self.gui.frames.list.main.frame, "TOP", 0, -35);
		parent:AddChild(self.gui.frames.list.main.searchSummary);	
	elseif self.db.profile.wishlist.config.selectedSection == 'list' then
		self.gui.frames.list.main.addNewListBox = self.AceGUI:Create('EditBox');
		self.gui.frames.list.main.addNewListBox:SetWidth(210);
		self.gui.frames.list.main.addNewListBox:SetLabel('Add a New Wishlist');
		self.gui.frames.list.main.addNewListBox:SetPoint("TOPRIGHT", f.frame, "TOPRIGHT", 0, 15);
		self.gui.frames.list.main.addNewListBox:SetCallback('OnEnterPressed', function(widget,event,val)
			if val ~= '' then
				kAuction:Wishlist_Create(val, true);
				self.gui.frames.list.main.addNewListBox:SetText('');
				kAuction:WishlistGui_RefreshMainFrame();
			end
		end);
		parent:AddChild(self.gui.frames.list.main.addNewListBox);			
	end
	
	return f;
end
function kAuction:WishlistGui_SortSearchResults(dataSet)
	if dataSet then
		table.sort(dataSet, function(a,b)
			if a[self.db.profile.wishlist.config.searchSortKey] and b[self.db.profile.wishlist.config.searchSortKey] then			
				if self.db.profile.wishlist.config.searchSortOrderNormal then
					if a[self.db.profile.wishlist.config.searchSortKey] < b[self.db.profile.wishlist.config.searchSortKey] then
						return true;
					else
						return false;
					end
				else
					if a[self.db.profile.wishlist.config.searchSortKey] > b[self.db.profile.wishlist.config.searchSortKey] then
						return true;
					else
						return false;
					end
				end		
			elseif a[self.db.profile.wishlist.config.searchSortKey] then
				return true;
			elseif b[self.db.profile.wishlist.config.searchSortKey] then
				return false;
			end		
		end);
	end		
end
function kAuction:WishlistGui_SortSpellSearchResults(dataSet)
	if dataSet then
		table.sort(dataSet, function(a,b)
			if a[self.db.profile.wishlist.config.spellSearchSortKey] and b[self.db.profile.wishlist.config.spellSearchSortKey] then			
				if self.db.profile.wishlist.config.spellSearchSortOrderNormal then
					if a[self.db.profile.wishlist.config.spellSearchSortKey] < b[self.db.profile.wishlist.config.spellSearchSortKey] then
						return true;
					else
						return false;
					end
				else
					if a[self.db.profile.wishlist.config.spellSearchSortKey] > b[self.db.profile.wishlist.config.spellSearchSortKey] then
						return true;
					else
						return false;
					end
				end		
			elseif a[self.db.profile.wishlist.config.spellSearchSortKey] then
				return true
			elseif b[self.db.profile.wishlist.config.spellSearchSortKey] then
				return false;
			end		
		end);
	end		
end
function kAuction:WishlistGui_GetWidget_ListHeader(listId, parent)
	local f = self.AceGUI:Create("SimpleGroup");
	f:SetFullWidth(true);
	f:SetLayout("Flow");
	
	local hName = self.AceGUI:Create("InteractiveLabel");
	hName:SetText("Name");
	hName:SetCallback("OnClick", function(widget,event,val)
		kAuction:Wishlist_SortList(listId, 'name');
		kAuction:WishlistGui_ShowList(parent.parent, listId);
	end);
	hName:SetCallback("OnEnter", function(widget,event,val)
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
		if self.db.profile.wishlist.config.listSortKey == 'name' and self.db.profile.wishlist.config.listSortOrderNormal then
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Reverse Sort by Name|r");
		else
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Sort by Name|r");
		end
		GameTooltip:Show();
		kAuction:Gui_SetFrameBackdropColor(hName.frame,0.9,0.9,0.9,0.1);		
	end);
	hName:SetCallback("OnLeave", function(widget,event,val)
		GameTooltip:Hide();
		kAuction:Gui_SetFrameBackdropColor(hName.frame,0,0,0,0);		
	end);
	hName.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
	kAuction:Gui_SetFrameBackdropColor(hName.frame,0,0,0,0);	
	f:AddChild(hName);
	
	local hLevel = self.AceGUI:Create("InteractiveLabel");
	hLevel:SetText("Level");
	hLevel:SetCallback("OnClick", function(widget,event,val)
		kAuction:Wishlist_SortList(listId, 'level');
		kAuction:WishlistGui_ShowList(parent.parent, listId);
	end);
	hLevel:SetCallback("OnEnter", function(widget,event,val)
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
		if self.db.profile.wishlist.config.listSortKey == 'level' and self.db.profile.wishlist.config.listSortOrderNormal then
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Reverse Sort by Level|r");
		else
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Sort by Level|r");
		end
		GameTooltip:Show();
		kAuction:Gui_SetFrameBackdropColor(hLevel.frame,0.9,0.9,0.9,0.1);		
	end);
	hLevel:SetCallback("OnLeave", function(widget,event,val)
		GameTooltip:Hide();
		kAuction:Gui_SetFrameBackdropColor(hLevel.frame,0,0,0,0);		
	end);
	hLevel.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
	kAuction:Gui_SetFrameBackdropColor(hLevel.frame,0,0,0,0);	
	f:AddChild(hLevel);
	
	local hSlot = self.AceGUI:Create('InteractiveLabel');
	hSlot:SetText('Slot');
	hSlot:SetCallback("OnClick", function(widget,event,val)
		kAuction:Wishlist_SortList(listId, 'slot');
		kAuction:WishlistGui_ShowList(parent.parent, listId);
	end);
	hSlot:SetCallback("OnEnter", function(widget,event,val)
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
		if self.db.profile.wishlist.config.listSortKey == 'slot' and self.db.profile.wishlist.config.listSortOrderNormal then
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Reverse Sort by Item Slot|r");
		else
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Sort by Item Slot|r");
		end
		GameTooltip:Show();
		kAuction:Gui_SetFrameBackdropColor(hSlot.frame,0.9,0.9,0.9,0.1);		
	end);
	hSlot:SetCallback("OnLeave", function(widget,event,val)
		GameTooltip:Hide();
		kAuction:Gui_SetFrameBackdropColor(hSlot.frame,0,0,0,0);		
	end);
	hSlot.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
	kAuction:Gui_SetFrameBackdropColor(hSlot.frame,0,0,0,0);	
	f:AddChild(hSlot);
	
	local hAlert = self.AceGUI:Create("InteractiveLabel");
	hAlert:SetText("Alert");
	f:AddChild(hAlert);
	
	local hAutoBid = self.AceGUI:Create("InteractiveLabel");
	hAutoBid:SetText("Auto-bid");
	f:AddChild(hAutoBid);
	
	local hAutoRemove = self.AceGUI:Create("InteractiveLabel");
	hAutoRemove:SetText("Auto-remove");
	f:AddChild(hAutoRemove);
	
	local hBestInSlot = self.AceGUI:Create("InteractiveLabel");
	hBestInSlot:SetText("Best in Slot");
	f:AddChild(hBestInSlot);
	
	local hSetBonus = self.AceGUI:Create("InteractiveLabel");
	hSetBonus:SetText("Set Bonus");
	f:AddChild(hSetBonus);
	
	local hBidType = self.AceGUI:Create("InteractiveLabel");
	hBidType:SetText("Bid Type");
	hBidType:SetCallback("OnClick", function(widget,event,val)
		kAuction:Wishlist_SortList(listId, 'bidType');
		kAuction:WishlistGui_ShowList(parent.parent, listId);
	end);
	hBidType:SetCallback("OnEnter", function(widget,event,val)
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", widget.frame, "TOPLEFT");
		if self.db.profile.wishlist.config.listSortKey == 'bidType' and self.db.profile.wishlist.config.listSortOrderNormal then
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Reverse Sort by Bid Type|r");
		else
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255).."Click to Sort by Bid Type|r");
		end
		GameTooltip:Show();
		kAuction:Gui_SetFrameBackdropColor(hBidType.frame,0.9,0.9,0.9,0.1);		
	end);
	hBidType:SetCallback("OnLeave", function(widget,event,val)
		GameTooltip:Hide();
		kAuction:Gui_SetFrameBackdropColor(hBidType.frame,0,0,0,0);		
	end);
	hBidType.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
	kAuction:Gui_SetFrameBackdropColor(hBidType.frame,0,0,0,0);	
	f:AddChild(hBidType);
	
	hName:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
	hLevel:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
	hSlot:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
	hAlert:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
	hAutoBid:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
	hAutoRemove:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
	hBestInSlot:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
	hSetBonus:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
	hBidType:SetFont(sharedMedia:Fetch("font", "Arial Narrow"), 12, "");
	
	-- Set Widths
	hName:SetRelativeWidth(0.35); -- 35
	hLevel:SetRelativeWidth(0.07); -- 7
	hSlot:SetRelativeWidth(0.16);-- 16
	hAlert:SetRelativeWidth(0.06); -- 6
	hAutoBid:SetRelativeWidth(0.06); -- 6	
	hAutoRemove:SetRelativeWidth(0.07); -- 7
	hBestInSlot:SetRelativeWidth(0.06); -- 6
	hSetBonus:SetRelativeWidth(0.07); -- 7
	hBidType:SetRelativeWidth(0.095); -- 10
	
	return f;
end
function kAuction:WishlistGui_ShowList(parent, id)
	local listId = nil;
	if id then
		listId = id;
	elseif self.gui.frames.list.selectedWishlist then
		listId = self.gui.frames.list.selectedWishlist;
	end	
	local list = kAuction:Wishlist_GetListById(listId);
	-- Check if valid list returned
	if list then
		if self.gui.frames.list.tree then
			self.gui.frames.list.tree:ReleaseChildren();
		end
		local fScroll = self.AceGUI:Create("ScrollFrame")
		fScroll:SetFullWidth(true);
		fScroll:SetLayout("Flow")
		-- Add Header
		fScroll:AddChild(kAuction:WishlistGui_GetWidget_ListHeader(listId, fScroll));
		if list.items and #list.items > 0 then
			for i,v in pairs(list.items) do
				local fInline = self.AceGUI:Create("SimpleGroup");
				fInline:SetFullWidth(true);
				fInline:SetLayout("Flow");
				fInline.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
				kAuction:Gui_SetFrameBackdropColor(fInline.frame,0,0,0,0);
				fScroll:AddChild(fInline);		
				
				local name = self.AceGUI:Create("InteractiveLabel");
				local iLink = select(2, GetItemInfo(v.id));
				--name:SetFont("Fonts\\FRIZQT__.TTF", 13);
				if iLink then
					local iIcon = select(10, GetItemInfo(v.id));
					name:SetText(iLink);
					name:SetImage(iIcon);
					name:SetImageSize(self.db.profile.wishlist.config.iconSize,self.db.profile.wishlist.config.iconSize);
					name:SetCallback("OnEnter", function(widget,event,val)
						GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
						GameTooltip:ClearLines();
						GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
						GameTooltip:SetHyperlink(iLink);
						GameTooltip:Show();
						kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
					end);
					name:SetCallback("OnLeave", function(widget,event,val)
						GameTooltip:Hide();
						kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
					end);
					name:SetCallback("OnClick", function(widget,event,c)
						if c == 'LeftButton' then
							if IsControlKeyDown() then
								DressUpItemLink(iLink);
							elseif IsShiftKeyDown() then
								kAuction:Item_SendHyperlinkToChat(iLink);
							end
						elseif c == 'RightButton' then
							kAuction:WishlistGui_CreateListItemDropdown(listId, v.id, widget.frame);
						end
					end);
				else
					name:SetText(v.name);
					name:SetCallback("OnEnter", function(widget,event,val)
						GameTooltip:ClearLines();
						GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
						GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(189,0,0).."Item cannot be located in local cache.|r");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(189,0,0).."Details are currently unavailable.|r");
						GameTooltip:Show();
						kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
					end);
					name:SetCallback("OnLeave", function(widget,event,val)
						GameTooltip:Hide();
						kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
					end);
					name:SetCallback("OnClick", function(widget,event,c)
						if c == 'RightButton' then
							kAuction:WishlistGui_CreateListItemDropdown(listId, v.id, widget.frame, v.name);
						end
					end);
				end
				fInline:AddChild(name);
				
				local level = self.AceGUI:Create("InteractiveLabel");
				if iLink then
					local iLevel = select(4, GetItemInfo(v.id));
					level:SetText(iLevel);
				end
				level:SetPoint("LEFT", _G[name], "RIGHT");
				level:SetCallback("OnEnter", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
				end);
				level:SetCallback("OnLeave", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				fInline:AddChild(level);
				
				local lSlot = self.AceGUI:Create('InteractiveLabel');
				if v.slot then
					lSlot:SetText(v.slot);
				end
				lSlot:SetCallback("OnEnter", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
				end);
				lSlot:SetCallback("OnLeave", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				fInline:AddChild(lSlot);
				
				
				local lAlert = self.AceGUI:Create("InteractiveLabel");			
				if v.alert then
					lAlert:SetColor(0,1,0);
					lAlert:SetText("Yes");
				else
					lAlert:SetColor(0.8,0,0);
					lAlert:SetText("No");
				end
				lAlert:SetPoint("RIGHT");
				lAlert:SetCallback("OnEnter", function(widget,event,val)
						kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
						GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
						GameTooltip:ClearLines();
						GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Alert|r");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
						"Enable this flag to tell kAuction to alert you|n" ..
						"with a pop-up when this item drops with a|n" ..
						"prompt to bid.|n|n"..
						"If Auto-bid is enabled for this item, Alert|n" ..
						"will instead provide a popup reminding you|n" ..
						"a bid has been made automatically with the|n" ..
						"option to continue or cancel your bid.|r");
						GameTooltip:AddLine(" ");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(175,150,0).."Left-click to toggle.|r");
						GameTooltip:Show();
					end);
				lAlert:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				lAlert:SetCallback('OnClick', function(a,b,c,d)
					if c == 'LeftButton' then
						kAuction:Wishlist_SetItemFlag(listId, v.id, 'alert', not v.alert);
						kAuction:WishlistGui_ShowList(nil, listId);
					end
				end);
				fInline:AddChild(lAlert);	
				
				local lAutoBid = self.AceGUI:Create("InteractiveLabel");			
				if v.autoBid then
					lAutoBid:SetColor(0,1,0);
					lAutoBid:SetText("Yes");
				else
					lAutoBid:SetColor(0.8,0,0);
					lAutoBid:SetText("No");
				end
				lAutoBid:SetPoint("RIGHT");
				lAutoBid:SetCallback("OnEnter", function(widget,event,val)
						kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
						GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
						GameTooltip:ClearLines();
						GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Auto-Bid|r");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
						"Enable this flag to have kAuction automatically|n"..
						"bid on this item with the selected Bid Type|n" ..
						"and Best in Slot settings.|r");
						GameTooltip:AddLine(" ");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(175,150,0).."Left-click to toggle.|r");
						GameTooltip:Show();
					end);
				lAutoBid:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				lAutoBid:SetCallback('OnClick', function(a,b,c,d)
					if c == 'LeftButton' then
						kAuction:Wishlist_SetItemFlag(listId, v.id, 'autoBid', not v.autoBid);
						kAuction:WishlistGui_ShowList(nil, listId);
					end
				end);
				fInline:AddChild(lAutoBid);
				
				local lAutoRemove = self.AceGUI:Create("InteractiveLabel");			
				if v.autoRemove then
					lAutoRemove:SetColor(0,1,0);
					lAutoRemove:SetText("Yes");
				else
					lAutoRemove:SetColor(0.8,0,0);
					lAutoRemove:SetText("No");
				end
				lAutoRemove:SetPoint("RIGHT");
				lAutoRemove:SetCallback("OnEnter", function(widget,event,val)
						kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
						GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
						GameTooltip:ClearLines();
						GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Auto-Remove|r");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
						"Enable this flag to have kAuction automatically|n"..
						"remove this item from your wishlist upon winning|n"..
						"it during an auction.|r");
						GameTooltip:AddLine(" ");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(175,150,0).."Left-click to toggle.|r");
						GameTooltip:Show();
					end);
				lAutoRemove:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				lAutoRemove:SetCallback('OnClick', function(a,b,c,d)
					if c == 'LeftButton' then
						kAuction:Wishlist_SetItemFlag(listId, v.id, 'autoRemove', not v.autoRemove);
						kAuction:WishlistGui_ShowList(nil, listId);
					end
				end);
				fInline:AddChild(lAutoRemove);
				
				local lBestInSlot = self.AceGUI:Create("InteractiveLabel");			
				if v.bestInSlot then
					lBestInSlot:SetColor(0,1,0);
					lBestInSlot:SetText("Yes");
				else
					lBestInSlot:SetColor(0.8,0,0);
					lBestInSlot:SetText("No");
				end
				lBestInSlot:SetPoint("RIGHT");
				lBestInSlot:SetCallback("OnEnter", function(widget,event,val)
						kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
						GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
						GameTooltip:ClearLines();
						GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Best In Slot|r");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
						"Enable this flag to set this item as a Best in|n" ..
						"Slot item for the selected Bid Type.|r");
						GameTooltip:AddLine(" ");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(175,150,0).."Left-click to toggle.|r");
						GameTooltip:Show();
					end);
				lBestInSlot:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				lBestInSlot:SetCallback('OnClick', function(a,b,c,d)
					if c == 'LeftButton' then
						kAuction:Wishlist_SetItemFlag(listId, v.id, 'bestInSlot', not v.bestInSlot);
						kAuction:WishlistGui_ShowList(nil, listId);
					end
				end);
				fInline:AddChild(lBestInSlot);
				
				local lSetBonus = self.AceGUI:Create("InteractiveLabel");			
				if v.setBonus then
					lSetBonus:SetColor(0,1,0);
					lSetBonus:SetText("Yes");
				else
					lSetBonus:SetColor(0.8,0,0);
					lSetBonus:SetText("No");
				end
				lSetBonus:SetPoint("RIGHT");
				lSetBonus:SetCallback("OnEnter", function(widget,event,val)
						kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
						GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
						GameTooltip:ClearLines();
						GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Set Bonus|r");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
						"Enable this flag if obtaining this item will|n" ..
						"complete a item set bonus for you.|r");
						GameTooltip:AddLine(" ");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(175,150,0).."Left-click to toggle.|r");
						GameTooltip:Show();
					end);
				lSetBonus:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				lSetBonus:SetCallback('OnClick', function(a,b,c,d)
					if c == 'LeftButton' then
						kAuction:Wishlist_SetItemFlag(listId, v.id, 'setBonus', not v.setBonus);
						kAuction:WishlistGui_ShowList(nil, listId);
					end
				end);
				fInline:AddChild(lSetBonus);
					
				local lBidType = self.AceGUI:Create("InteractiveLabel");			
				if v.bidType == 'normal' then
					lBidType:SetColor(0,1,0);
				elseif v.bidType == 'offspec' then
					lBidType:SetColor(1,1,0);	
				elseif v.bidType == 'rot' then
					lBidType:SetColor(0.8,0,0);
				end
				lBidType:SetText(strupper(strsub(v.bidType, 1, 1)) .. strsub(v.bidType, 2));
				lBidType:SetPoint("RIGHT");
				lBidType:SetCallback("OnEnter", function(widget,event,val)
						kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
						GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
						GameTooltip:ClearLines();
						GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Bid Type|r");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
						"Determines the type of bid kAuction will|n" ..
						"use if Auto-Bid is enabled for this item.|r");
						GameTooltip:AddLine(" ");
						GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(175,150,0).."Left-click to edit the Bid Type.|r");
						GameTooltip:Show();
					end);
				lBidType:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				lBidType:SetCallback('OnClick', function(a,b,c,d)
					if c == 'LeftButton' then
						kAuction:WishlistGui_CreateListItemBidTypeDropdown(listId, v.id, a.frame);
					end
				end);
				fInline:AddChild(lBidType);		
				
				name:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				level:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				lSlot:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				lAlert:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				lAutoBid:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				lAutoRemove:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				lBestInSlot:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				lSetBonus:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				lBidType:SetFont(sharedMedia:Fetch("font", self.db.profile.wishlist.config.font), self.db.profile.wishlist.config.fontSize, "");
				
				-- Set Widths
				name:SetRelativeWidth(0.35); -- 35		
				level:SetRelativeWidth(0.07); -- 7	
				lSlot:SetRelativeWidth(0.16);-- 16		
				lAlert:SetRelativeWidth(0.06); -- 6			
				lAutoBid:SetRelativeWidth(0.06); -- 6		
				lAutoRemove:SetRelativeWidth(0.07); -- 7			
				lBestInSlot:SetRelativeWidth(0.06); -- 6		
				lSetBonus:SetRelativeWidth(0.07); -- 7			
				lBidType:SetRelativeWidth(0.095); -- 10		
			end  
		end  
		if parent then
			parent:AddChild(fScroll);
		else
			self.gui.frames.list.tree:AddChild(fScroll);
		end
	end
end
function kAuction:WishlistGui_CreateWidget_ListTree(parent)
	local list = kAuction:Wishlist_GetLists();
	local tree = {};
	for i,v in pairs(list) do
		tinsert(tree, {icon = v.icon, text = v.name, value = v.id,
			children = {
				{
					text = 'Delete',
					value = '_delete_' .. v.id,
				},
				{
					text = 'Rename',
					value = '_rename_' .. v.id,
				},
				{
					text = 'Add Item Manually',
					value = '_addmanual_' .. v.id,
				},
			},});
	end
	self.gui.frames.list.tree = self.AceGUI:Create("TreeGroup")
	self.gui.frames.list.tree:SetCallback('OnGroupSelected', function(widget,event,value,d,e)
		local s1, s2, s3 = strsplit('_', value);
		if s2 == 'delete' then
			StaticPopupDialogs["kAuctionPopup_PromptWishlistDelete"] = {
				text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r|nDo you really wish to delete the |cFF"..kAuction:RGBToHex(0,255,0).. kAuction:Wishlist_GetNameById(tonumber(s3)) .."|r wishlist?",
				OnAccept = function()
					kAuction:Wishlist_RemoveList(tonumber(s3));
					kAuction:WishlistGui_RefreshMainFrame();					
				end,
				button1 = "Delete",
				button2 = "Cancel",
				OnCancel = function()
					return;
				end,
				timeout = 0,
				whileDead = 1,
				hideOnEscape = 1,
				hasEditBox = false,
				showAlert = true,
			};	
			StaticPopup_Show("kAuctionPopup_PromptWishlistDelete");
		elseif s2 == 'rename' then
			StaticPopupDialogs["kAuctionPopup_PromptWishlistRename"] = {
				text = "Enter the new name for the |cFF"..kAuction:RGBToHex(0,255,0).. kAuction:Wishlist_GetNameById(tonumber(s3)) .."|r wishlist below.",
				OnAccept = function(self,data)
					kAuction:Wishlist_SetListFlag(tonumber(s3), 'name',  self.editBox:GetText());
					kAuction:WishlistGui_RefreshMainFrame();
				end,
				button1 = "Done",
				button2 = "Cancel",
				OnCancel = function()
					return;
				end,
				OnShow = function(self,data)
					self.editBox:SetText(kAuction:Wishlist_GetNameById(tonumber(s3)))
				end,
				timeout = 0,
				whileDead = 1,
				hideOnEscape = 1,
				hasEditBox = 1,
			};	
			StaticPopup_Show("kAuctionPopup_PromptWishlistRename");
		elseif s2 == 'addmanual' then
			StaticPopupDialogs["kAuctionPopup_PromptAddItemManually"] = {
				text = "To manually add an item not found in your local cache, you must have the item id and item name.|n"..
				"Enter the exact item id and item name (capitalization and punctuation required), seperated by a semicolon (;) or colon (:).|n|n"..
				"Example:|cFF"..kAuction:RGBToHex(0,255,0).. "12784;Arcanite Reaper|r",
				OnAccept = function(self)
					if self.editBox:GetText() then
						local sFirst, sSecond = strsplit(';', self.editBox:GetText());
						if sFirst and sSecond then
							if type(tonumber(strtrim(sFirst))) == 'number' and type(strtrim(sSecond)) == 'string' then
								kAuction:Wishlist_AddItem(tonumber(s3), strtrim(sSecond), strtrim(sFirst));
							elseif type(sSecond) == 'string' and type(tonumber(sSecond)) == 'number' then
								kAuction:Wishlist_AddItem(tonumber(s3), strtrim(sFirst), strtrim(sSecond));
							end
							kAuction:WishlistGui_RefreshMainFrame();
						else
							local sFirst, sSecond = strsplit(':', self.editBox:GetText());
							if sFirst and sSecond then
								if type(tonumber(strtrim(sFirst))) == 'number' and type(strtrim(sSecond)) == 'string' then
									kAuction:Wishlist_AddItem(tonumber(s3), strtrim(sSecond), strtrim(sFirst));
								elseif type(sSecond) == 'string' and type(tonumber(sSecond)) == 'number' then
									kAuction:Wishlist_AddItem(tonumber(s3), strtrim(sFirst), strtrim(sSecond));
								end
								kAuction:WishlistGui_RefreshMainFrame();
							end
						end
					end
				end,
				button1 = "Add Item",
				button2 = "Cancel",
				OnCancel = function()
					return;
				end,
				OnShow = function()
					
				end,
				timeout = 0,
				whileDead = 1,
				hideOnEscape = 1,
				hasEditBox = 1,
			};	
			StaticPopup_Show("kAuctionPopup_PromptAddItemManually");
		end
		if s3 then
			self.gui.frames.list.selectedWishlist = tonumber(s3);
			kAuction:WishlistGui_ShowList(self.gui.frames.list.tree, tonumber(s3));
		else
			self.gui.frames.list.selectedWishlist = value;
			kAuction:WishlistGui_ShowList(self.gui.frames.list.tree, value);
		end
	end);
	self.gui.frames.list.tree:SetLayout("Fill")
	self.gui.frames.list.tree:SetTree(tree)
	parent:AddChild(self.gui.frames.list.tree);	
end
















































































































































































































































































function kAuction:WishlistGui_TabWindow(content)
	content:ReleaseChildren()
	local tab = self.AceGUI:Create("TabGroup")
	tab.userdata.parent = content.userdata.parent
	tab:SetTabs({"A","B","C","D"},{A="Alpha",B="Bravo",C="Charlie",D="Deltaaaaaaaaaaaaaa"})
	tab:SetTitle("Tab Group")
	tab:SetLayout("Fill")
	tab:SetCallback("OnGroupSelected",SelectGroup)
	tab:SelectTab(1)
	content:AddChild(tab)
	
end
function kAuction:WishlistGui_GroupA(content)
	content:ReleaseChildren()
	
	local sf = self.AceGUI:Create("ScrollFrame")
	sf:SetLayout("Flow")
	
	local edit = self.AceGUI:Create("EditBox")
	edit:SetText("Testing")
	edit:SetWidth(200)
	edit:SetLabel("Group A Option")
	edit:SetCallback("OnEnterPressed",function(widget,event,text) widget:SetLabel(text) end )
	edit:SetCallback("OnTextChanged",function(widget,event,text) print(text) end )
	sf:AddChild(edit)
	
	local slider = self.AceGUI:Create("Slider")
	slider:SetLabel("Group A Slider")
	slider:SetSliderValues(0,1000,5)
	slider:SetDisabled(false)
	sf:AddChild(slider)
	
	local zomg = self.AceGUI:Create("Button")
	zomg.userdata.parent = content.userdata.parent
	zomg:SetText("Zomg!")
	zomg:SetCallback("OnClick", ZOMGConfig)
	sf:AddChild(zomg)
	
	local heading1 = self.AceGUI:Create("Heading")
	heading1:SetText("Heading 1")
	heading1.width = "fill"
	sf:AddChild(heading1)
	
	for i = 1, 5 do
		local radio = self.AceGUI:Create("CheckBox")
		radio:SetLabel("Test Check "..i)
		radio:SetCallback("OnValueChanged",function(widget,event,value) print(value and "Check "..i.." Checked" or "Check "..i.." Unchecked") end )
		sf:AddChild(radio)
	end
	
	local heading2 = self.AceGUI:Create("Heading")
	heading2:SetText("Heading 2")
	heading2.width = "fill"
	sf:AddChild(heading2)
	
	for i = 1, 5 do
		local radio = self.AceGUI:Create("CheckBox")
		radio:SetLabel("Test Check "..i+5)
		radio:SetCallback("OnValueChanged",function(widget,event,value) print(value and "Check "..i.." Checked" or "Check "..i.." Unchecked") end )
		sf:AddChild(radio)
	end
	
	local heading1 = self.AceGUI:Create("Heading")
	heading1:SetText("Heading 1")
	heading1.width = "fill"
	sf:AddChild(heading1)
	
    for i = 1, 5 do
	    local radio = self.AceGUI:Create("CheckBox")
	    radio:SetLabel("Test Check "..i)
	    radio:SetCallback("OnValueChanged",function(widget,event,value) print(value and "Check "..i.." Checked" or "Check "..i.." Unchecked") end )
	    sf:AddChild(radio)
	end
	
	local heading2 = self.AceGUI:Create("Heading")
	heading2:SetText("Heading 2")
	heading2.width = "fill"
	sf:AddChild(heading2)
	
    for i = 1, 5 do
	    local radio = self.AceGUI:Create("CheckBox")
	    radio:SetLabel("Test Check "..i+5)
	    radio:SetCallback("OnValueChanged",function(widget,event,value) print(value and "Check "..i.." Checked" or "Check "..i.." Unchecked") end )
	    sf:AddChild(radio)
	end
    
	content:AddChild(sf)
end

function kAuction:WishlistGui_GroupB(content)
	content:ReleaseChildren()
	local sf = self.AceGUI:Create("ScrollFrame")
	sf:SetLayout("Flow")
	
 	local check = self.AceGUI:Create("CheckBox")
	check:SetLabel("Group B Checkbox")
	check:SetCallback("OnValueChanged",function(widget,event,value) print(value and "Checked" or "Unchecked") end )
	
	local dropdown = self.AceGUI:Create("Dropdown")
	dropdown:SetText("Test")
	dropdown:SetLabel("Group B Dropdown")
	list = {"Test","Test2"};
	--dropdown:SetGroupList(list);
	dropdown:SetCallback("OnValueChanged",function(widget,event,value) print(value) end )
	
	sf:AddChild(check)
	sf:AddChild(dropdown)
	content:AddChild(sf)
end

function kAuction:WishlistGui_OtherGroup(content)
	content:ReleaseChildren()
	
	local sf = self.AceGUI:Create("ScrollFrame")
	sf:SetLayout("Flow")
	
 	local check = self.AceGUI:Create("CheckBox")
	check:SetLabel("Test Check")
	check:SetCallback("OnValueChanged",function(widget,event,value) print(value and "CheckButton Checked" or "CheckButton Unchecked") end )
	
	sf:AddChild(check)
	
	local inline = self.AceGUI:Create("InlineGroup")
	inline:SetLayout("Flow")
	inline:SetTitle("Inline Group")
	inline.width = "fill"

	local heading1 = self.AceGUI:Create("Heading")
	heading1:SetText("Heading 1")
	heading1.width = "fill"
	inline:AddChild(heading1)
	
	for i = 1, 10 do
		local radio = self.AceGUI:Create("CheckBox")
		radio:SetLabel("Test Radio "..i)
		radio:SetCallback("OnValueChanged",function(widget,event,value) print(value and "Radio "..i.." Checked" or "Radio "..i.." Unchecked") end )
		radio:SetType("radio")
		inline:AddChild(radio)
	end
	
	local heading2 = self.AceGUI:Create("Heading")
	heading2:SetText("Heading 2")
	heading2.width = "fill"
	inline:AddChild(heading2)
	
	for i = 1, 10 do
		local radio = self.AceGUI:Create("CheckBox")
		radio:SetLabel("Test Radio "..i)
		radio:SetCallback("OnValueChanged",function(widget,event,value) print(value and "Radio "..i.." Checked" or "Radio "..i.." Unchecked") end )
		radio:SetType("radio")
		inline:AddChild(radio)
	end
	
	
	sf:AddChild(inline)
	content:AddChild(sf)
end

-- function that draws the widgets for the first tab
function kAuction:WishlistGui_DrawGroup1(container)
  local desc = self.AceGUI:Create("Label")
  desc:SetText("This is Tab 1")
  desc:SetFullWidth(true)
  container:AddChild(desc)
  
  local button = self.AceGUI:Create("Button")
  button:SetText("Tab 1 Button")
  button:SetWidth(200)
  container:AddChild(button)
  
  local fInline = self.AceGUI:Create("InlineGroup")
	fInline:SetTitle("I'm Inline")
	fInline:SetLayout("Fill")
  
  local tree = { "A", "B", "C", "D", B = { "B1", "B2", B1 = { "B11", "B12" } }, C = { "C1", "C2", C1 = { "C11", "C12" } } }
	local text = { A = "Option 1", B = "Option 2", C = "Option 3", D = "Option 4", J = "Option 10", K = "Option 11", L = "Option 12", 
					B1 = "Option 2-1", B2 = "Option 2-2", B11 = "Option 2-1-1", B12 = "Option 2-1-2",
					C1 = "Option 3-1", C2 = "Option 3-2", C11 = "Option 3-1-1", C12 = "Option 3-1-2" }
	local t = self.AceGUI:Create("TreeGroup")
	t:SetLayout("Fill")
	t:SetTree(tree, text)
fInline:AddChild(t);
container:AddChild(fInline);
  
end

-- function that draws the widgets for the second tab
function kAuction:WishlistGui_DrawGroup2(container)
  local desc = self.AceGUI:Create("Label")
  desc:SetText("This is Tab 2")
  desc:SetFullWidth(true)
  container:AddChild(desc)
  
  local button = self.AceGUI:Create("Button")
  button:SetText("Tab 2 Button")
  button:SetWidth(200)
  container:AddChild(button)
end

-- Callback function for OnGroupSelected
function kAuction:WishlistGui_SelectGroup(container, event, group)
   container:ReleaseChildren()
   if group == "tab1" then
      kAuction:WishlistGui_DrawGroup1(container)
   elseif group == "tab2" then
      kAuction:WishlistGui_DrawGroup2(container)
   end
end