-- Author      : Gabe
-- Create Date : 2/11/2009 4:46:15 AM
 -- creating test data structure
kAuction.gui = {};
kAuction.gui.frames = {};
kAuction.gui.frames.modules = {};

kAuction.popout = {};
kAuction.popout.Menu = {};
kAuction.popout.SlotInfo = {
	[0] = { name="AmmoSlot", real="Ammo", swappable=1, INVTYPE_AMMO=1 },
	[1] = { name="HeadSlot", real="Head", INVTYPE_HEAD=1 },
	[2] = { name="NeckSlot", real="Neck", INVTYPE_NECK=1 },
	[3] = { name="ShoulderSlot", real="Shoulder", INVTYPE_SHOULDER=1 },
	[4] = { name="ShirtSlot", real="Shirt", INVTYPE_BODY=1 },
	[5] = { name="ChestSlot", real="Chest", INVTYPE_CHEST=1, INVTYPE_ROBE=1 },
	[6] = { name="WaistSlot", real="Waist", INVTYPE_WAIST=1 },
	[7] = { name="LegsSlot", real="Legs", INVTYPE_LEGS=1 },
	[8] = { name="FeetSlot", real="Feet", INVTYPE_FEET=1 },
	[9] = { name="WristSlot", real="Wrist", INVTYPE_WRIST=1 },
	[10] = { name="HandsSlot", real="Hands", INVTYPE_HAND=1 },
	[11] = { name="Finger0Slot", real="Top Finger", INVTYPE_FINGER=1, other=12 },
	[12] = { name="Finger1Slot", real="Bottom Finger", INVTYPE_FINGER=1, other=11 },
	[13] = { name="Trinket0Slot", real="Top Trinket", INVTYPE_TRINKET=1, other=14 },
	[14] = { name="Trinket1Slot", real="Bottom Trinket", INVTYPE_TRINKET=1, other=13 },
	[15] = { name="BackSlot", real="Cloak", INVTYPE_CLOAK=1 },
	[16] = { name="MainHandSlot", real="Main hand", swappable=1, INVTYPE_WEAPONMAINHAND=1, INVTYPE_2HWEAPON=1, INVTYPE_WEAPON=1, other=17 },
	[17] = { name="SecondaryHandSlot", real="Off hand", swappable=1, INVTYPE_WEAPON=1, INVTYPE_WEAPONOFFHAND=1, INVTYPE_SHIELD=1, INVTYPE_HOLDABLE=1, other=16 },
	[18] = { name="RangedSlot", real="Ranged", swappable=1, INVTYPE_RANGED=1, INVTYPE_THROWN=1, INVTYPE_RANGEDRIGHT=1, INVTYPE_RELIC=1 },
	[19] = { name="TabardSlot", real="Tabard", INVTYPE_TABARD=1 },
}
local sharedMedia = kAuction.sharedMedia

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
function kAuction:Gui_OnClickAuctionTab(auction,button)
	if button == "LeftButton" then
		if IsControlKeyDown() then
			DressUpItemLink(auction.itemLink);
		elseif IsShiftKeyDown() then
			kAuction:Item_SendHyperlinkToChat(auction.itemLink);
		else
			kAuction:Gui_SetSelectedTabByAuction(auction);
		end
	elseif button == "RightButton" and auction then
		for iTab,vTab in pairs(self.auctionTabs) do
			if vTab.auction.id == auction.id then
				tremove(self.auctionTabs,iTab);
			end
		end
	end
	kAuction:Gui_HookFrameRefreshUpdate();
end
function kAuction:Gui_AuctionTabOnEnter(tab)
	local localAuctionData;
	for i,val in pairs(self.auctions) do
		if val.id == tab.auction.id then
			localAuctionData = val;
		end
	end
	GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
	GameTooltip:ClearLines();
	GameTooltip:SetPoint("BOTTOMLEFT", kAuctionMainFrame, "TOPLEFT");
	GameTooltip:SetHyperlink(localAuctionData.itemLink);
	GameTooltip:AddDoubleLine("|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r", "|cFF"..kAuction:RGBToHex(128,128,128).."Left-Click to Select|r");
	GameTooltip:AddDoubleLine("|cFF"..kAuction:RGBToHex(0,255,0).."Bids: " .. #localAuctionData.bids.."|r", "|cFF"..kAuction:RGBToHex(128,128,128).."Right-Click to Close|r");
	if localAuctionData.winner then
		GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,0).."Winner: " .. localAuctionData.winner.."|r");
	end
	GameTooltip:Show();
end
function kAuction:Gui_UpdateBidTabs()
	local tabContainer = _G["kAuctionMainFrameTitleTabContainer"];
	-- Remove any invalid auctions
	for i,val in pairs(self.auctionTabs) do 
		local auction = kAuction:Client_GetAuctionById(val.auction.id);
		-- Check if valid auction exists for tab and that valid bids exist, else destroy the tab.
		if not auction or #auction.bids == 0 then
			kAuction:Debug("FUNC: Update, remove auctionTab auctionid: " .. val.auction.id, 1);
			tremove(self.auctionTabs,i);
			kAuction:Gui_HookFrameRefreshUpdate();
		end
	end
	local i = 1;
	while _G[tabContainer:GetName().."Tab"..i] do
		_G[tabContainer:GetName().."Tab"..i]:Hide(); -- Hide all
		i = i+1;
	end
	if #self.auctionTabs > 0 then
		local auctionsTabFrame = _G[tabContainer:GetName().."Tab1"];
		_G[auctionsTabFrame:GetName().."TitleText"]:SetText("Auctions");
		local frameWidthTotal = tabContainer:GetWidth() - auctionsTabFrame:GetWidth();
		local tabWidth = math.floor(frameWidthTotal / #self.auctionTabs);
		auctionsTabFrame:SetScript("OnMouseDown", function(self,button) kAuction:Gui_OnClickAuctionTab(nil,button) end);
		auctionsTabFrame:Show();			
		_G[auctionsTabFrame:GetName().."HighlightTexture"]:SetTexture(self.db.profile.gui.frames.main.tabs.highlightColor.r,self.db.profile.gui.frames.main.tabs.highlightColor.g,self.db.profile.gui.frames.main.tabs.highlightColor.b,self.db.profile.gui.frames.main.tabs.highlightColor.a);	
		for iTab,vTab in pairs(self.auctionTabs) do
			if kAuction:Client_GetAuctionById(vTab.auction.id) then -- Check if auction exists
				local auction = kAuction:Client_GetAuctionById(vTab.auction.id);
				local tabFrame;
				if _G[tabContainer:GetName().."Tab"..iTab+1] then -- Frame exists, update
					tabFrame = _G[tabContainer:GetName().."Tab"..iTab+1];
				else -- Frame doesn't exist, create
					tabFrame = CreateFrame("Frame", "kAuctionMainFrameTitleTabContainerTab"..iTab+1, tabContainer, "kAuctionTabButtonTemplate");
				end
				if iTab+1 == 1 then
					_G[tabFrame:GetName().."TitleText"]:SetText("Auctions");
				else
					_G[tabFrame:GetName().."TitleText"]:SetText(auction.itemLink);
				end
				tabFrame:SetScript("OnMouseDown", function(self,button) kAuction:Gui_OnClickAuctionTab(auction,button) end);
				tabFrame:SetScript("OnEnter", function(self) kAuction:Gui_AuctionTabOnEnter(vTab) end);
				tabFrame:SetScript("OnLeave", function(self) GameTooltip:Hide() end);
				_G[tabFrame:GetName().."HighlightTexture"]:SetTexture(self.db.profile.gui.frames.main.tabs.highlightColor.r,self.db.profile.gui.frames.main.tabs.highlightColor.g,self.db.profile.gui.frames.main.tabs.highlightColor.b,self.db.profile.gui.frames.main.tabs.highlightColor.a);
				if vTab.selected then
					local t;
					if not tabFrame.texture then
						t = tabFrame:CreateTexture(nil,"BACKGROUND");
					else
						t = tabFrame.texture;
					end
					t:SetTexture(self.db.profile.gui.frames.main.tabs.selectedColor.r,self.db.profile.gui.frames.main.tabs.selectedColor.g,self.db.profile.gui.frames.main.tabs.selectedColor.b,self.db.profile.gui.frames.main.tabs.selectedColor.a);
					t:SetAllPoints(tabFrame);
					tabFrame.texture = t;
				else
					local t;
					if not tabFrame.texture then
						t = tabFrame:CreateTexture(nil,"BACKGROUND");
					else
						t = tabFrame.texture;
					end
					t:SetTexture(self.db.profile.gui.frames.main.tabs.inactiveColor.r,self.db.profile.gui.frames.main.tabs.inactiveColor.g,self.db.profile.gui.frames.main.tabs.inactiveColor.b,self.db.profile.gui.frames.main.tabs.inactiveColor.a);
					t:SetAllPoints(tabFrame);
					tabFrame.texture = t;
				end
				tabFrame:SetWidth(tabWidth);
				tabFrame:ClearAllPoints();
				tabFrame:SetPoint("LEFT", _G[tabContainer:GetName().."Tab"..iTab+1-1], "RIGHT");
				if iTab == #self.auctionTabs then
					tabFrame:SetPoint("RIGHT", _G[tabContainer:GetName()], "RIGHT");
				end
				tabFrame:Show();
			else -- Remove auction tab and hide
				if _G[tabContainer:GetName().."Tab"..iTab+1] then
					_G[tabContainer:GetName().."Tab"..iTab+1]:Hide();
				end
			end
		end
		if kAuction:Gui_GetSelectedTab() then
			local t;
			if not auctionsTabFrame.texture then
				t = auctionsTabFrame:CreateTexture(nil,"BACKGROUND");
			else
				t = auctionsTabFrame.texture;
			end
			t:SetTexture(self.db.profile.gui.frames.main.tabs.inactiveColor.r,self.db.profile.gui.frames.main.tabs.inactiveColor.g,self.db.profile.gui.frames.main.tabs.inactiveColor.b,self.db.profile.gui.frames.main.tabs.inactiveColor.a);
			t:SetAllPoints(auctionsTabFrame);
			auctionsTabFrame.texture = t;		
		else
			local t;
			if not auctionsTabFrame.texture then
				t = auctionsTabFrame:CreateTexture(nil,"BACKGROUND");
			else
				t = auctionsTabFrame.texture;
			end
			t:SetTexture(self.db.profile.gui.frames.main.tabs.selectedColor.r,self.db.profile.gui.frames.main.tabs.selectedColor.g,self.db.profile.gui.frames.main.tabs.selectedColor.b,self.db.profile.gui.frames.main.tabs.selectedColor.a);
			t:SetAllPoints(auctionsTabFrame);
			auctionsTabFrame.texture = t;
		end	
	else -- No tabs, hide all
		local i = 1;
		while _G[tabContainer:GetName().."Tab"..i] do
			local tabFrame = _G[tabContainer:GetName().."Tab"..i];
			tabFrame:Hide();
			i = i + 1;
		end
	end
end
function kAuction:Gui_GetTabByAuctionId(id)
	for iTab,vTab in pairs(self.auctionTabs) do
		if vTab.auction.id == id then
			return vTab;
		end
	end
	return false;
end
function kAuction:Gui_GetSelectedTab()
	for iTab,vTab in pairs(self.auctionTabs) do
		if vTab.selected then
			return true;
		end
	end
	return false;
end
function kAuction:Gui_SetSelectedTabByAuction(auction)
	for iTab,vTab in pairs(self.auctionTabs) do
		if auction then
			if vTab.auction.id == auction.id then
				vTab.selected = true;
				for iAuction,vAuction in pairs(self.auctions) do
					if vAuction.id == auction.id then
						self.selectedAuctionIndex = iAuction;
					end
				end				
			else
				vTab.selected = false;
			end
		else
			vTab.selected = false;
		end
	end
	kAuction:Gui_HookFrameRefreshUpdate();
	return true;
end
function kAuction:Gui_AddAuctionToTabList(auction)
	if not kAuction:Gui_IsAuctionInTabList(auction) then -- Auction not in list already
		tinsert(self.auctionTabs, {
			auction = auction,
			selected = false,
			});
		return self.auctionTabs[#self.auctionTabs];
	end
	return kAuction:Gui_GetTabByAuctionId(auction.id);
end
function kAuction:Gui_IsAuctionInTabList(auction)
	for iTab,vTab in pairs(self.auctionTabs) do
		if vTab.auction.id == auction.id then
			return true;
		end
	end
	return false;
end
function kAuction:Gui_AlreadyInPopoutMenu(itemLink)
	for i,link in pairs(self.popout.Menu) do
		if link == itemLink then
			return true;
		end
	end
	return false;
end
function kAuction:Gui_AuctionBidButtonOnClick(objAuction, bidType, bestInSlot, setBonus)
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	if bidType == "none" then -- Cancel bid
		localAuctionData.bid = false; -- Set bid as false
		localAuctionData.bidType = false;	
		kAuction:SendCommunication("BidCancel", localAuctionData, 3);
	else -- actual bid
		localAuctionData.bid = true; -- Set as bid	
		localAuctionData.bidType = bidType;
		if bestInSlot ~= nil then
			localAuctionData.bestInSlot = bestInSlot;		
		end
		if setBonus ~= nil then
			localAuctionData.setBonus = setBonus;		
		end
		kAuction:SendCommunication("Bid", localAuctionData, 3);
	end
	kAuction:Gui_HookFrameRefreshUpdate();	
end
function kAuction:Gui_AuctionBestInSlotButtonOnClick(objAuction, value)
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	if localAuctionData then
		localAuctionData.bestInSlot = value;
		kAuction:SendCommunication("Bid", localAuctionData, 3);
	end
	kAuction:Gui_HookFrameRefreshUpdate();	
end
function kAuction:Gui_AuctionSetBonusButtonOnClick(objAuction, value)
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	if localAuctionData then
		localAuctionData.setBonus = value;
		kAuction:SendCommunication("Bid", localAuctionData, 3);
	end
	kAuction:Gui_HookFrameRefreshUpdate();	
end
function kAuction:Gui_AuctionBidCancelButtonOnClick(objAuction)
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	localAuctionData.bid = false; -- Set bid as false
	localAuctionData.bidType = false;
	-- SendComm
	kAuction:SendCommunication("BidCancel", objAuction, 3);
	kAuction:Gui_HookFrameRefreshUpdate();
end
function kAuction:Gui_AuctionBidDisenchantButtonOnClick(objAuction)
	local localAuction = kAuction:Client_GetAuctionById(objAuction.id);
	localAuction.disenchant = true;
	kAuction:Server_AwardAuction(localAuction);
	kAuction:Gui_HookFrameRefreshUpdate();
end
function kAuction:Gui_AuctionCloseButtonOnClick(objAuction)
	if self.auctions[kAuction:Client_GetAuctionIndexByAuctionId(objAuction.id)] then
		local auction = self.auctions[kAuction:Client_GetAuctionIndexByAuctionId(objAuction.id)];
		tremove(self.auctions, kAuction:Client_GetAuctionIndexByAuctionId(objAuction.id))
		if kAuction:Client_IsServer() then
			kAuction:SendCommunication("AuctionDelete", auction, 3);	
		end
	end
	kAuction:Gui_HookFrameRefreshUpdate();
end
function kAuction:Gui_AuctionItemOnClick(frame, button)
	offset = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	if button == "LeftButton" then
		if IsControlKeyDown() then
			DressUpItemLink(self.auctions[offset+row].itemLink);
		elseif IsShiftKeyDown() then
			kAuction:Item_SendHyperlinkToChat(self.auctions[offset+row].itemLink);
		else
			if self.auctions[offset+row].bids and #self.auctions[offset+row].bids > 0 then
				-- Check if details window is available via .visiblePublicDetails
				if self.auctions[offset+row].visiblePublicDetails or kAuction:Client_IsServer() or kAuction:IsLootCouncilMember(auction) then
					kAuction:Gui_AddAuctionToTabList(self.auctions[offset+row]);
					kAuction:Gui_SetSelectedTabByAuction(self.auctions[offset+row]);			
				end		
				kAuction:Gui_HookFrameRefreshUpdate();
			end
		end
	elseif button == "RightButton" then
		kAuction:Gui_CreateAuctionItemDropdown(self.auctions[offset+row], frame);
	end
end
function kAuction:Gui_CreateAuctionItemDropdown(auction, auctionFrame)
	--[[
	info.text = [STRING]  --  The text of the button
	info.value = [ANYTHING]  --  The value that UIDROPDOWNMENU_MENU_VALUE is set to when the button is clicked
	info.func = [function()]  --  The function that is called when you click the button
	info.checked = [nil, true, function]  --  Check the button if true or function returns true
	info.isTitle = [nil, true]  --  If it's a title the button is disabled and the font color is set to yellow
	info.disabled = [nil, true]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
	info.hasArrow = [nil, true]  --  Show the expand arrow for multilevel menus
	info.hasColorSwatch = [nil, true]  --  Show color swatch or not, for color selection
	info.r = [1 - 255]  --  Red color value of the color swatch
	info.g = [1 - 255]  --  Green color value of the color swatch
	info.b = [1 - 255]  --  Blue color value of the color swatch
	info.colorCode = [STRING] -- "|cAARRGGBB" embedded hex value of the button text color. Only used when button is enabled
	info.swatchFunc = [function()]  --  Function called by the color picker on color change
	info.hasOpacity = [nil, 1]  --  Show the opacity slider on the colorpicker frame
	info.opacity = [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
	info.opacityFunc = [function()]  --  Function called by the opacity slider when you change its value
	info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
	info.notClickable = [nil, 1]  --  Disable the button and color the font white
	info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
	info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
	info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
	info.tooltipTitle = [nil, STRING] -- Title of the tooltip shown on mouseover
	info.tooltipText = [nil, STRING] -- Text of the tooltip shown on mouseover
	info.justifyH = [nil, "CENTER"] -- Justify button text
	info.arg1 = [ANYTHING] -- This is the first argument used by info.func
	info.arg2 = [ANYTHING] -- This is the second argument used by info.func
	info.fontObject = [FONT] -- font object replacement for Normal and Highlight
	info.menuList = [TABLE] -- This contains an array of info tables to be displayed as a child menu]]
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id);	
	local menuData = {
		{
			func = function() end,
			text = auction.itemLink,
			notClickable = true,
			notCheckable = true,
		},
		{
			func = function() end,
			isTitle = true,
			text = "Select a Bid Type",
		},
		{
			checked = true,		
			func = function() kAuction:Gui_AuctionBidButtonOnClick(auction, "none"); end,
			text = "No Bid",
			tooltipTitle = "No Bid Type",
			tooltipText = "No bid submitted for this item.  If you have made a bid, select this to cancel your current bid.",
			value = "none",
		},
		{
			func = function() kAuction:Gui_AuctionBidButtonOnClick(auction, "normal") end,
			text = "Normal Bid",
			tooltipTitle = "Normal Bid Type",
			tooltipText = "Normal Bid",
			value = "normal",
		},
		{
			func = function() kAuction:Gui_AuctionBidButtonOnClick(auction, "offspec") end,
			text = "Offspec Bid",
			tooltipTitle = "Offspec Bid Type",
			tooltipText = "Offspec Bid",
			value = "offspec",
		},
		{
			func = function() kAuction:Gui_AuctionBidButtonOnClick(auction, "rot") end,
			text = "Rot Bid",
			tooltipTitle = "Rot Bid Type",
			tooltipText = "Rot Bid",
			value = "rot",
		},
		{
			func = function() end,
			isTitle = true,
			text = "Extras",
		},
		{
			func = function()
				if localAuctionData.bestInSlot == true then
					kAuction:Gui_AuctionBestInSlotButtonOnClick(auction, false);
				else
					kAuction:Gui_AuctionBestInSlotButtonOnClick(auction, true);
				end
			end,
			text = "Best in Slot",
			tooltipTitle = "Best in Slot",
			tooltipText = "Is this item Best in Slot for the appropriate bid type?",
			value = "bestInSlot",
		},
		{
			func = function() 
				if localAuctionData.setBonus == true then
					kAuction:Gui_AuctionSetBonusButtonOnClick(auction, false);
				else
					kAuction:Gui_AuctionSetBonusButtonOnClick(auction, true);
				end
			end,
			text = "Completes a Set Bonus",
			tooltipTitle = "Set Bonus",
			tooltipText = "Does this item complete a set bonus for the appropriate bid type?",
			value = "setBonus",
		},
	};		
	if kAuction:GetAuctionTimeleft(auction) then -- Bid, not closed, show Cancel button
		if localAuctionData.bid then
			for i,val in pairs(menuData) do
				if val.value == 'none' then
					val.checked = false;
				end
				if val.value == 'normal' then
					if localAuctionData.bidType == val.value then
						val.checked = true;
						val.func = function() end;
					else
						val.checked = false;
						val.func = function() kAuction:Gui_AuctionBidButtonOnClick(auction, val.value) end;
					end
				elseif val.value == 'offspec' and localAuctionData.bidType == 'offspec' then
					if localAuctionData.bidType == val.value then
						val.checked = true;
						val.func = function() end;
					else
						val.checked = false;
						val.func = function() kAuction:Gui_AuctionBidButtonOnClick(auction, val.value) end;
					end
				elseif val.value == 'rot' and localAuctionData.bidType == 'rot' then
					if localAuctionData.bidType == val.value then
						val.checked = true;
						val.func = function() end;
					else
						val.checked = false;
						val.func = function() kAuction:Gui_AuctionBidButtonOnClick(auction, val.value) end;
					end
				end
				if val.value == 'setBonus' then
					if localAuctionData.setBonus == true then
						val.checked = true;
					else
						val.checked = false;
					end
					val.disabled = false;
				end
				if val.value == 'bestInSlot' then
					if localAuctionData.bestInSlot == true then
						val.checked = true;
					else
						val.checked = false;
					end
					val.disabled = false;
				end
			end	
		else
			for i,v in pairs(menuData) do
				if v.value == 'setBonus' or v.value == 'bestInSlot' then
					v.disabled = true;
				end
			end
		end
		EasyMenu(menuData, self.menu, auctionFrame, 0, 0, "MENU", 1.5)
	elseif kAuction:Client_IsServer() and auction.closed and auction.winner == false and not auction.disenchant then -- Expired, remove button
		tremove(menuData, 3);
		tremove(menuData, 4);
		tremove(menuData, 5);
		tremove(menuData, 6);
		tremove(menuData, 7);
		tremove(menuData, 8);
		tremove(menuData, 9);
		tinsert(menuData, {
			text = "Disenchant",
			func = function() kAuction:Gui_AuctionBidDisenchantButtonOnClick(auction) end,
			tooltipTitle = "Disenchant",
			tooltipText = "Disenchant",
		});
		EasyMenu(menuData, self.menu, auctionFrame, 0, 0, "MENU", 1.5)
	end
end
function kAuction:Gui_AuctionItemOnEnter(frame)
	local _, _, number = string.find(frame:GetName(), "(%d+)");
	kAuction:Debug("FUNC: Gui_AuctionItemOnEnter, frame: " .. frame:GetName() .. ", number: " .. number, 3)
	GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
	GameTooltip:ClearLines();
	GameTooltip:SetHyperlink(self.auctions[FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame) + number].itemLink);
	local itemId = kAuction:Item_GetItemIdFromItemLink(self.auctions[FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame) + number].itemLink);
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(self.auctions[FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame) + number].id);
	local itemIdCurrent;
	if localAuctionData.currentItemLink	then
		itemIdCurrent = kAuction:Item_GetItemIdFromItemLink(localAuctionData.currentItemLink);
	end
	GameTooltip:SetPoint("BOTTOMLEFT", kAuctionMainFrame, "TOPLEFT");
	GameTooltip:Show();
end
function kAuction:Gui_ConfigureBidColumns(line, auction)
	local frameBid = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line];
	local frameItemsWon = _G[frameBid:GetName().."ItemsWon"];
	local frameItemsWonText = _G[frameBid:GetName().."ItemsWonText"];
	local frameName = _G[frameBid:GetName().."Name"];
	local frameNameText = _G[frameBid:GetName().."NameText"];
	local frameRoll = _G[frameBid:GetName().."Roll"];
	local frameRollText = _G[frameBid:GetName().."RollText"];
	local buttonVote = _G[frameBid:GetName().."Vote"];
	if auction.auctionType == 2 and kAuction:IsLootCouncilMember(auction, self.playerName) then -- On council and is loot council auction type
		frameName:SetWidth(0.4 * self.db.profile.gui.frames.main.width)
		frameItemsWon:SetWidth(0.15 * self.db.profile.gui.frames.main.width)
		frameRoll:SetWidth(0.15 * self.db.profile.gui.frames.main.width)
		buttonVote:SetWidth(0.15 * self.db.profile.gui.frames.main.width)
		frameItemsWon:SetPoint("RIGHT", buttonVote, "LEFT")
	else
		frameName:SetWidth(0.33 * self.db.profile.gui.frames.main.width)
		frameItemsWon:SetWidth(0.33 * self.db.profile.gui.frames.main.width)
		frameRoll:SetWidth(0.33 * self.db.profile.gui.frames.main.width)
		buttonVote:SetWidth(0 * self.db.profile.gui.frames.main.width)
		frameItemsWon:SetPoint("RIGHT", frameBid, "RIGHT")
	end
end
function kAuction:Gui_CurrentItemOnClick(row)
	local index = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame) + row;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(self.auctions[index].id);
	if localAuctionData.currentItemLink ~= false and not localAuctionData.bid and kAuction:GetAuctionTimeleft(self.auctions[index]) then -- Check if currentItemlink and no active bid
		localAuctionData.currentItemLink = false;
	end
	_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"]:Hide();
	kAuction:Gui_HookFrameRefreshUpdate();
end
function kAuction:Gui_CurrentItemMenuOnClick(row, itemLink)
	local index = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame) + row;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(self.auctions[index].id);
	localAuctionData.currentItemLink = itemLink;
	_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"]:Hide();
	kAuction:Gui_HookFrameRefreshUpdate();
end
function kAuction:Gui_CurrentItemMenuOnEnter(frame,itemLink)
	kAuction:Debug("FUNC: Gui_AuctionItemNameOnEnter, frame: " .. frame:GetName(), 3)
	GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
	GameTooltip:ClearLines();
	GameTooltip:SetPoint("BOTTOMLEFT", frame, "TOPLEFT");
	GameTooltip:SetHyperlink(itemLink);
end
function kAuction:Gui_CreateBidItemWonMenuButton(row,index,itemLink)
	local button
	if _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrameButton"..index] then
		button = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrameButton"..index];
	else
		button = CreateFrame("CheckButton",self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrameButton"..index,_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrame"..index],"ActionButtonTemplate")
	end
	button:SetChecked(false);
	button:SetScript("OnEnter",function() kAuction:Gui_CurrentItemMenuOnEnter(button,itemLink) end)
	button:SetScript("OnLeave",function() GameTooltip:Hide() end)
	_G[button:GetName().."Icon"]:SetTexture(kAuction:Item_GetTextureOfItem(itemLink))
	return button;
end
function kAuction:Gui_CreateMenuButton(row,index,itemLink)
	local button
	if _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrameButton"..index] then
		button = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrameButton"..index];
	else
		button = CreateFrame("CheckButton",self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrameButton"..index,_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"],"ActionButtonTemplate")
	end
	button:RegisterForClicks("LeftButtonUp","RightButtonUp")
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(self.auctions[FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame) + row].id);
	if localAuctionData.currentItemLink ~= false  and (itemLink == localAuctionData.currentItemLink) then
		button:SetChecked(true);
	else
		button:SetChecked(false);
	end
	button:SetScript("OnClick",function() kAuction:Gui_CurrentItemMenuOnClick(row,itemLink) end)
	button:SetScript("OnEnter",function() kAuction:Gui_CurrentItemMenuOnEnter(button,itemLink) end)
	button:SetScript("OnLeave",function() GameTooltip:Hide() end)
	_G[button:GetName().."Icon"]:SetTexture(kAuction:Item_GetTextureOfItem(itemLink))
	return button;
end
function kAuction:Gui_HookFrameRefreshUpdate()
	kAuctionMainFrame:SetScale(self.db.profile.gui.frames.main.scale);
	if kAuction:Gui_GetSelectedTab() then
		_G["kAuctionMainFrameBidScrollContainer"]:Show()
		_G["kAuctionMainFrameMainScrollContainer"]:Hide()
		kAuction:BidsFrameScrollUpdate();
	else
		_G["kAuctionMainFrameBidScrollContainer"]:Hide()
		_G["kAuctionMainFrameMainScrollContainer"]:Show()
		kAuction:MainFrameScrollUpdate();
	end
	kAuction:Gui_UpdateBidTabs();
end
function kAuction:Gui_InitializeFrames()
	-- Main Frame: Resize
	_G[self.db.profile.gui.frames.main.name]:SetResizable(true);
	_G[self.db.profile.gui.frames.main.name]:SetMinResize(240,152);
	_G[self.db.profile.gui.frames.main.name]:SetMaxResize(400,152);
	_G[self.db.profile.gui.frames.main.name]:SetClampedToScreen(true);
	_G[self.db.profile.gui.frames.main.name.."ResizeLeft"]:SetFrameLevel(_G[self.db.profile.gui.frames.main.name.."ResizeLeft"]:GetParent():GetFrameLevel() + 10);
end
function kAuction:Gui_InitializePopups()
	StaticPopupDialogs["kAuctionPopup_StartRaidTracking"] = {
		text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r|nDo you wish to start tracking this raid?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			kAuction:Server_StartRaidTracking();
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1
	};
	StaticPopupDialogs["kAuctionPopup_StopRaidTracking"] = {
		text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r|nDo you wish to stop tracking this raid?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			kAuction:Server_StopRaidTracking();
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1
	};
end
function kAuction:Gui_IsTooltipTextRed(row)
	local r,g,b = _G["kAuctionTooltipText"..row]:GetTextColor()
	if r>.9 and g<.2 and b<.2 then
		return 1
	end
end
function kAuction:Gui_RefreshFrame(frame)
	if _G[self.db.profile.gui.frames.main.name] == frame then
		frame:SetHeight(self.db.profile.gui.frames.main.height);
		frame:SetWidth(self.db.profile.gui.frames.main.width);
	end
end
function kAuction:Gui_ResizeFrame(frame,button,state)
	kAuction:Debug("Gui_ResizeFrame", 1)
	if ((( not frame:GetParent().isLocked ) or ( frame:GetParent().isLocked == 0 ) ) and ( button == "LeftButton" ) ) then 
		kAuction:Debug("Resize not locked, left button.", 1)
		if state == "start" then
			kAuction:Debug("Resize START, frame: " .. frame:GetName(), 3)
			frame:GetParent().isResizing = true;
			if frame:GetName() == "kAuctionMainFrameResizeLeft" or frame:GetName() == "kAuctionBidsFrameResizeLeft" then
				kAuction:Debug("Resize BOTTOMLEFT START", 3)
				frame:GetParent():StartSizing("BOTTOMLEFT")
			elseif frame:GetName() == "kAuctionMainFrameResizeRight" or frame:GetName() == "kAuctionBidsFrameResizeRight" then
				kAuction:Debug("Resize BOTTOMRIGHT START", 3)
				frame:GetParent():StartSizing("BOTTOMRIGHT")
			end	
		else
			kAuction:Debug("Resize STOP", 3)
			frame:GetParent().isResizing = false;
			frame:GetParent():StopMovingOrSizing()
			if frame:GetName() == "kAuctionMainFrameResizeLeft" or frame:GetName() == "kAuctionMainFrameResizeRight" then
				self.db.profile.gui.frames.main.height = frame:GetParent():GetHeight();
				self.db.profile.gui.frames.main.width = frame:GetParent():GetWidth();
			end
			kAuction:Gui_HookFrameRefreshUpdate();
			--frame:GetParent():SaveMainWindowPosition()
		end
	end
end
function kAuction:Gui_SetFrameBackdropColor(frame, r, g, b, a)
	frame:SetBackdropColor(r,g,b,a);
end
function kAuction:Gui_UpdateAuctionBidButton(index, objAuction)
	-- Check status
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	local bidButton = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."Bid"];
	if localAuctionData.bid and kAuction:GetAuctionTimeleft(objAuction) then -- Bid, not closed, show Cancel button
		if localAuctionData.bidType == "normal" then
			bidButton:SetText("Offspec");
			bidButton:SetScript("OnClick", function() kAuction:Gui_AuctionBidButtonOnClick(objAuction) end);
		elseif localAuctionData.bidType == "offspec" then
			bidButton:SetText("Rot");
			bidButton:SetScript("OnClick", function() kAuction:Gui_AuctionBidButtonOnClick(objAuction) end);
		elseif localAuctionData.bidType == "rot" then
			bidButton:SetText("Cancel");
			bidButton:SetScript("OnClick", function() kAuction:Gui_AuctionBidCancelButtonOnClick(objAuction) end);
		end
		bidButton:SetWidth(65);
		bidButton:Show();
	elseif kAuction:GetAuctionTimeleft(objAuction) then
		bidButton:SetText("Bid");
		bidButton:SetWidth(30);
		bidButton:SetScript("OnClick", function() kAuction:Gui_AuctionBidButtonOnClick(objAuction) end);
		bidButton:Show();
	elseif kAuction:Client_IsServer() and objAuction.closed and objAuction.winner == false and not objAuction.disenchant then -- Expired, remove button
		bidButton:SetText("DE");
		bidButton:SetWidth(30);
		bidButton:SetScript("OnClick", function() kAuction:Gui_AuctionBidDisenchantButtonOnClick(objAuction) end);
		bidButton:Show();
	else
		bidButton:Hide();
	end
end
function kAuction:Gui_UpdateAuctionCandyBar(index, objAuction)
	row = "auction" .. index;
	local timeleft = kAuction:GetAuctionTimeleft(objAuction);
	if not kAuction:Gui_GetSelectedTab() then
		local iAuction = kAuction:Client_GetAuctionIndexByAuctionId(objAuction.id);
		if timeleft and self.auctions[iAuction] then
			-- Check if bar exists
			if not self.bars[index] then
				self.bars[index] = self.candyBar:New(sharedMedia:Fetch("statusbar", self.db.profile.gui.frames.main.barTexture), 250, 300)
				--self.bars[index] = self.candyBar:New(sharedMedia:Fetch("statusbar", self.db.profile.gui.frames.main.barTexture), self.db.profile.gui.frames.main.width*self.db.profile.gui.frames.main.scale - 51*self.db.profile.gui.frames.main.scale, 24*self.db.profile.gui.frames.main.scale)
			end
			self.bars[index]:SetDuration(objAuction.duration)
			self.bars[index]:SetColor(self.db.profile.gui.frames.main.barColor.r, self.db.profile.gui.frames.main.barColor.g, self.db.profile.gui.frames.main.barColor.b, self.db.profile.gui.frames.main.barColor.a)
			--self.bars[index]:SetPoint(row, "LEFT", _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."CurrentItemIcon"], "RIGHT", -24*self.db.profile.gui.frames.main.scale, 0);
			--[[
			self.candyBar:RegisterCandyBar(row, objAuction.duration, "", nil);
			self.candyBar:SetBackgroundColor(row, self.db.profile.gui.frames.main.barBackgroundColor.r, self.db.profile.gui.frames.main.barBackgroundColor.g, self.db.profile.gui.frames.main.barBackgroundColor.b, self.db.profile.gui.frames.main.barBackgroundColor.a);
			self.candyBar:SetColor(row, self.db.profile.gui.frames.main.barColor.r, self.db.profile.gui.frames.main.barColor.g, self.db.profile.gui.frames.main.barColor.b, self.db.profile.gui.frames.main.barColor.a);
			self.candyBar:SetCompletion(row, kAuction:MainFrameScrollUpdate());
			self.candyBar:SetHeight(row, 24*self.db.profile.gui.frames.main.scale);
			self.candyBar:SetPoint(row, "LEFT", _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."CurrentItemIcon"], "RIGHT", -24*self.db.profile.gui.frames.main.scale, 0);
			self.candyBar:SetTexture(row, sharedMedia:Fetch("statusbar", self.db.profile.gui.frames.main.barTexture));
			self.candyBar:SetTimeFormat(row, function() return "" end);
			self.candyBar:SetTimeLeft(row, timeleft);
			self.candyBar:SetWidth(row, self.db.profile.gui.frames.main.width*self.db.profile.gui.frames.main.scale - 51*self.db.profile.gui.frames.main.scale);
			]]
			-- Run Bar
			self.bars[index]:Start();
		end
	end
end
function kAuction:Gui_UpdateAuctionCurrentItemButtons(index, objAuction)
	local frameCurrentItem = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."CurrentItem"];
	local frameCurrentItemIcon = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."CurrentItemIcon"];
	frameCurrentItem:SetScript("OnClick",function() kAuction:Gui_CurrentItemOnClick(index) end);
	frameCurrentItem:SetScript("OnLeave",function() GameTooltip:Hide() end);
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);	
	-- Check if auctioned item is equippable
	if objAuction.currentItemSlot then
		if localAuctionData.currentItemLink then
			frameCurrentItemIcon:SetTexture(kAuction:Item_GetTextureOfItem(localAuctionData.currentItemLink))
		else
			frameCurrentItemIcon:SetTexture(kAuction:Item_GetEmptyPaperdollTextureOfItem(objAuction.itemLink) or kAuction:Item_GetEmptyPaperdollTextureOfItemSlot(objAuction.currentItemSlot));
		end
		kAuction:Debug("vertex color: " .. frameCurrentItemIcon:GetVertexColor(), 3);
		if localAuctionData.bid and kAuction:GetAuctionTimeleft(objAuction) then
			frameCurrentItemIcon:SetVertexColor(1,0,0,1);
		else
			frameCurrentItemIcon:SetVertexColor(1,1,1);
		end
	else -- Not equippable, set invalid texture
		frameCurrentItemIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");				
	end
end
function kAuction:Gui_UpdateAuctionCloseButton(index, objAuction)
	-- Check status
	local button = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."Close"];
	button:SetScript("OnClick", function() kAuction:Gui_AuctionCloseButtonOnClick(objAuction) end);
end
function kAuction:Gui_UpdateAuctionStatusText(index, objAuction)
	local statusText = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."StatusText"];
	local auctionItem = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index];
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	local bidText = "";
	local voteText = "";
	if objAuction.bids then
		if #objAuction.bids > 0 then
			bidText = "|cFF"..kAuction:RGBToHex(0,255,0).."B:"..#objAuction.bids.."|r ";	
		else
			bidText = "|cFF"..kAuction:RGBToHex(255,255,0).."B:"..#objAuction.bids.."|r ";	
		end
		-- Check if auctionType is Loot Council
		if objAuction.auctionType == 2 and kAuction:IsLootCouncilMember(objAuction, self.playerName) then
			local booBidFound = false;
			for i,bid in pairs(objAuction.bids) do
				if kAuction:BidHasCouncilMemberVote(bid, self.playerName) then
					booBidFound = true;
				end
			end
			if booBidFound then
				voteText = "|cFF"..kAuction:RGBToHex(0,255,0).."V|r ";					
			else
				voteText = "|cFF"..kAuction:RGBToHex(255,0,0).."V|r ";					
			end
		end
	end	
	if objAuction.winner then
		if objAuction.winner == self.playerName then
			statusText:SetText("WINNER!");
		else
			statusText:SetText("["..objAuction.winner.."]");
		end
	elseif objAuction.disenchant then
		statusText:SetText("Disenchanted");
	elseif objAuction.closed then -- Closed, cannot bid or cancel bid, remove button
		if kAuction:GetAuctionTimeleft(objAuction, objAuction.auctionCloseVoteDuration) then
			statusText:SetText(bidText..voteText.."Closed");
		else
			statusText:SetText("Closed");
		end
	elseif localAuctionData.bid and kAuction:GetAuctionTimeleft(objAuction) then -- Bid, not closed, show Cancel button
		if localAuctionData.bidType == "normal" then
			statusText:SetText(bidText..voteText.."Normal Bid");
		elseif localAuctionData.bidType == "offspec" then
			statusText:SetText(bidText..voteText.."Offspec Bid");
		elseif localAuctionData.bidType == "rot" then
			statusText:SetText(bidText..voteText.."Rot Bid");
		end
	elseif kAuction:GetAuctionTimeleft(objAuction) then
		statusText:SetText(bidText..voteText.."Auction Open");
	else -- Expired, remove button
		statusText:SetText("Expired");
	end	
	statusText:SetPoint("RIGHT", auctionItem, -30,0);
	statusText:Show();
end
function kAuction:Gui_UpdateBidCurrentItemButtons(index, auction, bid)
	local frameCurrentItem = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..index.."CurrentItem"];
	local frameCurrentItemIcon = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..index.."CurrentItemIcon"];
	if (auction.visiblePublicBidCurrentItems or kAuction:Client_IsServer() or kAuction:IsLootCouncilMember(auction)) and auction.currentItemSlot then -- Equippable and .visiblePublicBidCurrentItems = true
		if bid.currentItemLink then
			frameCurrentItem:SetScript("OnEnter", function() kAuction:Gui_CurrentItemMenuOnEnter(frameCurrentItem, bid.currentItemLink) end);
			frameCurrentItemIcon:SetTexture(kAuction:Item_GetTextureOfItem(bid.currentItemLink));
		else
			frameCurrentItem:SetScript("OnEnter", function() end);
			frameCurrentItemIcon:SetTexture(kAuction:Item_GetEmptyPaperdollTextureOfItem(auction.itemLink) or kAuction:Item_GetEmptyPaperdollTextureOfItemSlot(auction.currentItemSlot));
		end
		frameCurrentItem:SetScript("OnLeave",function() GameTooltip:Hide() end)
	else
		frameCurrentItem:SetScript("OnEnter", function() end);
		frameCurrentItemIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
	end
end
function kAuction:Gui_UpdateBidRollText(line, auction, bid)
	local auctionTimeLeft = kAuction:GetAuctionTimeleft(auction);
	local rollFrame = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."Roll"];
	local rollFrameText = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."RollText"];
	if auction.auctionType == 1 then -- Random
		if auction.visiblePublicBidRolls or kAuction:Client_IsServer() or kAuction:IsLootCouncilMember(auction) then
			if auctionTimeLeft then
				rollFrameText:SetText("--");
			else
				rollFrameText:SetText(bid.roll);
			end
		else
			rollFrameText:SetText("N/A");
		end
	elseif auction.auctionType == 2 then -- Loot Council then
		if auction.visiblePublicBidVoters or kAuction:Client_IsServer() or kAuction:IsLootCouncilMember(auction) then
			rollFrameText:SetText(#(bid.lootCouncilVoters).." of "..#(auction.councilMembers));
		else
			rollFrameText:SetText("N/A");
		end
	end
	rollFrameText:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.bids.font), self.db.profile.gui.frames.bids.fontSize);
end
function kAuction:Gui_UpdateBidItemsWonText(frame)
	offset = FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
	local _, _, line = string.find(frame:GetName(), "(%d+)");
	local name = self.auctions[self.selectedAuctionIndex].bids[offset+line].name;
	frame:SetText("|cFF"..kAuction:RGBToHex(0,255,0)..#(kAuction:Item_GetPlayerWonItemList(name, "normal")).."|r/|cFF"..kAuction:RGBToHex(255,255,0)..#(kAuction:Item_GetPlayerWonItemList(name, "offspec")).."|r/|cFF"..kAuction:RGBToHex(255,0,0)..#(kAuction:Item_GetPlayerWonItemList(name, "rot")).."|r");
	frame:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.bids.font), self.db.profile.gui.frames.bids.fontSize);
end
function kAuction:Gui_UpdateBidNameText(frame)
	offset = FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
	local auction = self.auctions[self.selectedAuctionIndex];
	local _, _, line = string.find(frame:GetName(), "(%d+)");
	local name = auction.bids[offset+line].name;
	local bidType = auction.bids[offset+line].bidType;
	local bestInSlot = auction.bids[offset+line].bestInSlot;
	local setBonus = auction.bids[offset+line].setBonus;
	local color = kAuction:RGBToHex(0,255,0);
	local frameName = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."Name"];
	local sExtra;
	if bidType == "offspec" then
		color = kAuction:RGBToHex(255,255,0);
	elseif bidType == "rot" then
		color = kAuction:RGBToHex(255,0,0);
	end
	if bestInSlot and setBonus then
		sExtra = "|cFF"..kAuction:RGBToHex(255,163,20).."BiS/Set|r"
	elseif bestInSlot then
		sExtra = "|cFF"..kAuction:RGBToHex(255,163,20).."BiS|r"
	elseif setBonus then
		sExtra = "|cFF"..kAuction:RGBToHex(255,163,20).."Set|r"
	end
	if sExtra then
		frame:SetText("|cFF"..color..name.."|r " .. sExtra);
	else
		frame:SetText("|cFF"..color..name.."|r");
	end
	frame:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.bids.font), self.db.profile.gui.frames.bids.fontSize);	
end
function kAuction:Gui_CreateTooltipBidRollOnEnter(frame)
	offset = FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
	local _, _, line = string.find(frame:GetName(), "(%d+)");
	local auction = self.auctions[self.selectedAuctionIndex];
	--kAuction:Gui_OnBidRollOnLeave(nil);
	--kAuction:Gui_OnBidItemsWonLeave(nil);
	local tip = self.qTip:Acquire("GameTooltip", 4, "LEFT", "LEFT", "RIGHT", "RIGHT")	
	if auction.auctionType == 2 and (auction.visiblePublicBidVoters or kAuction:Client_IsServer() or kAuction:IsLootCouncilMember(auction)) then
		local bid = self.auctions[self.selectedAuctionIndex].bids[offset + line];
		local rollFrame = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."Roll"];
		kAuction:Debug("FUNC: Gui_CreateTooltipBidRollOnEnter, Hovering.", 1);
		local objRed = {};
		local objGreen = {};
		tip:Clear();
		tip:SetPoint("TOP", rollFrame, "BOTTOM");
		local fontRed = CreateFont("kAuctionBidRollFontRed")
		fontRed:CopyFontObject(GameTooltipText)
		fontRed:SetTextColor(1,0,0)
		local fontGreen = CreateFont("kAuctionBidRollFontGreen")
		fontGreen:CopyFontObject(GameTooltipText)
		fontGreen:SetTextColor(0,1,0)
		for iVote, vVote in pairs(auction.councilMembers) do
			local booIsVoterInBid = false;
			for iBid,vBid in pairs(bid.lootCouncilVoters) do
				if vVote == vBid then
					booIsVoterInBid = true;
				end
			end
			if booIsVoterInBid then
				tinsert(objGreen, vVote)
			else
				tinsert(objRed, vVote)
			end
		end
		if #(objGreen) > 0 and #(objRed) > 0 then
			tip:AddHeader("Voters", nil, "Not Voted");
		elseif #(objGreen) > 0 then
			tip:AddHeader("Voters");
		elseif #(objRed) > 0 then
			tip:AddHeader(nil, nil, "Not Voted");
		end		
		if #(objGreen) >= #(objRed) then
			for i = 1, #(objGreen)+1 do
				tip:AddLine("");
			end
		elseif #(objRed) >= #(objGreen) then
			for i = 1, #(objRed)+1 do
				tip:AddLine("");
			end	
		end
		for i,val in pairs(objGreen) do
			tip:SetCell(i+1, 1, val, fontGreen, "LEFT", 2);
		end
		for i,val in pairs(objRed) do
			tip:SetCell(i+1, 3, val, fontRed, "RIGHT", 2);
		end
		tip:Show();
	elseif auction.auctionType == 2 then
		local rollFrame = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."Roll"];
		tip:Clear();
		tip:SetPoint("TOP", rollFrame, "BOTTOM");
		tip:AddHeader("Votes Hidden");
		tip:Show();
	elseif auction.auctionType == 1 then
		if auction.visiblePublicBidRolls or kAuction:Client_IsServer() or kAuction:IsLootCouncilMember(auction) then
			self.qTip:Release(self.qTip:Acquire("GameTooltip"));
		else
			local rollFrame = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."Roll"];
			tip:Clear();
			tip:SetPoint("TOP", rollFrame, "BOTTOM");
			tip:AddHeader("Roll Hidden");
			tip:Show()
		end
	end
end
function kAuction:Gui_OnBidRollOnLeave(frame)
	--self.qTip:Release();
	local tip = self.qTip:Acquire("GameTooltip");
	tip:Hide();
end
function kAuction:Gui_OnBidItemsWonLeave(frame)
	local tip = self.qTip:Acquire("GameTooltip");
	tip:Hide();
end
function kAuction:Gui_UpdateBidVoteButton(line, auction, bid)
	local buttonVote = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."Vote"];
	if auction.auctionType == 2 and kAuction:GetAuctionTimeleft(auction, auction.auctionCloseVoteDuration) and kAuction:IsLootCouncilMember(auction, self.playerName) then -- Check if bidType = 2 (loot council)
		-- Check if vote is active for bid
		if kAuction:BidHasCouncilMemberVote(bid, self.playerName) then
			buttonVote:SetScript("OnClick", function() kAuction:CancelLootCouncilVote(auction, bid) end);
			buttonVote:SetText("Cancel");
			buttonVote:SetWidth(55);
		else
			buttonVote:SetScript("OnClick", function() kAuction:RegisterLootCouncilVote(auction, bid) end);
			buttonVote:SetText("Vote");
			buttonVote:SetWidth(40);
		end
		buttonVote:Show();
	elseif kAuction:Client_IsServer() and not kAuction:GetAuctionTimeleft(auction) and not auction.winner then
		buttonVote:SetScript("OnClick", function() 
			auction.closed = true
			kAuction:Debug("FUNC: UpdateBidVoteButtonOnClick, bid.name: " .. bid.name, 1)
			kAuction:Server_AwardAuction(auction, bid.name) 
		end);
		buttonVote:SetText("Winner");
		buttonVote:SetWidth(55);		
		buttonVote:Show();
	else
		buttonVote:Hide();
	end
end
function kAuction:Gui_UpdateItemMatchMenu(row, objAuction)
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	if objAuction.currentItemSlot  then -- If item not equippable, no selection frame available
		-- Create/Update Threading Frame
		--kAuction:Threading_UpdateThreadingFrame("kAuctionThreadingFrameMain"..row);
		-- First, hide all Item buttons
		local i = 1;
		local selectFrame = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"];
		while _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrameButton"..i] do
			_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrameButton"..i]:Hide();
			i=i+1;
		end
		-- Next, loop through Match Menu and create button for each match
		local matchTable = kAuction:Item_GetInventoryItemMatchTable(objAuction.currentItemSlot)
		local button
		if #(matchTable) then
			for i=1,#(matchTable) do
				button = kAuction:Gui_CreateMenuButton(row,i,matchTable[i])
				button:SetScale(0.75);
				if i == 1 then
					button:SetPoint("RIGHT",selectFrame,"RIGHT",-8,0)
				else
					button:SetPoint("RIGHT",_G[selectFrame:GetName().."Button"..(i-1)],"LEFT",-5,0)
				end
			end
			selectFrame:SetPoint("RIGHT",_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItem"],"LEFT");
			selectFrame:SetWidth(#(matchTable)*32 + 8);
		end
	end
end
function kAuction:Gui_UpdateBidItemsWonFrame(frame)
	offset = FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
	local _, _, line = string.find(frame:GetName(), "(%d+)");
	local name = self.auctions[self.selectedAuctionIndex].bids[offset+line].name;
	local iItemWonList = kAuction:Item_GetPlayerWonItemList(name);
	local i = 1;
	local selectFrame = _G[frame:GetName().."SelectFrame"];
	if #(iItemWonList) == 0 then
		_G[frame:GetName().."SelectFrame"]:Hide();
	end
	if #(iItemWonList) > 0 then
		-- Next, loop through Match Menu and create button for each match
		local matchTable = kAuction:Item_GetPlayerWonItemList(name);
		local button
		if #(matchTable) then
			-- Create/Update Threading Frame
			--kAuction:Threading_UpdateThreadingFrame("kAuctionThreadingFrameBids"..line);
			local selectFrameWidth;
			for i=1,#(matchTable) do
				button = kAuction:Gui_CreateBidItemWonMenuButton(line,i,matchTable[i].itemLink)
				button:SetScale(0.5);
				if i == 1 then
					button:SetPoint("BOTTOMRIGHT",selectFrame,"BOTTOMRIGHT",-8,8)
				elseif ((i-1) % 5) == 0 then
					button:SetPoint("BOTTOM",_G[selectFrame:GetName().."Button"..(i-5)],"TOP",0,2)
				else
					button:SetPoint("RIGHT",_G[selectFrame:GetName().."Button"..(i-1)],"LEFT",-4,0)
				end
				if i >= 5 then
					selectFrameWidth = (button:GetWidth()-3) * 5;
				else
					selectFrameWidth = (button:GetWidth()-3) * i;
				end	
				if matchTable[i].bidType == "normal" then
					_G[button:GetName().."Icon"]:SetVertexColor(0,1,0,1)
				elseif matchTable[i].bidType == "offspec" then
					_G[button:GetName().."Icon"]:SetVertexColor(0.5,0.5,0,1)
				elseif matchTable[i].bidType == "rot" then
					_G[button:GetName().."Icon"]:SetVertexColor(1,0,0,1)
				end
				button:SetFrameStrata("TOOLTIP");
			end		
			selectFrame:SetPoint("BOTTOM",frame,"TOP");
			if math.ceil(#(matchTable) / 5) == math.floor(#(matchTable) / 5) then
				selectFrame:SetHeight(math.floor(#(matchTable) / 5) * (button:GetHeight()-0));
			else
				selectFrame:SetHeight((math.floor(#(matchTable) / 5) + 1) * (button:GetHeight()-0));
			end
			selectFrame:SetWidth(selectFrameWidth);
			selectFrame:SetFrameStrata("DIALOG");
		end		
	end
	-- Hide buttons as cleanup for new creations of SelectFrame is not visible (user not currently viewing this particular item won list)
	if not _G[frame:GetName().."SelectFrame"]:IsVisible() then
		for i=1,30 do
			if _G[frame:GetName().."SelectFrameButton"..i] then
				_G[frame:GetName().."SelectFrameButton"..i]:Hide();
			end
		end	
	end
end
function kAuction:Gui_TriggerEffectsAuctionReceived()
	if self.db.profile.bidding.auctionReceivedEffect == 2 then
		self.effects:Flash()
	elseif self.db.profile.bidding.auctionReceivedEffect == 3 then
		self.effects:Shake()
	end	
	local sound = sharedMedia:Fetch("sound", self.db.profile.bidding.auctionReceivedSound)
	if sound then
		PlaySoundFile(sound);
	end
end
function kAuction:Gui_TriggerEffectsAuctionWinnerReceived()
	if self.db.profile.bidding.auctionWinnerReceivedEffect == 2 then
		self.effects:Flash()
	elseif self.db.profile.bidding.auctionWinnerReceivedEffect == 3 then
		self.effects:Shake()
	end
	local sound = sharedMedia:Fetch("sound", self.db.profile.bidding.auctionWinnerReceivedSound)
	if sound then
		PlaySoundFile(sound);
	end
end
function kAuction:Gui_TriggerEffectsAuctionWon()
	if self.db.profile.bidding.auctionWonEffect == 2 then
		self.effects:Flash()
	elseif self.db.profile.bidding.auctionWonEffect == 3 then
		self.effects:Shake()
	end
	local sound = sharedMedia:Fetch("sound", self.db.profile.bidding.auctionWonSound)
	if sound then
		PlaySoundFile(sound);
	end
end

-- TODO: UPDATE
function kAuction:Gui_MinimizeFrame()
	kAuction:ShrinkFrame(gui.main_frame, self.db.profile.gui.mainframe.anchorpoint, minwidth, minheight);
	gui.main_frame:SetHeight(minheight);
	gui.main_frame:SetWidth(minwidth);
	_G["kAuction_MainFrameTitle".."Minimize"]:Hide();
	_G["kAuction_MainFrameTitle".."Maximize"]:Show();
	gui.auctions_frame:Hide();
	gui.title_bar_text:SetText("kAuction");
end
-- TODO: UPDATE
function kAuction:Gui_MaximizeFrame()
	kAuction:ExpandFrame(gui.main_frame, self.db.profile.gui.mainframe.anchorpoint, maxwidth, maxheight);
	gui.main_frame:SetHeight(maxheight);
	gui.main_frame:SetWidth(maxwidth);
	_G["kAuction_MainFrameTitle".."Minimize"]:Show();
	_G["kAuction_MainFrameTitle".."Maximize"]:Hide();
	gui.auctions_frame:Show();
	gui.title_bar_text:SetText("kAuction " .. kAuction_VERSION);
	--kAuction:Frame_SetSetting("MAXIMIZED", true);
end
-- TODO: UPDATE
function kAuction:Gui_ExpandFrame(frame, anchorpoint, maxwidth, maxheight)
	local intLeft = frame:GetLeft();
	local intRight = frame:GetRight();
	local intTop = frame:GetTop();
	local intBottom = frame:GetBottom();
	local intWidth = frame:GetWidth();
	local intHeight = frame:GetHeight();
	local intWidthDiff = maxwidth - intWidth;
	local intHeightDiff = maxheight - intHeight;
	local intX = 0;
	local intY = 0;
	frame:ClearAllPoints();
	if (anchorpoint == "Bottom Right") then
		intX = intLeft - intWidthDiff;
		intY = intBottom + maxheight;
	elseif (anchorpoint == "Bottom Left") then
		intY = intBottom + maxheight;
		intX = intLeft;
	elseif (anchorpoint == "Top Left") then
		intY = intBottom + intHeight;
		intX = intLeft;
	elseif (anchorpoint == "Top Right") then
		intX = intLeft - intWidthDiff;
		intY = intBottom + intHeight;
	end
	frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", intX, intY);	
end
-- TODO: UPDATE
function kAuction:Gui_ShrinkFrame(frame, anchorpoint, minwidth, minheight)
	local intLeft = frame:GetLeft();
	local intRight = frame:GetRight();
	local intTop = frame:GetTop();
	local intBottom = frame:GetBottom();
	local intWidth = frame:GetWidth();
	local intHeight = frame:GetHeight();
	local intWidthDiff = intWidth - minwidth;
	local intHeightDiff = intHeight - minheight;
	local intX = 0;
	local intY = 0;
	frame:ClearAllPoints();
	if (anchorpoint == "Bottom Right") then
		intY = intBottom + minheight;
		intX = intLeft + intWidthDiff;
	elseif (anchorpoint == "Bottom Left") then
		intY = intBottom + minheight;
		intX = intLeft;
	elseif (anchorpoint == "Top Left") then
		intY = intBottom + intHeight;
		intX = intLeft;
	elseif (anchorpoint == "Top Right") then
		intY = intBottom + intHeight;
		intX = intLeft + intWidthDiff;
	end
	frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", intX, intY);	
end
-- TODO: UPDATE
function kAuction:Gui_GetAnchorPoints(anchorside, anchorvertical, anchorhorizontal)
	local strObjectPoint = "";
	local strParentPoint = "";
	if (anchorside == "Right") then
		if (anchorvertical == "Top") then
			strObjectPoint = "TOPLEFT";
			strParentPoint = "TOPRIGHT";
		elseif (anchorvertical == "Bottom") then
			strObjectPoint = "BOTTOMLEFT";
			strParentPoint = "BOTTOMRIGHT";
		end
	elseif (anchorside == "Left") then
		if (anchorvertical == "Top") then
			strObjectPoint = "TOPRIGHT";
			strParentPoint = "TOPLEFT";
		elseif (anchorvertical == "Bottom") then
			strObjectPoint = "BOTTOMRIGHT";
			strParentPoint = "BOTTOMLEFT";
		end
	elseif (anchorside == "Top") then
		if (anchorhorizontal == "Left") then
			strObjectPoint = "BOTTOMLEFT";
			strParentPoint = "TOPLEFT";
		elseif (anchorhorizontal == "Right") then
			strObjectPoint = "BOTTOMRIGHT";
			strParentPoint = "TOPRIGHT";
		end
	elseif (anchorside == "Bottom") then
		if (anchorhorizontal == "Left") then
			strObjectPoint = "TOPLEFT";
			strParentPoint = "BOTTOMLEFT";
		elseif (anchorhorizontal == "Right") then
			strObjectPoint = "TOPRIGHT";
			strParentPoint = "BOTTOMRIGHT";
		end
	end
	return strObjectPoint, strParentPoint;
end