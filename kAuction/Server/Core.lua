-- Author      : Gabe
-- Create Date : 2/15/2009 6:53:35 PM
-- Purpose     : Functions only to be performed by Server user (Raid Leader) for validation purposes
function kAuction:Server_AddBidToAuction(sender, localAuctionData)
	if not kAuction:Client_IsServer() then
		return;
	end
	local auction = kAuction:Client_GetAuctionById(localAuctionData.id);
	if auction then -- Matchin Auction found on server
		local bid = kAuction:Client_GetBidOfAuctionFromName(auction, sender);
		if bid then -- Bid already exists, update
			bid.bestInSlot = localAuctionData.bestInSlot;
			bid.bidType = localAuctionData.bidType;
			bid.currentItemLink = localAuctionData.currentItemLink;
			bid.setBonus = localAuctionData.setBonus;
		else -- No bid exists for sender, create
			bid = {
				bestInSlot = localAuctionData.bestInSlot,
				bidType = localAuctionData.bidType,
				currentItemLink = localAuctionData.currentItemLink, 
				id = kAuction:Server_GetUniqueBidId(),
				lootCouncilVoters = {},
				name = sender, 
				roll = math.random(1,self.db.profile.looting.rollMaximum),
				setBonus = localAuctionData.setBonus,
			};
			tinsert(auction.bids, bid);
		end
		kAuction:SendCommunication("DataUpdate", kAuction:Serialize("auction", auction), 3)
	end
end
function kAuction:Server_AddBidVote(sender, auction, bid)
	if not kAuction:Client_IsServer() then
		return;
	end
	local iAuction, iBid = kAuction:Client_GetAuctionBidIndexByBidId(bid.id);
	if not iAuction or not iBid then return nil end
	if self.auctions[iAuction].bids[iBid] then
		if kAuction:IsLootCouncilMember(self.auctions[iAuction], sender) then
			kAuction:ClearLootCouncilVoteFromAuction(self.auctions[iAuction], sender);
			tinsert(self.auctions[iAuction].bids[iBid].lootCouncilVoters, sender);
		end
		kAuction:SendCommunication("DataUpdate", kAuction:Serialize("auction", self.auctions[iAuction]), 3)
	end
end
function kAuction:Server_AwardAuction(auction, winner)
	if not kAuction:Client_IsServer() then
		return;
	end
	if not auction.closed then
		return;
	end
	if winner then -- Assigned winner
		auction.winner = winner;
	end
	if auction.winner or auction.disenchant then
		-- Auto-assign via master loot
		local lootMethod, masterLooterId = GetLootMethod();
		local corpseGuid = UnitGUID("target") -- NPC Looted
		if not corpseGuid then -- Else Container Looted
			corpseGuid = self.guids.lastObjectOpened;
		end	
		-- Check if autoML enabled, player is raid leader, player is ML, player is looting a corpse/object of matching corpseGuid of auction, 
		-- and auction has not been looted (ensures duplicate named items don't get autoassigned)
		if self.db.profile.looting.autoAssignIfMasterLoot and IsRaidLeader() and (lootMethod=='master' and masterLooterId==0) and self.isLooting and corpseGuid == auction.corpseGuid and auction.looted == false then
			if #(auction.bids) == 0 then -- Disenchant
				auction.disenchant = true;
			end
			kAuction:Debug("Server_AwardAuction, Activate MasterLoot", 1);
			-- Assign to winner
			if auction.winner then
				local booAwarded = false;
				for ci = 1, GetNumRaidMembers() do
					if (GetMasterLootCandidate(ci) == auction.winner) then
						for li = 1, GetNumLootItems() do
							if (LootSlotIsItem(li)) then
								local itemLink = GetLootSlotLink(li);
								if itemLink == auction.itemLink then
									GiveMasterLoot(li, ci);
									booAwarded = true;		
									auction.awarded = true;		
									auction.looted = true;				
								end
							end
						end
					end
				end
				if booAwarded == false then
					kAuction:Print(ChatFrame1, "Master Loot Auto-Assignment failed for " .. auction.winner .. " for item " .. auction.itemLink ..".  Not in range or valid candidate.")
				end
			elseif auction.disenchant then
				local disenchanterUnit = kAuction:GetEnchanterInRaidRosterObject();
				if disenchanterUnit then -- DEer found in raid
					-- Assign to Disenchanter
					local booAwarded = false;
					for ci = 1, GetNumRaidMembers() do
						if (GetMasterLootCandidate(ci) == disenchanterUnit.name) then
							for li = 1, GetNumLootItems() do
								if (LootSlotIsItem(li)) then
									local itemLink = GetLootSlotLink(li);
									if itemLink == auction.itemLink then
										GiveMasterLoot(li, ci);		
										auction.awarded = true;		
										auction.looted = true;						
									end
								end
							end
						end
					end	
					if booAwarded == false then
						kAuction:Print(ChatFrame1, "Master Loot Auto-Assignment Disenchantment failed for " .. disenchanterUnit.name .. " for item " .. auction.itemLink ..".  Not in range or valid candidate.")
					end
				else	
					kAuction:Print(ChatFrame1, "Master Loot Auto-Assignment Disenchantment failed, no valid disenchanter found in raid.")
				end
			end
		end
		auction.awarded = true;
		auction.looted = true;
		kAuction:SendCommunication("DataUpdate", kAuction:Serialize("auction", auction), 3);
		if auction.winner then
			kAuction:Debug("auctionwinner: " .. auction.winner, 1);
			if self.db.profile.looting.auctionWhisperBidEnabled then
				SendChatMessage(self.const.chatPrefix.."Auto-Response: Congratulations, you are the auction winner for " .. auction.itemLink .. "!", "WHISPER", nil, auction.winner);
			end
			kAuction:SendCommunication("AuctionWinner", auction);
		end
	end
end
function kAuction:Server_WhisperAuctionToRaidRoster(itemLink)
	local i, name, online
	if not self.db.profile.looting.auctionWhisperBidEnabled then return nil end
	for i = 1, GetNumRaidMembers() do
		name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
		if online then
			if not (name == (self.player)) then
				SendChatMessage(self.const.chatPrefix.."Auto-Generated: An auction has been created for "..itemLink ..".  To bid, /whisper "..self.playerName.." with the itemlink and appropriate keywords.  For keyword help, /whisper "..self.playerName.." ka help.", "WHISPER", nil, name);
			end
		end
	end
end
function kAuction:Server_AuctionItem(id, corpseGuid, corpseName)
	if not kAuction:Client_IsServer() or not self.isActiveRaid then
		kAuction:Debug("Not active raid.", 1);
		return;
	end
	kAuction:Debug(("Server_AuctionItem %s."):format(id), 1);
	local _, itemLink = GetItemInfo(id);
	-- Check if rarity requirements are met
	local _, _, rarity = GetItemInfo(itemLink);
	if not rarity then return end
	if rarity < self.db.profile.looting.rarityThreshold then
		return;
	end
	-- Is item in blacklist?
	local booItemInBlacklist = false
	local strItemName = GetItemInfo(itemLink)
	for i,val in pairs(self.db.profile.items.blackList) do
		if strItemName == val then
			booItemInBlacklist = true
		end
	end
	if booItemInBlacklist then
		kAuction:Debug("FUNC: Server_AuctionItem, Item in blacklist: " .. strItemName, 3)
		return; 
	end
	local currentItemLink = false;
	local whitelistData = kAuction:Item_GetItemWhitelistData(itemLink) or kAuction:Item_GetItemTypeWhitelistData(itemLink) or {};
	if whitelistData.id then
		kAuction:Debug("FUNC: Create auction, whitelist Data found, id: " .. whitelistData.id, 1);
	end
	--[[
	if IsEquippableItem(itemLink) or whitelistData.currentItemSlot then
		if self.db.profile.bidding.autoPopulateCurrentItem then
			local slotItemLink = GetInventoryItemLink("player", whitelistData.currentItemSlot or kAuction:Item_GetEquipSlotNumberOfItem(itemLink));
			if slotItemLink then
				currentItemLink = slotItemLink;
				kAuction:Debug("FUNC: Create auction, slotItemLink: " .. slotItemLink, 1);
			end
		end
	end
	]]
	local id = kAuction:Server_GetUniqueAuctionId();
	local councilMembers = {};
	for iCouncil,vCouncil in pairs(self.db.profile.looting.councilMembers) do
		if kAuction:Client_IsPlayerInRaid(vCouncil) then
			tinsert(councilMembers, vCouncil);
		end
	end
	tinsert(self.auctions, {
		auctionType = whitelistData.auctionType or self.db.profile.looting.auctionType,
		auctionCloseDelay = self.db.profile.looting.auctionCloseDelay,
		auctionCloseVoteDuration = self.db.profile.looting.auctionCloseVoteDuration,
		awarded = false,
		bids = {},
		closed = false, 
		councilMembers = councilMembers,
		corpseGuid = corpseGuid,
		corpseName = corpseName,
		currentItemSlot = whitelistData.currentItemSlot or kAuction:Item_GetEquipSlotNumberOfItem(itemLink),
		dateTime = date("%m/%d/%y %H:%M:%S"),
		duration = self.db.profile.looting.auctionDuration, 
		id = id, 
		itemLink = itemLink, 
		looted = false,
		seedTime = time(), 
		visiblePublicBidCurrentItems = self.db.profile.looting.visiblePublicBidCurrentItems,
		visiblePublicBidRolls = self.db.profile.looting.visiblePublicBidRolls,
		visiblePublicBidVoters = self.db.profile.looting.visiblePublicBidVoters,
		visiblePublicDetails = self.db.profile.looting.visiblePublicDetails,
		winner = false});
	tinsert(self.localAuctionData, {
		bestInSlot = false,
		bid = false, 
		bidType = false, 
		currentItemLink = currentItemLink, 
		id = id,
		itemLink = itemLink,
		localStartTime = time(), 
		setBonus = false,
	});		
	-- Send out auction Whisper Bid messages
	if self.db.profile.looting.auctionWhisperBidEnabled then
		kAuction:Server_WhisperAuctionToRaidRoster(itemLink);
	end
	if #(self.auctions) > 0 and self.db.profile.looting.displayFirstOpenAuction == true then
		FauxScrollFrame_SetOffset(kAuctionMainFrameMainScrollContainerScrollFrame, kAuction:GetFirstOpenAuctionIndex()-1);
	end
	-- Visible main frame
	self.db.profile.gui.frames.main.visible = true;
	self.db.profile.gui.frames.bids.visible = true;
	kAuction:Gui_HookFrameRefreshUpdate();
	-- SendComm
	kAuction:SendCommunication("Auction", self.auctions[#(self.auctions)])
	kAuction:CreateTimer("Client_OnAuctionExpire", self.auctions[#(self.auctions)].duration + 1, false, {nil, self.auctions[#(self.auctions)]})
	kAuction:CreateTimer("Server_OnAuctionExpire", self.auctions[#(self.auctions)].duration + self.db.profile.looting.auctionCloseDelay, false, {nil, #(self.auctions)})
	kAuction:CreateTimer("Gui_HookFrameRefreshUpdate", self.db.profile.looting.auctionDuration + self.db.profile.looting.auctionCloseVoteDuration + self.db.profile.looting.auctionCloseDelay)
	kAuction:Debug("FUNC: Server_AuctionItem: Item: " .. itemLink .. ", corpse: " .. corpseGuid, 1);
	-- Check if wishlist requires auto-bid
	if kAuction:Wishlist_IsEnabled() then
		local oMatches = kAuction:Wishlist_GetWishlistItemMatches(kAuction:Item_GetItemIdFromItemLink(itemLink));
		if oMatches then
			-- Check for priority item
			local wishlistItem = kAuction:Wishlist_GetHighestPriorityItemFromSet(oMatches);
			if wishlistItem then
				if wishlistItem.autoBid == true then
					kAuction:Gui_OnClickAuctionBidButton(self.auctions[#self.auctions], wishlistItem.bidType, wishlistItem.bestInSlot, wishlistItem.setBonus);				
					-- Auto bid, check if alert
					if wishlistItem.alert == true then
						local sBidType;
						local sBestInSlot;
						local sSetBonus;
						if wishlistItem.bestInSlot then
							sBestInSlot = "|cFF"..kAuction:RGBToHex(0,255,0) .. "Yes|r";
						else
							sBestInSlot = "|cFF"..kAuction:RGBToHex(200,00,0) .. "No|r";
						end
						if wishlistItem.setBonus then
							sSetBonus = "|cFF"..kAuction:RGBToHex(0,255,0) .. "Yes|r";
						else
							sSetBonus = "|cFF"..kAuction:RGBToHex(200,00,0) .. "No|r";
						end
						if wishlistItem.bidType == 'normal' then
							sBidType = "|cFF"..kAuction:RGBToHex(0,255,0)..strupper(strsub(wishlistItem.bidType, 1, 1)) .. strsub(wishlistItem.bidType, 2).."|r";
						elseif wishlistItem.bidType == 'offspec' then
							sBidType = "|cFF"..kAuction:RGBToHex(255,255,0)..strupper(strsub(wishlistItem.bidType, 1, 1)) .. strsub(wishlistItem.bidType, 2).."|r";
						elseif wishlistItem.bidType == 'rot' then
							sBidType = "|cFF"..kAuction:RGBToHex(210,0,0)..strupper(strsub(wishlistItem.bidType, 1, 1)) .. strsub(wishlistItem.bidType, 2).."|r";
						end
						StaticPopupDialogs["kAuctionPopup_PromptAutoBid_"..wishlistItem.wishlistId] = {
							text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r|n|n"..
							"An automatic " .. sBidType .. " bid has been entered for the recently created auction of ".. itemLink .. " due to your wishlist of this item with the following settings:|n|n" ..
							"Wishlist: |cFF"..kAuction:RGBToHex(255,150,0) .. kAuction:Wishlist_GetNameById(wishlistItem.wishlistId) .. "|r|n" ..
							"Bid Type: " .. sBidType .. "|n" ..
							"Best in Slot: " .. sBestInSlot .. "|n" ..
							"Set Bonus: " .. sSetBonus .. "|n|n",
							"Would you like to keep or cancel your bid?",
							OnAccept = function()
								return;
							end,
							button1 = "Keep Bid",
							button2 = "Cancel Bid",
							OnCancel = function()
								kAuction:Gui_OnClickAuctionBidButton(self.auctions[#self.auctions], 'none');				
							end,
							timeout = self.auctions[#(self.auctions)].duration,
							whileDead = 1,
							hideOnEscape = 1,
							hasEditBox = false,
							showAlert = true,
						};	
						StaticPopup_Show("kAuctionPopup_PromptAutoBid_"..wishlistItem.wishlistId);
					end
				elseif wishlistItem.alert == true then
					local sBidType;
					local sBestInSlot;
					local sSetBonus;
					if wishlistItem.bestInSlot then
						sBestInSlot = "|cFF"..kAuction:RGBToHex(0,255,0) .. "Yes|r";
					else
						sBestInSlot = "|cFF"..kAuction:RGBToHex(200,00,0) .. "No|r";
					end
					if wishlistItem.setBonus then
						sSetBonus = "|cFF"..kAuction:RGBToHex(0,255,0) .. "Yes|r";
					else
						sSetBonus = "|cFF"..kAuction:RGBToHex(200,00,0) .. "No|r";
					end
					if wishlistItem.bidType == 'normal' then
						sBidType = "|cFF"..kAuction:RGBToHex(0,255,0)..strupper(strsub(wishlistItem.bidType, 1, 1)) .. strsub(wishlistItem.bidType, 2).."|r";
					elseif wishlistItem.bidType == 'offspec' then
						sBidType = "|cFF"..kAuction:RGBToHex(255,255,0)..strupper(strsub(wishlistItem.bidType, 1, 1)) .. strsub(wishlistItem.bidType, 2).."|r";
					elseif wishlistItem.bidType == 'rot' then
						sBidType = "|cFF"..kAuction:RGBToHex(210,0,0)..strupper(strsub(wishlistItem.bidType, 1, 1)) .. strsub(wishlistItem.bidType, 2).."|r";
					end
					StaticPopupDialogs["kAuctionPopup_PromptAutoBid_"..wishlistItem.wishlistId] = {
						text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r|n|n"..
						"An auction has been detected for the following item found in your wishlists:|n" ..
						itemLink ..
						"|n|nWould you like to enter a bid based on your wishlist settings as seen below?|n|n" ..
						"Wishlist: |cFF"..kAuction:RGBToHex(255,150,0) .. kAuction:Wishlist_GetNameById(wishlistItem.wishlistId) .. "|r|n" ..
						"Bid Type: " .. sBidType .. "|n" ..
						"Best in Slot: " .. sBestInSlot .. "|n" ..
						"Set Bonus: " .. sSetBonus .. "|n",
						OnAccept = function()
							kAuction:Gui_OnClickAuctionBidButton(self.auctions[#self.auctions], wishlistItem.bidType, wishlistItem.bestInSlot, wishlistItem.setBonus);
						end,
						button1 = "Bid",
						button2 = "No Thanks",
						OnCancel = function()
							return;
						end,
						timeout = self.auctions[#(self.auctions)].duration,
						whileDead = 1,
						hideOnEscape = 1,
						hasEditBox = false,
						showAlert = true,
					};	
					StaticPopup_Show("kAuctionPopup_PromptAutoBid_"..wishlistItem.wishlistId);
				end
			end
		end
	end
end
function kAuction:Server_GetRandomItemId()
	local id;
	local itemLink;	
	local itemId = nil;
	local iCounter = 0;
	local COUNTER_MAX = 5000;
	while itemId == nil do
		matchFound = false;
		local iSlot = random(1,19);
		itemId = kAuction:Item_GetItemIdFromItemLink(GetInventoryItemLink("player",iSlot));
		iCounter = iCounter + 1;
		if iCounter >= COUNTER_MAX then
			return nil;
		end
	end
	return itemId;
end
function kAuction:Server_CreateTestAuction()
	if not kAuction:Client_IsServer() then
		return;
	end
	-- Create test auction
	kAuction:Server_AuctionItem(kAuction:Server_GetRandomItemId(), kAuction:Server_GetUniqueAuctionId(), "test corpse");
end
function kAuction:Server_IsPreviousRaidClosed() -- Not finished
	if not kAuction:Client_IsServer() then
		return;
	end
	local sXml = kAuction:Server_GetRaidXmlString();
	if self.raidStartTime and self.currentZone then
		local booFound = false;
		if #(self.raidDb.global.raids) > 0 then
			if not self.raidDb.global.raids[#self.raidDb.global.raids].endTime then
				-- Previous raid has no closure date, prompt to continue
				
			end
		end
		for i,raid in pairs(self.raidDb.global.raids) do
			-- Check for existing entry matching this zone without end datetime
			if raid.startTime == self.raidStartTime then
				-- Update existing entry
				self.raidDb.global.raids[i].xml = sXml;
				booFound = true;
			end
		end
		if booFound == false then
			tinsert(self.raidDb.global.raids, {startTime = self.raidStartTime, xml = sXml});
		end
	end
end
function kAuction:Server_GetLootCouncilMemberCount()
	local iCount = 0;
	local i, member, name, rank
	local booRaidLeaderInList = false;
	for i,member in pairs(self.db.profile.looting.councilMembers) do
		for iR = 1, GetNumRaidMembers() do
			name, rank = GetRaidRosterInfo(iR)
		end
		if member == name then
			iCount = iCount + 1;
			if rank == 2 then
				booRaidLeaderInList = true;
			end
		end
	end
	if booRaidLeaderInList == false then
		iCount = iCount + 1;
	end
	if iCount > 0 then
		return iCount;
	else
		return nil;
	end
end
function kAuction:Server_GetAuctionByItem(item,checkWinner)
	if not kAuction:Client_IsServer() then
		return;
	end
	local itemLink = item;
	if type(tonumber(item)) == "number" then -- ItemId
		if GetItemInfo(tonumber(item)) then
			itemLink = kAuction:Item_GetItemLinkFromItemId(item);
		end
	end
	local rAuction = nil;
	for i,auction in pairs(self.auctions) do
		kAuction:Debug("FUNC: Server_GetAuctionIdByItem, Auction Link: " .. auction.itemLink .. ", searchlink: " .. itemLink, 3);		
		if tonumber(kAuction:Item_GetItemIdFromItemLink(auction.itemLink)) == tonumber(kAuction:Item_GetItemIdFromItemLink(itemLink)) then
			if checkWinner then
				if not auction.winner then
					kAuction:Debug("FUNC: Server_GetAuctionIdByItem, Auction Id Found: " .. auction.id, 3);
					rAuction = auction;
				end
			else
				kAuction:Debug("FUNC: Server_GetAuctionIdByItem, Auction Id Found: " .. auction.id, 3);
				rAuction = auction;
			end
		end
	end	
	return rAuction;
end
function kAuction:Server_GetRaidRoster()
	if not kAuction:Client_IsServer() then
		return;
	end
	local roster = {};
	local i, name, class, online
	for i = 1, GetNumRaidMembers() do
		name, _, _, _, class, _, _, online = GetRaidRosterInfo(i)
		if online then
			tinsert(roster, {name = name, class = class});
		end
	end
	return roster;
end
function kAuction:Server_GetUniqueAuctionId()
	local newId
	local isValidId = false;
	while isValidId == false do
		matchFound = false;
		newId = (math.random(0,2147483647) * -1);
		for i,val in pairs(self.auctions) do
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
function kAuction:Server_GetUniqueBidId()
	local newId
	local isValidId = false;
	while isValidId == false do
		matchFound = false;
		newId = (math.random(0,2147483647) * -1);
		for iAuction,vAuction in pairs(self.auctions) do
			for iBid,vBid in pairs(vAuction.bids) do
				if vBid.id == newId then
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
function kAuction:Server_HasCorpseBeenAuctioned(guid)
	local booWasAuctioned = false;
	for i,val in pairs(self.guids.wasAuctioned) do
		if val == guid then
			booWasAuctioned = true;
		end
	end
	if booWasAuctioned then
		kAuction:Debug("FUNC: Server_HasCorpseBeenAuctioned, TRUE", 3)		
	else
		kAuction:Debug("FUNC: Server_HasCorpseBeenAuctioned, FALSE", 3)			
	end
	return booWasAuctioned;
end
function kAuction:Server_InitializeCouncilMemberList()
	local booPlayerFound = false;
	local tempCouncilMembers = {};
	for iCouncil,vCouncil in pairs(self.db.profile.looting.councilMembers) do
		local matchFound = false;
		for iTemp,vTemp in pairs(tempCouncilMembers) do
			if vTemp == vCouncil then
				matchFound = true;
			end
		end
		if matchFound == false then
			tinsert(tempCouncilMembers, vCouncil);
		end
		if vCouncil == self.playerName then
			booPlayerFound = true;
		end
	end
	self.db.profile.looting.councilMembers = tempCouncilMembers;
	if booPlayerFound == false then
		local playerName = self.playerName;
		tinsert(self.db.profile.looting.councilMembers, playerName);
	end
	table.sort(self.db.profile.looting.councilMembers);
end
-- Fires when auction timer ends, 
function kAuction:Server_OnAuctionExpire(iAuction)
	if not kAuction:Client_IsServer() then
		return;
	end
	if kAuction.auctions[iAuction] then
		kAuction:CreateTimer("Gui_HookFrameRefreshUpdate", 0.5)
		kAuction.auctions[iAuction].closed = true;
		-- No bids, auto DE
		if #kAuction.auctions[iAuction].bids == 0 then
			kAuction:Debug("Server_OnAuctionExpire NO BIDS SET DE", 1)
			kAuction.auctions[iAuction].disenchant = true;
			kAuction:Server_AwardAuction(kAuction.auctions[iAuction]);
		elseif #kAuction.auctions[iAuction].bids == 1 then
			for i,v in pairs(kAuction.auctions[iAuction].bids) do
				kAuction:Server_AwardAuction(kAuction.auctions[iAuction], v.name);				
			end
		elseif kAuction.db.profile.looting.autoAwardRandomAuctions then
			kAuction:CreateTimer("DetermineRandomAuctionWinner", kAuction.db.profile.looting.auctionCloseDelay, false, {nil, iAuction})
			kAuction:CreateTimer("Server_AwardAuction",kAuction.db.profile.looting.auctionCloseDelay + 1, false, {nil, kAuction.auctions[iAuction]})
		end
	end
end
function kAuction:Server_RaidHasServerReceived(sender)
	if not kAuction:Client_IsServer() then
		return;
	end
	kAuction:Debug("FUNC: Server_RaidHasServerReceived, request sender = "..sender..", SendComm(RaidServer).", 1);
	kAuction:SendCommunication("RaidServer", nil);
end
function kAuction:Server_RemoveBidFromAuction(sender, auction)
	if not kAuction:Client_IsServer() then
		return;
	end
	local iAuction = kAuction:Client_GetAuctionIndexByAuctionId(auction.id);
	if self.auctions[iAuction] then
		for i,bid in pairs(self.auctions[iAuction].bids) do
			if bid.name == sender then
				kAuction:Debug("FUNC: Server_RemoveBidFromAuction, REMOVING BID: " .. sender, 1);
				tremove(self.auctions[iAuction].bids, i);
				kAuction:SendCommunication("DataUpdate", kAuction:Serialize("auction", self.auctions[iAuction]), 3)
			end
		end
	end
end
function kAuction:Server_RemoveBidVote(sender, auction, bid)
	if not kAuction:Client_IsServer() then
		return;
	end
	local localBid = kAuction:Client_GetBidById(bid.id);
	local localAuction = kAuction:Client_GetAuctionById(auction.id);
	if localBid then -- Matching Auction found on server
		if kAuction:IsLootCouncilMember(localAuction, sender) then
			kAuction:ClearLootCouncilVoteFromAuction(localAuction, sender);
		end
		kAuction:SendCommunication("DataUpdate", kAuction:Serialize("auction", localAuction), 3)
	end
end
function kAuction:Server_SetCorpseAsAuctioned(guid)
	if kAuction:Server_HasCorpseBeenAuctioned(guid) == false then
		tinsert(self.guids.wasAuctioned, guid);
		return true;		
	end
	return nil;
end
function kAuction:Server_ConfirmStartRaidTracking()
	if not kAuction:Client_IsServer() then
		kAuction:Print("Not registered as Server, cannot start raid tracking.");
		return;
	end
	StaticPopup_Show("kAuctionPopup_StartRaidTracking");							
end
function kAuction:Server_ConfirmStopRaidTracking()
	if not kAuction:Client_IsServer() then
		kAuction:Print("Not registered as Server, cannot stop raid tracking.");
		return;
	end
	StaticPopup_Show("kAuctionPopup_StopRaidTracking");							
end
function kAuction:Server_IsInValidRaidZone()
	if not kAuction:Client_IsServer() then
		return;
	end
	self.currentZone = GetRealZoneText();
	for iZone,vZone in pairs(self.db.profile.zones.validZones) do
		if self.currentZone == vZone then
			return true;
		end
	end
	return false;
end
function kAuction:Server_RequestRaidAuraCancel(id)
	if not kAuction:Client_IsServer() then
		return;
	end
	if not type(id) == "number" then return end
	if not GetSpellInfo(tonumber(id)) then return end
	-- Valid, send request
	kAuction:SendCommunication("RequestAuraCancel", tonumber(id));
end
kAuction.channel = "GUILD"
function kAuction:Server_StartVcpAttendanceCheck()
	if not kAuction:Client_IsServer() then
		return;
	end
	if not kAuction.enabled then
		return;
	end
	-- Create attendance table from vcp members
	table.sort(kAuction.db.profile.vcp.raiders, function(a,b) return a<b end)
	for i,raider in pairs(kAuction.db.profile.vcp.raiders) do
		tinsert(kAuction.vcp.attendance, {name=raider, online = false, iterationFound = 1});
	end
	-- Create initial attendance check timer for 5 minutes and announce
	kAuction:CreateTimer("Server_VcpAttendanceCheck", 300, false, {nil, 1});
	-- Announcement
	SendChatMessage("[VCP] - Initial availability snapshot in 5 minutes.  All VCP Raiders should remain online to receive 100% attendance credit.", kAuction.channel)
end
function kAuction:Server_VcpAttendanceCheck(iter)
	-- Count number online
	local iCountOnlineBefore = 0;
	local iCountOnlineAfter = 0;
	for iR,vR in pairs(kAuction.vcp.attendance) do
		if vR.online == true then
			iCountOnlineBefore = iCountOnlineBefore + 1;
		end
	end
	-- Query roster
	GuildRoster();
	local _, iCount = GetNumGuildMembers();
	local strUnaccounted;
	for i = 1, iCount do
		local name,_, _, _, _, _, note, _, online = GetGuildRosterInfo(i);
		-- Check for match
		for iRaider,vRaider in pairs(kAuction.vcp.attendance) do
			local f1, f2 = string.find(strlower(name), '%s*'..strlower(vRaider.name)..'%s*'), string.find(strlower(note), '%s*[[({][Aa][])}]%s*'..strlower(vRaider.name)..'%s*');
			if f1 or f2 then
				if online and vRaider.online == false then
					-- Match and online
					kAuction.vcp.attendance[iRaider].online = true;
					kAuction.vcp.attendance[iRaider].iterationFound = iter;
				end
			end
		end
	end
	for iRa,vRa in pairs(kAuction.vcp.attendance) do
		if vRa.online == true then
			iCountOnlineAfter = iCountOnlineAfter + 1;
		else
			if strUnaccounted then
				strUnaccounted = strUnaccounted .. ", " .. vRa.name;
			else
				strUnaccounted = vRa.name;
			end
		end
	end
	-- Announcement
	if iCountOnlineAfter == 11 then -- Don't run again
		if iter == 1 then
			SendChatMessage("[VCP] - Initial availability snapshot complete and all VCP Raiders are accounted for.", kAuction.channel)
		elseif iter == 2 then
			SendChatMessage("[VCP] - 20 minute availability snapshot complete and all VCP Raiders are accounted for.", kAuction.channel)
		elseif iter == 3 then
			SendChatMessage("[VCP] - 40 minute availability snapshot complete and all VCP Raiders are accounted for.", kAuction.channel)
		elseif iter == 4 then
			SendChatMessage("[VCP] - Final availability snapshot complete and all VCP Raiders are accounted for.", kAuction.channel)
		end
	else -- Run again in another iteration
		local strRaider = " Raiders"
		if 11-iCountOnlineAfter == 1 then strRaider = " Raider" end
		if iter == 1 then
			kAuction:CreateTimer("Server_VcpAttendanceCheck", 1200, false, {nil, iter+1});
			SendChatMessage("[VCP] - Initial availability snapshot complete, "..11-iCountOnlineAfter..strRaider.." unaccounted for: "..strUnaccounted..".  Next snapshot in 20 minutes.", kAuction.channel)
		elseif iter == 2 then
			kAuction:CreateTimer("Server_VcpAttendanceCheck", 1200, false, {nil, iter+1});
			SendChatMessage("[VCP] - 20 minute availability snapshot complete, "..11-iCountOnlineAfter..strRaider.." unaccounted for: "..strUnaccounted..".  Next snapshot in 20 minutes.", kAuction.channel)
		elseif iter == 3 then
			kAuction:CreateTimer("Server_VcpAttendanceCheck", 1200, false, {nil, iter+1});
			SendChatMessage("[VCP] - 40 minute availability snapshot complete, "..11-iCountOnlineAfter..strRaider.." unaccounted for: "..strUnaccounted..".  Final snapshot in 20 minutes.", kAuction.channel)
		elseif iter == 4 then
			SendChatMessage("[VCP] - Final availability snapshot complete, "..11-iCountOnlineAfter..strRaider.." unaccounted for: "..strUnaccounted..".", kAuction.channel)
		end
	end
end
function kAuction:Server_StartRaidTracking()
	if not kAuction:Client_IsServer() then
		return;
	end
	self.enabled = true;
	self.isActiveRaid = true;
	self.actors = {};
	self.raidStartTime = date("%m/%d/%y %H:%M:%S");
	self.raidStartTick = time();
	self.raidZone = GetRealZoneText();
	kAuction:CreateTimer(function()
		if kAuction.isActiveRaid then
			kAuction:Server_UpdateRaidRoster();
		else
			return true;
		end
	end, self.const.raid.presenceTick, true)
	-- Create raid entry
	kAuction:Debug("FUNC: Server_StartRaidtracking", 1);
end
function kAuction:Server_StopRaidTracking()
	if not kAuction:Client_IsServer() then
		return;
	end
	self.enabled = false;
	self.isActiveRaid = false;
	self.raidEndTime = date("%m/%d/%y %H:%M:%S");
	self.raidDuration = time() - self.raidStartTick;
	-- Final Xml DB Update
	kAuction:Server_UpdateRaidDb();
	-- Create raid xml
	StaticPopupDialogs["kAuctionPopup_GetRaidXmlString"] = {
		text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r|nCopy raid Xml export string below.",
		OnAccept = function()
			return
		end,
		button1 = "Done",
		button2 = "Cancel",
		OnCancel = function()
			return
		end,
		OnShow = function(self)
			self.editBox:SetText(kAuction:Server_GetRaidXmlString())
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
		hasEditBox = 1,
	};	
	StaticPopup_Show("kAuctionPopup_GetRaidXmlString");
	kAuction:CancelTimer(self.rosterUpdateTimer, true);
	self.actors = {};
	kAuction:SendCommunication("RaidEnd");
	kAuction:Debug("FUNC: Server_StopRaidtracking", 1);
end
function kAuction:Server_UpdateRaidDb()
	if not kAuction:Client_IsServer() then
		return;
	end
	-- Update raid Duration
	self.raidDuration = time() - self.raidStartTick;
	local sXml = kAuction:Server_GetRaidXmlString();
	if sXml and self.raidStartTime then
		local booFound = false;
		if self.raidDb.global.raids then
			for i,raid in pairs(self.raidDb.global.raids) do
				-- Check for existing entry
				if raid.startTime == self.raidStartTime then
					-- Update existing entry
					self.raidDb.global.raids[i].xml = sXml;
					booFound = true;
				end
			end
		end
		if booFound == false then
			local tInsert = {startTime = self.raidStartTime, xml = sXml};
			if self.raidEndTime then
				tInsert.endTime = self.raidEndTime;
			end
			if not self.raidDb.global.raids then
				self.raidDb.global.raids = {};
			end
			tinsert(self.raidDb.global.raids, tInsert);
		end
	end
end
function kAuction:Server_GetRaidXmlString()
	if not kAuction:Client_IsServer() then
		return;
	end
	local xFull = '<kAuction><raid>';
	local xStartDate = '<startDate>'..self.raidStartTime..'</startDate>';
	local xEndDate = '<endDate>';	
	if self.raidEndTime then
		xEndDate = xEndDate .. self.raidEndTime;
	end
	xEndDate = xEndDate .. '</endDate>';
	local xDuration = '<duration>'
	if self.raidDuration then
		xDuration = xDuration .. self.raidDuration;
	end
	xDuration = xDuration .. '</duration>';
	local xZone = '<zone>'..self.raidZone..'</zone>';
	local xItem = "";
	local xItems = "";
	local xBids = "";
	if #self.auctions > 0 then
		-- START <items>
		xItems = '<items>';
		for i,auction in pairs(self.auctions) do
			local found, _, itemString = string.find(auction.itemLink, '^|c%x+|H(.+)|h%[.*%]')
			local _,itemId = strsplit(':', itemString);
			local itemName = GetItemInfo(auction.itemLink);
			xItem = '<item>';
			if auction.corpseName then
				xItem = xItem .. '<corpseName>' .. auction.corpseName .. '</corpseName>';
			end
			xItem = xItem .. '<dateTime>' .. auction.dateTime .. '</dateTime>';
			if auction.disenchant then
				xItem = xItem .. '<disenchant>True</disenchant>';
			end
			if auction.auctionType then
				if auction.auctionType == 1 then
					xItem = xItem .. '<auctionType>random</auctionType>';					
				elseif auction.auctionType == 2 then
					xItem = xItem .. '<auctionType>council</auctionType>';					
				end
			end
			xItem = xItem .. '<itemId>' .. itemId .. '</itemId>';
			xItem = xItem .. '<name>' .. itemName .. '</name>';
			if auction.bids and #auction.bids > 0 then
				xBids = '<bids>';
				for iBid,vBid in pairs(auction.bids) do
					xBid = '<bid>';
					if vBid.bidType then 
						xBid = xBid .. '<bidType>' .. vBid.bidType .. '</bidType>';
					end
					if vBid.currentItemLink then
						local bFound, _, bItemString = string.find(vBid.currentItemLink, '^|c%x+|H(.+)|h%[.*%]');
						local _,bItemId = strsplit(':', bItemString);
						local bItemName = GetItemInfo(vBid.currentItemLink);					
						xBid = xBid .. '<currentItemId>' .. bItemId .. '</currentItemId>';
						if bItemName then
							xBid = xBid .. '<currentItemName>' .. bItemName .. '</currentItemName>';
						end
					end
					if vBid.id then 
						xBid = xBid .. '<id>' .. vBid.id .. '</id>';
					end
					if vBid.name then 
						xBid = xBid .. '<name>' .. vBid.name .. '</name>';
					end
					if vBid.roll then
						xBid = xBid .. '<roll>' .. vBid.roll .. '</roll>';
					end
					if vBid.lootCouncilVoters and #vBid.lootCouncilVoters  > 0 then
						local xBidVoters = '<voters>';						
						for iVoters,vName in pairs(vBid.lootCouncilVoters) do
							xBidVoters = xBidVoters .. '<name>' .. vName .. '</name>';			
						end
						xBidVoters = xBidVoters .. '</voters>';
						xBid = xBid .. xBidVoters;
					end
					-- Add <bid> to <bids>
					xBids = xBids .. xBid .. '</bid>';
				end
				-- Add <bids> to <item>
				xItem = xItem .. xBids .. '</bids>';				
			end
			if auction.winner then 
				xItem = xItem .. '<winner>' .. auction.winner .. '</winner>';
				local bidType = nil;
				for ibid,vBid in pairs(auction.bids) do
					if vBid.name == auction.winner then
						bidType = vBid.bidType;
					end
				end
				if bidType then
					xItem = xItem .. '<bidType>' .. bidType .. '</bidType>';	
				end
			end
			-- Loot council member list
			if auction.councilMembers and #auction.councilMembers  > 0 then
				local xCouncilMembers = '<councilMembers>';						
				for iCouncil,vName in pairs(auction.councilMembers) do
					xCouncilMembers = xCouncilMembers .. '<name>' .. vName .. '</name>';			
				end
				xCouncilMembers = xCouncilMembers .. '</councilMembers>';
				-- Add <councilMembers> to <item>
				xItem = xItem .. xCouncilMembers;
			end
			xItem = xItem .. '</item>';
			-- Add item to Items list
			xItems = xItems .. xItem;
		end
		xItems = xItems .. '</items>';
		-- END <items>
	end
	-- START <actors>
	local xActor, xActors;
	xActors = '<actors>';
	for name,actor in pairs(self.actors) do
		local presence = 1;
		if actor.presence + self.const.raid.presenceTick < self.raidDuration then
			presence = actor.presence / self.raidDuration;
		end
		xActor = '<actor>';
		xActor = xActor .. '<class>' .. actor.class .. '</class>';
		xActor = xActor .. '<name>' .. name .. '</name>';
		xActor = xActor .. '<presence>' .. presence .. '</presence>';
		xActor = xActor .. '</actor>';
		-- Add actor to Items list
		xActors = xActors .. xActor;
	end
	xActors = xActors .. '</actors>';
	-- END <actors>
	xFull = xFull .. xStartDate .. xEndDate .. xZone .. xDuration .. xActors .. xItems .. '</raid></kAuction>';
	return xFull;
end
function kAuction:Server_UpdateRaidRoster()
	local i, name, class, online
	for i = 1, GetNumRaidMembers() do
		name, _, _, _, class, _, _, online = GetRaidRosterInfo(i)
		if online then
			if self.actors[name] then
				self.actors[name].presence = self.actors[name].presence + self.const.raid.presenceTick;
			else -- new
				self.actors[name] = {class = class, presence = self.const.raid.presenceTick};
			end
		end
	end
end
function kAuction:Server_VersionCheck(outputResult)
	if not kAuction:Client_IsServer() then
		return;
	end
	for i=1,GetNumRaidMembers() do
		self.versions[GetRaidRosterInfo(i)] = false;
	end
	if outputResult then
		kAuction:CreateTimer("Server_VerifyVersions", 6, false, {nil, outputResult})
	else
		kAuction:CreateTimer("Server_VerifyVersions", 6)
	end
	kAuction:SendCommunication("VersionRequest", self.version)
end
function kAuction:Server_VersionReceived(sender, version)
	if not kAuction:Client_IsServer() then
		return;
	end
	self.versions[sender] = version;
	kAuction:Debug("FUNC: Server_VersionReceived sender: "..sender.. ", version: " .. version,1);
	kAuction:Server_VerifyVersions();
end
function kAuction:Server_CheckVersion(curr,old)
   local majorCurr, minorCurr, revCurr = strsplit('.', curr);
   local majorOld, minorOld, revOld = strsplit('.', old);
   if majorCurr > majorOld then
      return true
   elseif minorCurr > minorOld then
      return true
   elseif revCurr > revOld then
      return true
   end
   return false
end
function kAuction:Server_VerifyVersions(outputResult)
	if not kAuction:Client_IsServer() then
		return;
	end
	local booIncompatibleFound = false;
	
	for name,version in pairs(kAuction.versions) do
		if version == false then
			if outputResult then
				kAuction:Print("|cFF"..kAuction:RGBToHex(255,0,0).."No kAuction Install Found|r: " .. name);
			end
			booIncompatibleFound = true;
		elseif kAuction:Server_CheckVersion(kAuction.version, version) then
			booIncompatibleFound = true;
			if kAuction:Server_CheckVersion(kAuction.minRequiredVersion, version) then
				if outputResult then
					kAuction:Print("|cFF"..kAuction:RGBToHex(255,0,0).."Incompatible Version|r: " .. name .. " [" .. version .. "]");
				end
				kAuction:SendCommunication("VersionInvalid", kAuction:Serialize(name, kAuction.minRequiredVersion, kAuction.version));
			else
				if outputResult then
					kAuction:Print("|cFF"..kAuction:RGBToHex(255,255,0).."Out of Date Version|r: " .. name .. " [" .. version .. "]");
				end
			end
		end
	end
	if booIncompatibleFound == false then
		if outputResult then
			kAuction:Print("|cFF"..kAuction:RGBToHex(0,255,0).."All Users Compatible|r");
		end
	end
end