-- sender is a presenceId for real id messages, a character name otherwise
function kAuction:Gui_OnWhisper(msg, sender, isRealIdMessage)
	if strlower(msg) == "kauction help" or strlower(msg) == "ka help" then
		local messages = {
			self.const.chatPrefix.."The kAuction Whisper Bid System allows players without kAuction installed to enter bids on auctioned items.  Once an auction is announced, you will receive a whisper informing you of the auctioned item.",
			self.const.chatPrefix.."To enter a bid, you must whisper the raid leader ("..self.playerName..") with the item link (shift+left click) and any number of additional keywords to specify the type of bid you are entering.",
			self.const.chatPrefix.."Keywords can be entered in any order before or after the itemlink for the item you are bidding on.  All of the following keywords are case-insensitive:",
			self.const.chatPrefix.."Keywords for a NORMAL SPEC bid (an item you'd use in your primary spec): normal, main, mainspec, main spec, primary.",
			self.const.chatPrefix.."Keywords for a OFFSPEC SPEC bid (an item you'd use in your secondary spec): off, offspec, off spec, secondary.",
			self.const.chatPrefix.."Keywords for a ROT bid (an item you don't really need, but would rather take than see it get disenchanted): rot, rot spec, rotspec, tertiary.",
			self.const.chatPrefix.."Keywords for CANCELLING a bid you previously entered: cancel, remove, stop, no bid, nobid.",
			self.const.chatPrefix.."Keywords for marking an item BEST IN SLOT: bis, best in slot.",
			self.const.chatPrefix.."Keywords for marking an item as completing a SET BONUS: set, set bonus, setbonus.",
			self.const.chatPrefix.."Finally, to assist council members in selecting the best recipient, it is encouraged to also include your currently equipped item for the slot matching the item you are bidding on.",
			self.const.chatPrefix.."To include your current item, in addition to any of the normal keywords above and the itemlink of the auctioned item, you may also add a CURRENT ITEM keyword followed immediately by that itemlink.",
			self.const.chatPrefix.."Keywords to indicate and precede the CURRENT ITEM for the matching item slot: current, currentitem, current item, curr item, curr, existing, existing item, existing item.",
		}; 
		for i,v in pairs(messages) do
			SendChatMessage(v, "WHISPER", nil, sender);			
		end
	end
	local isBid, localAuctionData, auction = kAuction:Gui_GetWhisperBidType(msg,false);
	if isBid and not isRealIdMessage then
		kAuction:Debug("Gui_OnWhisper: isBid = true", 1);
		if localAuctionData.bidType == "cancel" then
			kAuction:Server_RemoveBidFromAuction(sender, localAuctionData);
			SendChatMessage(self.const.chatPrefix.."Auto-Response: Auction bid cancelled for " .. auction.itemLink .. ".", "WHISPER", nil, sender);
		elseif localAuctionData.bidType == "normal" or localAuctionData.bidType == "offspec" or localAuctionData.bidType == "rot" then
			SendChatMessage(self.const.chatPrefix.."Auto-Response: Auction bid accepted as "..localAuctionData.bidType .." bid type for " .. auction.itemLink .. ".", "WHISPER", nil, sender);
			kAuction:Server_AddBidToAuction(sender, localAuctionData);
		end
	end
end
function kAuction:Gui_GetWhisperBidType(msg,addOffset)
	if not self.db.profile.looting.auctionWhisperBidEnabled then
		return nil;
	end
	local keys = {};
	keys.bidTypeNormal = {"normal", "main", "mainspec", "main spec", "primary"}
	keys.bidTypeOffspec = {"off", "offspec", "off spec", "secondary"}
	keys.bidTypeRot = {"rot", "rotspec", "rot spec", "tertiary"}
	keys.bidTypeCancel = {"cancel", "remove", "stop", "no bid", "nobid"};
	keys.bestInSlot = {"bis", "best in slot"};
	keys.currentItemLink = {"current", "currentitem", "current item", "curr item", "curr", "existing", "existing item", "existingitem"};
	keys.setBonus = {"set", "set bonus", "setbonus"};
	--[[
	Mainspec keys:
	[default]
	normal
	main
	mainspec
	main spec
	Offspec keys:
	off
	offspec
	off spec
	Rot keys:
	rot
	rotspec
	rot spec
	Bid keys:
	bid
	Cancel keys:
	cancel
	remove
	]]
	local bidType;
	local currentItemLink;
	local isBestInSlot = false;
	local isSetBonus = false;
	local localAuctionData = {};	
	local auction;
	localAuctionData.bidType = "normal";
	local isValidAuction = false;
	for AuctionItemId in string.gmatch(msg, "|?c?f?f?%x*|?H?[^:]*:?(%d+):?%d*:?%d*:?%d*:?%d*:?%d*:?%-?%d*:?%-?%d*:?%d*|?h?%[?[^%[%]]*%]?|?h?|?r?") do
		if AuctionItemId then
			kAuction:Debug("Gui_WhisperBidType, AuctionItemId: " .. AuctionItemId, 1);
			auction = kAuction:Server_GetAuctionByItem(AuctionItemId, not addOffset);
			if auction then
				kAuction:Debug("Gui_WhisperBidType, auction: " .. auction.id, 1);
				if addOffset then
					if kAuction:GetAuctionTimeleft(auction,self.db.profile.looting.auctionWhisperBidSuppressionDelay * -1) then
						localAuctionData.id = auction.id;
						isValidAuction = true;
					end
				else
					if kAuction:GetAuctionTimeleft(auction) then
						localAuctionData.id = auction.id;
						isValidAuction = true;
					end
				end
			end
		end
    end
	if isValidAuction == false then
		-- Not valid auction, return nil
		return nil;
	end
	for i,v in pairs(keys.currentItemLink) do
		-- Check for item link
		local _, _, _, _, CurrentItemId = string.find(msg, v .. "%s+|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
		if CurrentItemId then
			kAuction:Debug("Gui_WhisperBidType: CurrentItemLinkItemId: " .. CurrentItemId, 1);
			localAuctionData.currentItemLink = kAuction:Item_GetItemLinkFromItemId(CurrentItemId);
		end
		local _, _, _, _, CurrentItemId = string.find(msg, v .. "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
		if CurrentItemId then
			kAuction:Debug("Gui_WhisperBidType: CurrentItemLinkItemId: " .. CurrentItemId, 1);
			localAuctionData.currentItemLink = kAuction:Item_GetItemLinkFromItemId(CurrentItemId);
		end
	end
	-- Check for bid
	for i,v in pairs(keys.bidTypeRot) do
		if string.find(strlower(msg), v) then
			localAuctionData.bidType = "rot";
		end
	end
	for i,v in pairs(keys.bidTypeOffspec) do
		if string.find(strlower(msg), v) then
			localAuctionData.bidType = "offspec";
		end
	end
	for i,v in pairs(keys.bidTypeNormal) do
		if string.find(strlower(msg), v) then
			localAuctionData.bidType = "normal";
		end
	end
	-- Check for bid cancel
	for i,v in pairs(keys.bidTypeCancel) do
		if string.find(strlower(msg), v) then
			localAuctionData.bidType = "cancel";
		end
	end
	-- Check for bis
	for i,v in pairs(keys.bestInSlot) do
		if string.find(strlower(msg), v) then
			localAuctionData.bestInSlot = true;
		end
	end
	-- Check for set bonus
	for i,v in pairs(keys.setBonus) do
		if string.find(strlower(msg), v) then
			localAuctionData.setBonus = true;
		end
	end
	return true, localAuctionData, auction;
	-- If no bid type specified, but item link exists, assume normal bid
end