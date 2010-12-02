﻿-- Author      : Gabe
-- Create Date : 2/15/2009 6:53:22 PM
-- Purpose: New auction sent by Server, add to client auction list
function kAuction:Client_AuctionReceived(auction)
	if not kAuction:Client_DoesAuctionExist(auction.id) then
		local currentItemLink = false;
		if auction.currentItemSlot then
			if kAuction.db.profile.bidding.autoPopulateCurrentItem then
				local slotItemLink = GetInventoryItemLink("player", auction.currentItemSlot);
				if slotItemLink then
					currentItemLink = slotItemLink;
				end
			end
		end
		tinsert(kAuction.auctions, auction); -- Add to global auction list
		tinsert(kAuction.localAuctionData, { -- Update local Auction data
			bestInSlot = false,
			bid = false, 
			bidType = false,
			currentItemLink = currentItemLink, 
			id = auction.id,
			localStartTime = time(), 
			setBonus = false,
		});
		kAuction:Gui_HookFrameRefreshUpdate();
		kAuction:Gui_TriggerEffectsAuctionReceived();
		if kAuction.db.profile.bidding.auctionReceivedTextAlert == 2 then
			kAuction:Print("|cFF"..kAuction:RGBToHex(100,255,0).."New Auction Received|r -- Item "..auction.itemLink);
		end
		if #(kAuction.auctions) > 0 and kAuction.db.profile.looting.displayFirstOpenAuction == true then
			FauxScrollFrame_SetOffset(kAuctionMainFrameMainScrollContainerScrollFrame, kAuction:GetFirstOpenAuctionIndex()-1);
		end
		kAuction.db.profile.gui.frames.bids.visible = true;
		kAuction.db.profile.gui.frames.main.visible = true;
		kAuction:Gui_HookFrameRefreshUpdate();
		kAuction:ScheduleTimer("Gui_HookFrameRefreshUpdate", auction.duration + auction.auctionCloseVoteDuration + auction.auctionCloseDelay);
		-- Check if auto-remove auction is enabled and NOT server
		if kAuction:Client_IsServer() then
			return;
		else
			if kAuction.db.profile.gui.frames.main.autoRemoveAuctions then
				kAuction:Threading_CreateTimer("autoRemoveAuction_"..auction.id,function()
					kAuction:Gui_AuctionCloseButtonOnClick(auction);
					kAuction:Threading_StopTimer("autoRemoveAuction_"..auction.id);
				end, auction.duration + auction.auctionCloseVoteDuration + auction.auctionCloseDelay + kAuction.db.profile.gui.frames.main.autoRemoveAuctionsDelay,false);
				kAuction:Threading_StartTimer("autoRemoveAuction_"..auction.id);			
			end
		end	
		-- Check if wishlist requires auto-bid
		if kAuction:Wishlist_IsEnabled() then
			local oMatches = kAuction:Wishlist_GetWishlistItemMatches(kAuction:Item_GetItemIdFromItemLink(auction.itemLink));
			if oMatches then
				-- Check for priority item
				local wishlistItem = kAuction:Wishlist_GetHighestPriorityItemFromSet(oMatches);
				if wishlistItem then
					if wishlistItem.autoBid == true then
						kAuction:Gui_AuctionBidButtonOnClick(auction, wishlistItem.bidType, wishlistItem.bestInSlot, wishlistItem.setBonus);				
						-- Auto bid, check if alert
						if wishlistItem.alert == true then
							local sBidType;
							if wishlistItem.bidType == 'normal' then
								sBidType = "|cFF"..kAuction:RGBToHex(0,255,0)..strupper(strsub(wishlistItem.bidType, 1, 1)) .. strsub(wishlistItem.bidType, 2).."|r";
							elseif wishlistItem.bidType == 'offspec' then
								sBidType = "|cFF"..kAuction:RGBToHex(255,255,0)..strupper(strsub(wishlistItem.bidType, 1, 1)) .. strsub(wishlistItem.bidType, 2).."|r";
							elseif wishlistItem.bidType == 'rot' then
								sBidType = "|cFF"..kAuction:RGBToHex(210,0,0)..strupper(strsub(wishlistItem.bidType, 1, 1)) .. strsub(wishlistItem.bidType, 2).."|r";
							end
							StaticPopupDialogs["kAuctionPopup_PromptAutoBid_"..auction.id] = {
								text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r|n|n"..
								"An automatic " .. sBidType .. " bid has been entered for the recently created auction of ".. auction.itemLink .. " due to your wishlist of this item.|n|n" ..
								"Would you like to keep or cancel your bid?",
								OnAccept = function()
									return;
								end,
								button1 = "Keep Bid",
								button2 = "Cancel Bid",
								OnCancel = function(a,b,c,d)
									if c ~= 'timeout' then
										kAuction:Gui_AuctionBidButtonOnClick(auction, 'none');				
									end
								end,
								timeout = auction.duration,
								whileDead = 1,
								hideOnEscape = 1,
								hasEditBox = false,
								showAlert = true,
							};	
							StaticPopup_Show("kAuctionPopup_PromptAutoBid_"..auction.id);
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
						StaticPopupDialogs["kAuctionPopup_PromptAutoBid_"..auction.id] = {
							text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r|n|n"..
							"An auction has been detected for the following item found in your wishlists:|n" ..
							auction.itemLink ..
							"|n|nWould you like to enter a bid based on your wishlist settings as seen below?|n|n" ..
							"Bid Type: " .. sBidType .. "|n" ..
							"Best in Slot: " .. sBestInSlot .. "|n" ..
							"Set Bonus: " .. sSetBonus .. "|n",
							OnAccept = function()
								kAuction:Gui_AuctionBidButtonOnClick(auction, wishlistItem.bidType, wishlistItem.bestInSlot, wishlistItem.setBonus);
							end,
							button1 = "Bid",
							button2 = "No Thanks",
							OnCancel = function()
								return;
							end,
							timeout = auction.duration,
							whileDead = 1,
							hideOnEscape = 1,
							hasEditBox = false,
							showAlert = true,
						};	
						StaticPopup_Show("kAuctionPopup_PromptAutoBid_"..auction.id);
					end
				end
			end
		end
	end
end
function kAuction:Client_AuctionDeleteReceived(sender, auction)
	kAuction:Client_DeleteAuction(auction);
end
function kAuction:Client_AuraCancelReceived(sender, auraId)
	for i=1,40 do
		local id = select(11, UnitAura("player", i));
		-- Check if matching buff is detected
		if auraId == id then
			booMatch = true;
			kAuction:Debug("Client_AuraCancelReceived - Removing aura ["..GetSpellInfo(auraId).."], due to server request.", 3);
			CancelUnitBuff("player", i);
			break;
		end
	end
end
function kAuction:Client_AuraDisableReceived(sender, auras)
	local names = "";
	for i,auraId in pairs(auras) do
		names = names .. " - " .. select(1, GetSpellInfo(auraId));
		kAuction:Aura_Disable(auraId);
	end
	if names ~= "" then
		kAuction:Print("|cFF"..kAuction:RGBToHex(100,255,0).."Disabling Auras|r"..names);
	end
end
function kAuction:Client_AuraEnableReceived(sender, auras)
	local names = "";
	for i,auraId in pairs(auras) do
		names = names .. " - " .. select(1, GetSpellInfo(auraId));
		kAuction:Aura_Enable(auraId);
	end
	if names ~= "" then
		kAuction:Print("|cFF"..kAuction:RGBToHex(100,255,0).."Enabling Auras|r"..names);
	end
end
function kAuction:Client_AuctionWinnerReceived(sender, auction)
	if auction.winner and auction.winner == UnitName("player") then -- Auction winner is Player
		kAuction:Gui_TriggerEffectsAuctionWon();
		if kAuction.db.profile.bidding.auctionWonTextAlert == 2 then
			kAuction:Print("|cFF"..kAuction:RGBToHex(255,0,0).."Auction Won|r -- Item "..auction.itemLink);
		end
		if kAuction:Wishlist_IsEnabled() then
			local oMatches = kAuction:Wishlist_GetWishlistItemMatches(kAuction:Item_GetItemIdFromItemLink(auction.itemLink));
			if oMatches then
				-- Check for priority item
				local wishlistItem = kAuction:Wishlist_GetHighestPriorityItemFromSet(oMatches);
				if wishlistItem then
					-- Check if auto-remove
					if wishlistItem.autoRemove == true then
						kAuction:Wishlist_RemoveItem(wishlistItem.wishlistId, wishlistItem.id);
					end
				end
			end
		end
	elseif auction.winner then -- Winner is someone else
		kAuction:Gui_TriggerEffectsAuctionWinnerReceived();
		if kAuction.db.profile.bidding.auctionWinnerReceivedTextAlert == 2 then
			kAuction:Print("|cFF"..kAuction:RGBToHex(255,0,255).."Auction Winner Declared: |r|cFF"..kAuction:RGBToHex(255,255,0)..auction.winner.."|r -- Item "..auction.itemLink);
		end
	end
end
function kAuction:Client_BidCancelReceived(sender, auction)
	kAuction:Server_RemoveBidFromAuction(sender, auction);
end
function kAuction:Client_BidReceived(sender, localAuctionData)
	kAuction:Server_AddBidToAuction(sender, localAuctionData);
end
function kAuction:Client_BidVoteReceived(sender, data)
	local success, auction, bid = kAuction:Deserialize(data);
	kAuction:Debug("FUNC: Client_BidVoteReceived, auction.id: " .. auction.id .. ", bid.name: " .. bid.name, 1)
	kAuction:Server_AddBidVote(sender, auction, bid);
end
function kAuction:Client_BidVoteCancelReceived(sender, data)
	local success, auction, bid = kAuction:Deserialize(data);
	kAuction:Debug("FUNC: Client_BidVoteCancelReceived, auction.id: " .. auction.id .. ", bid.name: " .. bid.name, 1)
	kAuction:Server_RemoveBidVote(sender, auction, bid);
end
function kAuction:Client_DataUpdateReceived(sender, data)
	local success, type, auction = kAuction:Deserialize(data);
	if type == "auction" then
		index = kAuction:Client_GetAuctionIndexByAuctionId(auction.id);
		if kAuction.auctions[index] then
			kAuction.auctions[index] = auction; -- Update auction
		end
	end
end
function kAuction:Client_DeleteAuction(auction)
	if kAuction.auctions[kAuction:Client_GetAuctionIndexByAuctionId(auction.id)] then
		tremove(kAuction.auctions, kAuction:Client_GetAuctionIndexByAuctionId(auction.id));
	end
end
function kAuction:Client_DoesAuctionExist(id)
	for i,item in pairs(kAuction.auctions) do
		if item.id == id then
			kAuction:Debug("FUNC: Client_DoesAuctionExist, Id: " .. id, 3)
			-- Item exists already
			return true;
		end
	end	
	return false;
end
function kAuction:Client_DoesAuctionHaveBidFromName(auction, sender)
	for i,bid in pairs(auction.bids) do
		if bid.name == sender then
			return true;
		end
	end
	return false;
end
function kAuction:Client_GetAuctionIndexByAuctionId(id)
	for i,auction in pairs(kAuction.auctions) do
		if auction.id == id then
			-- Item exists already
			return i;
		end
	end	
	return nil;
end
function kAuction:Client_GetAuctionBidIndexByBidId(id)
	for iAuction,vAuction in pairs(kAuction.auctions) do
		for iBid,vBid in pairs(vAuction.bids) do
			if vBid.id == id then
				return iAuction, iBid;
			end
		end	
	end
	return nil;
end
function kAuction:Client_GetAuctionById(id)
	for i,auction in pairs(kAuction.auctions) do
		if auction.id == id then
			kAuction:Debug("FUNC: Client_DoesAuctionExist, Id: " .. id, 3)
			-- Item exists already
			return auction;
		end
	end	
	return nil;
end
function kAuction:Client_GetBidById(id)
	for iAuction,vAuction in pairs(kAuction.auctions) do
		for iBid,vBid in pairs(vAuction.bids) do
			if vBid.id == id then
				return vBid;
			end
		end	
	end
	return nil;
end
function kAuction:Client_GetBidOfAuctionFromName(auction, sender)
	for i,bid in pairs(auction.bids) do
		if bid.name == sender then
			return bid;
		end
	end
	return nil;
end
function kAuction:Client_GetLocalAuctionDataById(id)
	for i,auction in pairs(kAuction.localAuctionData) do
		if auction.id == id then
			return auction;
		end
	end
	return nil;
end
function kAuction:Client_IsServer()
	-- If debug, ignore requirements
	if kAuction.db.profile.debug.enabled then
		return true;
	end
	-- Verify raid leader
	if GetNumRaidMembers() > 0 and IsRaidLeader() then -- Current Server
		kAuction.isServer = true;
		return true;
	elseif GetNumRaidMembers() == 0 and kAuction.isServer then -- Previous Server
		return true;
	end
	return false;
end
function kAuction:Client_RaidServerReceived(sender)
	kAuction.server = sender;
	kAuction.enabled = true;
	-- Run version check
	if not kAuction.hasRunVersionCheck and not kAuction:Client_IsServer() then
		kAuction:SendCommunication("Version", kAuction.version);
		kAuction:Debug("FUNC: Client_RaidServerReceived, server = "..kAuction.server..", enabled = true, running version check.", 1);
	end
end
function kAuction:Client_VersionInvalidReceived(sender, data)
	if not kAuction.hasRunVersionCheck then
		local success, name, minRequiredVersion, serverVersion = kAuction:Deserialize(data);
		kAuction:Debug("FUNC: Client_VersionInvalidReceived, name, minRequiredVersion, serverVersion " .. name.. minRequiredVersion..serverVersion, 1);
		if name ~= UnitName("player") then
			return;
		end
		StaticPopupDialogs["kAuctionPopup_VersionInvalid"] = {
			text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction out of date.|r|n|nYour version: |cFF"..kAuction:RGBToHex(255,0,0)..kAuction.version.."|r|nRequired version: |cFF"..kAuction:RGBToHex(255,255,0)..minRequiredVersion.."|r|nServer version: |cFF"..kAuction:RGBToHex(0,255,0)..serverVersion.."|r|n|nPlease exit World of Warcraft and update your latest version from:|n|cFF"..kAuction:RGBToHex(190,0,110).."wow.curseforge.com/projects/kauction|r",
			button1 = "On it!",
			OnAccept = function()
				return;
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
		};
		PlaySoundFile(kAuction.sharedMedia:Fetch("sound", "Worms - Uh Oh"));		
		StaticPopup_Show("kAuctionPopup_VersionInvalid");
		kAuction.hasRunVersionCheck = true;
	end
end
function kAuction:Client_VersionRequestReceived(sender, version)
	kAuction:SendCommunication("Version", kAuction.version);
end