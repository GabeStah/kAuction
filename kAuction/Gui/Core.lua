-- Author      : Gabe
-- Create Date : 2/11/2009 4:46:15 AM
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

--- TIMERS ---
--- TIMERS END ---

--- EVENTS ---
function kAuction:Gui_OnClickAuctionBestInSlotButton(objAuction, value)
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	if localAuctionData then
		localAuctionData.bestInSlot = value;
		kAuction:SendCommunication("Bid", localAuctionData, 3);
	end
	kAuction:Gui_HookFrameRefreshUpdate();	
end
function kAuction:Gui_OnClickAuctionBidButton(objAuction, bidType, bestInSlot, setBonus)
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	if bidType then
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
			-- Trigger current item popup
			kAuction:Gui_CreateCurrentItemFrame(objAuction)
		end
	else
		if not localAuctionData.bidType then
			localAuctionData.bidType = 'normal'
		end
		-- No bidtype, pull from localAuction
		kAuction:SendCommunication("Bid", localAuctionData, 3);
		-- Trigger current item popup
		kAuction:Gui_CreateCurrentItemFrame(objAuction)		
	end
	kAuction:Gui_HookFrameRefreshUpdate();	
end
function kAuction:Gui_OnClickAuctionBidCancelButton(objAuction)
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	localAuctionData.bid = false; -- Set bid as false
	localAuctionData.bidType = false;
	-- SendComm
	kAuction:SendCommunication("BidCancel", objAuction, 3);
	kAuction:Gui_HookFrameRefreshUpdate();
end
function kAuction:Gui_OnClickAuctionBidDisenchantButton(objAuction)
	local localAuction = kAuction:Client_GetAuctionById(objAuction.id);
	localAuction.disenchant = true;
	kAuction:Server_AwardAuction(localAuction);
	kAuction:Gui_HookFrameRefreshUpdate();
end
function kAuction:Gui_OnClickAuctionItem(frame, button)
	kAuction:Debug("auctionitemonclick frame: "..frame:GetName() .. ', butt: ' .. button)
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
	--[[
	elseif button == "RightButton" then
		kAuction:Gui_CreateAuctionItemDropdown(self.auctions[offset+row], frame);
	]]		
	end
end
function kAuction:Gui_OnClickAuctionSetBonusButton(objAuction, value)
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	if localAuctionData then
		localAuctionData.setBonus = value;
		kAuction:SendCommunication("Bid", localAuctionData, 3);
	end
	kAuction:Gui_HookFrameRefreshUpdate();	
end
function kAuction:Gui_OnClickCloseIcon(frame)
	local offset, selectFrame = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local sTitle, sClickText, sText;
	local iIndex = offset + row;
	local auction = self.auctions[iIndex];
	-- Delete Auction
	kAuction:DeleteAuction(auction)
end
function kAuction:Gui_OnClickCurrentItemIcon(frame)
	local offset, selectFrame = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local sTitle, sClickText, sText;
	local iIndex = offset + row;
	local auction = self.auctions[iIndex];
	local timeLeft = kAuction:GetAuctionTimeleft(auction);
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id);
	if localAuctionData.currentItemLink ~= false and not localAuctionData.bid and timeLeft then -- Check if currentItemlink and no active bid
		localAuctionData.currentItemLink = false;
	end	
	if timeLeft then
		kAuction:Gui_CreateCurrentItemFrame(auction);	
	end
end
function kAuction:Gui_OnEnterCurrentItemIcon(frame)
	local offset, selectFrame = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local sTitle, sClickText, sText;
	local iIndex = offset + row;
	local auction = self.auctions[iIndex];
	local timeLeft = kAuction:GetAuctionTimeleft(auction);
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id);	
	local tip = self.qTip:Acquire("GameTooltip", 1, "LEFT")
	tip:ClearAllPoints();
	tip:Clear();
	tip:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 0);
	tip:AddHeader("Current Item");
	if timeLeft then
		tip:AddLine("");
		tip:AddLine("");
		local fontOrange = CreateFont("kAuctionBidItemsWonFontOrange")
		fontOrange:CopyFontObject(GameTooltipText)
		fontOrange:SetTextColor(1,0.6,0)
		tip:SetCell(3, 1, "Left-Click to alter.", fontOrange);
	end
	tip:Show();
	if frame.currentItemLink then
		kAuction:Gui_ShowItemTooltip(frame, frame.currentItemLink)
	end
end
function kAuction:Gui_OnLeaveCurrentItem(frame)
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"]:Hide();
end
--- EVENTS END ---

function kAuction:Gui_AlreadyInPopoutMenu(itemLink)
	for i,link in pairs(self.popout.Menu) do
		if link == itemLink then
			return true;
		end
	end
	return false;
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
			func = function() kAuction:Gui_OnClickAuctionBidButton(auction, "none"); end,
			text = "No Bid",
			tooltipTitle = "No Bid Type",
			tooltipText = "No bid submitted for this item.  If you have made a bid, select this to cancel your current bid.",
			value = "none",
		},
		{
			func = function() kAuction:Gui_OnClickAuctionBidButton(auction, "normal") end,
			text = "Normal Bid",
			tooltipTitle = "Normal Bid Type",
			tooltipText = "Normal Bid",
			value = "normal",
		},
		{
			func = function() kAuction:Gui_OnClickAuctionBidButton(auction, "offspec") end,
			text = "Offspec Bid",
			tooltipTitle = "Offspec Bid Type",
			tooltipText = "Offspec Bid",
			value = "offspec",
		},
		{
			func = function() kAuction:Gui_OnClickAuctionBidButton(auction, "rot") end,
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
					kAuction:Gui_OnClickAuctionBestInSlotButton(auction, false);
				else
					kAuction:Gui_OnClickAuctionBestInSlotButton(auction, true);
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
					kAuction:Gui_OnClickAuctionSetBonusButton(auction, false);
				else
					kAuction:Gui_OnClickAuctionSetBonusButton(auction, true);
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
						val.func = function() kAuction:Gui_OnClickAuctionBidButton(auction, val.value) end;
					end
				elseif val.value == 'offspec' and localAuctionData.bidType == 'offspec' then
					if localAuctionData.bidType == val.value then
						val.checked = true;
						val.func = function() end;
					else
						val.checked = false;
						val.func = function() kAuction:Gui_OnClickAuctionBidButton(auction, val.value) end;
					end
				elseif val.value == 'rot' and localAuctionData.bidType == 'rot' then
					if localAuctionData.bidType == val.value then
						val.checked = true;
						val.func = function() end;
					else
						val.checked = false;
						val.func = function() kAuction:Gui_OnClickAuctionBidButton(auction, val.value) end;
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
		kAuction:Gui_CreateDropdownMenuTimer()
		EasyMenu(menuData, self.menu, auctionFrame, 0, 0, "MENU", 1)
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
			func = function() kAuction:Gui_OnClickAuctionBidDisenchantButton(auction) end,
			tooltipTitle = "Disenchant",
			tooltipText = "Disenchant",
		});
		kAuction:Gui_CreateDropdownMenuTimer()
		EasyMenu(menuData, self.menu, auctionFrame, 0, 0, "MENU", 1)
	end
end
function kAuction:Gui_CreateDropdownMenuTimer()
	-- Close timer
	self:CreateTimer(function()
		if not DropDownList1:IsMouseOver() then
			CloseDropDownMenus();
			return true;
		end
	end,2,true)	
end
function kAuction:Get_GetAuctionFromFrame(frame)
	local offset, selectFrame = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local sTitle, sClickText, sText;
	local iIndex = offset + row;
	local auction = self.auctions[iIndex];
	if auction then
		return auction
	end
	return nil
end
function kAuction:Gui_GetFrameIndexOfAuction(auction)
	local line;
	for line=1,5 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
		if lineplusoffset <= #(self.auctions) then
			if self.auctions[lineplusoffset] then
				return line;
			end
		end
	end	
	return nil;
end
function kAuction:Gui_GetBidFrameIndexOfName(name)
	local line;
	for line=1,5 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
		if lineplusoffset <= #(self.auctions) then
			if self.auctions[lineplusoffset] then
				return line;
			end
		end
	end	
	return nil;
end
function kAuction:Gui_HookFrameRefreshUpdate()
	kAuctionMainFrame:SetScale(kAuction.db.profile.gui.frames.main.scale);
	if kAuction:Gui_GetSelectedTab() then
		_G["kAuctionMainFrameBidScrollContainer"]:Show()
		_G["kAuctionMainFrameMainScrollContainer"]:Hide()
		kAuction:BidsFrameScrollUpdate();
	else
		_G["kAuctionMainFrameBidScrollContainer"]:Hide()
		_G["kAuctionMainFrameMainScrollContainer"]:Show()
		kAuction:Gui_UpdateMainFrameScroll();
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
			if frame:GetName() == "kAuctionCurrentItemFrameResizeLeft" then
				kAuction:Debug("Resize BOTTOMLEFT START", 3)
				frame:GetParent():StartSizing("BOTTOMLEFT")
			elseif frame:GetName() == "kAuctionCurrentItemFrameResizeRight" then
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
			elseif frame:GetName() == 'kAuctionCurrentItemFrameResizeLeft' or frame:GetName() == 'kAuctionCurrentItemFrameResizeRight' then
				--kAuctionCurrentItemFrame:SetSize()
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
			bidButton:SetScript("OnClick", function() kAuction:Gui_OnClickAuctionBidButton(objAuction) end);
		elseif localAuctionData.bidType == "offspec" then
			bidButton:SetText("Rot");
			bidButton:SetScript("OnClick", function() kAuction:Gui_OnClickAuctionBidButton(objAuction) end);
		elseif localAuctionData.bidType == "rot" then
			bidButton:SetText("Cancel");
			bidButton:SetScript("OnClick", function() kAuction:Gui_OnClickAuctionBidCancelButton(objAuction) end);
		end
		bidButton:SetWidth(65);
		bidButton:Show();
	elseif kAuction:GetAuctionTimeleft(objAuction) then
		bidButton:SetText("Bid");
		bidButton:SetWidth(30);
		bidButton:SetScript("OnClick", function() kAuction:Gui_OnClickAuctionBidButton(objAuction) end);
		bidButton:Show();
	elseif kAuction:Client_IsServer() and objAuction.closed and objAuction.winner == false and not objAuction.disenchant then -- Expired, remove button
		bidButton:SetText("DE");
		bidButton:SetWidth(30);
		bidButton:SetScript("OnClick", function() kAuction:Gui_OnClickAuctionBidDisenchantButton(objAuction) end);
		bidButton:Show();
	else
		bidButton:Hide();
	end
end
function kAuction:Gui_UpdateAuctionCurrentItemButtons(index, objAuction)
	local frameCurrentItem = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."CurrentItem"];
	local frameCurrentItemIcon = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."CurrentItemIcon"];
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);	
	-- Check if auctioned item is equippable
	frameCurrentItem.currentItemLink = nil;
	if objAuction.currentItemSlot then
		if localAuctionData.currentItemLink and localAuctionData.bid then
			frameCurrentItemIcon:SetTexture(kAuction:Item_GetTextureOfItem(localAuctionData.currentItemLink))
			frameCurrentItem.currentItemLink = localAuctionData.currentItemLink;
		else
			frameCurrentItemIcon:SetTexture(kAuction:Item_GetEmptyPaperdollTextureOfItem(objAuction.itemLink) or kAuction:Item_GetEmptyPaperdollTextureOfItemSlot(objAuction.currentItemSlot));
		end
		if localAuctionData.bid and kAuction:GetAuctionTimeleft(objAuction) then
			frameCurrentItemIcon:SetVertexColor(1,0,0,1);
		else
			frameCurrentItemIcon:SetVertexColor(1,1,1);
		end
	else -- Not equippable, set invalid texture
		frameCurrentItemIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");				
	end
end
-- @MEMUSAGE 0.12KB
function kAuction:Gui_UpdateAuctionIcons(index, objAuction)
	local close = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."Close"];
	local timerText = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."StatusIconText"];
	local statusIcon = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."StatusIcon"];
	local bidIcon = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."BidIcon"];
	local voteIcon = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index.."VoteIcon"];
	local auctionItem = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..index];
	local localAuctionData = self:Client_GetLocalAuctionDataById(objAuction.id);
	local time = kAuction:GetAuctionTimeleft(objAuction);
	local states = kAuction:GetAuctionStateArray(statusIcon);
	statusIcon:SetPoint("RIGHT", close, "LEFT", 0, 0)
	-- DEFAULT HIDE
	voteIcon:Hide()
	-- VOTE ICON
	if states.vote or states.noVote then -- Council member
		-- Check if vote is still open, display stuff
		if states.voteOpen then
			voteIcon:Show()
			if states.vote then
				voteIcon:SetNormalTexture(sharedMedia:Fetch('texture','check'))			
			elseif states.noVote then
				voteIcon:SetNormalTexture(sharedMedia:Fetch('texture','exclaim'))
			end
		end
	end		
	if states.auctionOpen then
		-- BID ICON
		bidIcon:Show()
		if states.bid then
			bidIcon:SetNormalTexture(sharedMedia:Fetch('texture', 'user-check'))
			bidIcon:SetHighlightTexture(sharedMedia:Fetch('texture', 'user-delete'))			
		else
			bidIcon:SetNormalTexture(sharedMedia:Fetch('texture', 'user-mystery'))
			bidIcon:SetHighlightTexture(sharedMedia:Fetch('texture', 'user-add'))			
		end
		-- STATUS ICON
		statusIcon:SetNormalTexture(sharedMedia:Fetch('texture','clock'))
	elseif states.auctionClosed then	
		bidIcon:Hide();
		if states.winnerSelf then
			statusIcon:SetPoint("RIGHT", close, "LEFT", 0, 1)
			statusIcon:SetNormalTexture(sharedMedia:Fetch('texture','star2-full'))
		elseif states.winnerOther then
			statusIcon:SetPoint("RIGHT", close, "LEFT", 0, 1)
			statusIcon:SetNormalTexture(sharedMedia:Fetch('texture','star2-half'))
		elseif states.winnerDE then
			statusIcon:SetNormalTexture([[Interface\Icons\inv_misc_crystalepic]])
		else
			statusIcon:SetNormalTexture(sharedMedia:Fetch('texture','clockdark'))
		end
	end
	if time and time > 0 then
		timerText:SetText(math.floor(time))
	else
		timerText:SetText('')
	end
end
function kAuction:Gui_UpdateMainFrameScroll()
	-- BASE MEMORY USAGE: +0KB
	if self.auctions and #(self.auctions) > 0 and self.db.profile.gui.frames.main.visible then
		local line; -- 1 through 5 of our window to scroll
		local lineplusoffset; -- an index into our data calculated from the scroll offset
		local fCur = kAuctionCurrentItemFrame;		
		local booIsCurrentItemActive = fCur.active;
		local booIsCurrentItemMatchingAuction = false;
		FauxScrollFrame_Update(kAuctionMainFrameMainScrollContainerScrollFrame,#(self.auctions),5,16);
		_G[self.db.profile.gui.frames.main.name.."TitleText"]:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.main.font), 16);
		for line=1,5 do
			lineplusoffset = line + FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
			if lineplusoffset <= #(self.auctions) and GetItemInfo(self.auctions[lineplusoffset].itemLink) then
				local fNameText = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..line.."ItemNameText"];
				fNameText:SetText(GetItemInfo(self.auctions[lineplusoffset].itemLink))
				fNameText:SetTextColor(kAuction:Item_GetColor(self.auctions[lineplusoffset].itemLink))
				fNameText:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.main.font), self.db.profile.gui.frames.main.fontSize);
				-- Removed r8702, replaced by dropdown system -- Update Bid Button --kAuction:Gui_UpdateAuctionBidButton(line, self.auctions[lineplusoffset]);
				-- Update Close Button
				-- MEMORY USAGE: +0.88KB
				--kAuction:Gui_UpdateAuctionCloseButton(line, self.auctions[lineplusoffset]);
				-- Update Current Item Buttons
				-- MEMORY USAGE: +1.17KB
				kAuction:Gui_UpdateAuctionCurrentItemButtons(line, self.auctions[lineplusoffset]);
				-- Update Icons
				-- Check for Current Item popup position
				if booIsCurrentItemActive then
					if fCur.auction then
						-- Matching auction
						if self.auctions[lineplusoffset].id == fCur.auction.id then
							booIsCurrentItemMatchingAuction = true
							local fCurrItem = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..line.."CurrentItem"]
							if  kAuction.db.profile.gui.frames.currentItem.anchorSide == 'LEFT' then 
								kAuction:Gui_AttachCurrentItemFrame('BOTTOMRIGHT', fCurrItem, 'LEFT', 0, 0)
							else
								kAuction:Gui_AttachCurrentItemFrame('BOTTOMLEFT', fCurrItem:GetParent(), 'RIGHT', 0, 0)								
							end
							--kAuction:Gui_ShowCurrentItem()
						end
					end
				end
				-- MEMORY USAGE: +4.44KB
				kAuction:Gui_UpdateAuctionIcons(line, self.auctions[lineplusoffset]);
				-- Update Pullout menu
				-- MEMORY USAGE: +3.66KB
				--kAuction:Gui_UpdateItemMatchMenu(line, self.auctions[lineplusoffset]);
				_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..line]:Show();
			else
				_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..line]:Hide();
			end
		end
		--_G[self.db.profile.gui.frames.main.name.."MainScrollContainer"]:Show();
		_G[self.db.profile.gui.frames.main.name]:Show();
		-- Hide Current Item if needed
		if booIsCurrentItemActive and booIsCurrentItemMatchingAuction == false then
			kAuction:Gui_HideCurrentItem()
		end
	else
		_G[self.db.profile.gui.frames.main.name]:Hide();
	end
end
--- Creates scrips and text for auction icons and tooltips
-- @MEMUSAGE 4.20KB (IF SECTION: 1.37KB)
function kAuction:Gui_GetIconStrings(icon,name,states,auction,timeLeft,winner)
	local sTitle, sClickText, sText;
	-- @MEMUSAGE 0.82KB
	-- @MEMUSAGE-END 0.82KB
	-- @MEMUSAGE 0.83k
	-- @MEMUSAGE-START 1.37KB
	--[[
	auctionClosed
	auctionOpen
	bid
	bidType
	noBid
	noVote
	vote
	voteOpen
	voteClosed
	winnerDE
	winnerOther
	winnerSelf
	]]	
	if name == 'close' then
		sTitle, sText, sClickText = 'Delete Auction', ('Delete this auction for %s%s%s.'):format(auction.itemLink,'|cFF',kAuction.colorHex['white']), 'Left-Click to permanently delete.'
	end
	if name == 'vote' and states.vote or states.noVote then -- Council member
		-- Check if vote is still open, display stuff
		if states.voteOpen then
			if states.vote then
				sTitle, sText, sClickText = 'Vote Tallied', ('You voted on %s%s%s.'):format(auction.itemLink,'|cFF',kAuction.colorHex['white']), 'Left-Click to alter your vote.'
			elseif states.noVote then
				sTitle, sText, sClickText = 'Vote Required!', ('Vote needed on %s%s%s.'):format(auction.itemLink,'|cFF',kAuction.colorHex['white']), 'Left-Click to make your vote.'
			end
		end
	end		
	if states.auctionOpen then
		if name == 'bid' then
			if states.bid then
				sTitle, sText, sClickText = 'Bid Active', 
				('You bid on %s%s%s.'):format(auction.itemLink,'|cFF',kAuction.colorHex['white']), 
				'Left-Click to Remove your bid'			
			else
				sTitle, sText, sClickText = 'No Bid', 
				('You have no bid for %s%s%s.'):format(auction.itemLink,'|cFF',kAuction.colorHex['white']), 
				('Left-Click to Create a bid'):format(kAuction.colorHex['white'],kAuction.colorHex['green'], kAuction.colorHex['white'])		
			end
		end
		if name == 'status' then
			sTitle, sClickText = 'Auction Open', 'Left-Click to view bids.'
			if timeLeft then
				sText = ('Auction for %s%s%s expires in %s seconds.'):format(auction.itemLink,'|cFF',kAuction.colorHex['white'], timeLeft)
			else
				sText = ('Auction for %s%s%s expires soon.'):format(auction.itemLink,'|cFF',kAuction.colorHex['white'])
			end			
		end
	elseif states.auctionClosed then	
		if name == 'status' then
			if states.winnerSelf then
				sTitle = 'You win!'
				sText = ('You won %s%s%s!|nGo |cFF%scollect|r|cFF%s your loot sexy!|r'):format(auction.itemLink,'|cFF',kAuction.colorHex['white'],kAuction.colorHex['orange'],kAuction.colorHex['white'])
			elseif states.winnerOther then
				sTitle = 'Winner Announced'			
				if winner then			
					sText = ('%s%s%s awarded to %s!'):format(auction.itemLink,'|cFF',kAuction.colorHex['white'], winner)
				else
					sText = ('%s%s%s has been awarded!'):format(auction.itemLink,'|cFF',kAuction.colorHex['white'])
				end	
			elseif states.winnerDE then
				sTitle, sText = 'Disenchanted', ('%s%s%s is being sacrificed to the Enchantment Gods.'):format(auction.itemLink,'|cFF',kAuction.colorHex['white'])
			else
				sTitle, sText= 'Auction Closed', ('Auction for %s%s%s has expired.'):format(auction.itemLink,'|cFF',kAuction.colorHex['white'])
			end
		end
	end
	-- @MEMUSAGE-END 1.48KB
	-- @MEMUSAGE-START 2.1KB	
	return sTitle, sClickText, sText
end
function kAuction:Gui_ShowItemTooltip(anchorFrame,item,anchorPoint,anchorFramePoint)
	local anchorPoint = anchorPoint or 'BOTTOMLEFT';
	local anchorFramePoint = anchorFramePoint or 'TOPLEFT';
	GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
	GameTooltip:ClearLines();
	GameTooltip:SetPoint(anchorPoint, anchorFrame, anchorFramePoint);
	local itemLink = select(2, GetItemInfo(item))
	GameTooltip:SetHyperlink(itemLink);
end
function kAuction:Gui_SetIconTooltipStrings(frame, title, text, clickText)	
	if not title or not text then return nil end
	self:Gui_SetFrameBackdropColor(frame:GetParent(),0.9,0.9,0.9,0.1);
	GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
	GameTooltip:ClearLines();
	GameTooltip:SetPoint("BOTTOMRIGHT", kAuctionMainFrame, "TOPRIGHT");
	GameTooltip:AddLine(("|cFF%s%s|r"):format(self.colorHex['orange'], title));
	GameTooltip:AddLine(("|cFF%s%s|r"):format(self.colorHex['white'], text));
	if clickText then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(("|cFF%s%s|r"):format(self.colorHex['gold'], clickText));
	end
	GameTooltip:Show();
	frame:SetScript("OnLeave", function(widget,event,val)
		GameTooltip:Hide();
		self:Gui_SetFrameBackdropColor(widget:GetParent(),0,0,0,0);
	end);	
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
function kAuction:Gui_ShowCurrentItemPopup(frame)
	local offset = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local popup = _G[self.db.profile.gui.frames.currentItem.name];
	local parent = popup:GetParent();
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local iIndex = offset + row;
	local auction = self.auctions[iIndex];
	local timeLeft = kAuction:GetAuctionTimeleft(auction);
	local anchorSide = self.db.profile.gui.frames.currentItem.anchorSide;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id);	
	local states = kAuction:GetAuctionStateArray(frame);
	--sTitle, sClickText, sText = self:Gui_GetIconStrings(frame,'close',states,auction,timeLeft,auction.winner)	
	-- Create tooltips
	--kAuction:Gui_SetIconTooltipStrings(frame,sTitle,sText,sClickText)	
    parent.arrow:SetSize(21, 53)
    parent.arrow.arrow = _G[popup.arrow:GetName() .. "Arrow"]
    parent.arrow.glow = _G[popup.arrow:GetName() .. "Glow"]
    parent.arrow.arrow:SetAllPoints(true)
    parent.arrow.glow:SetAllPoints(true)
    -- Rotate 90 degrees
    -- left, bottom, right, bottom, left, top, right, top
    parent.arrow.arrow:SetTexCoord(0.78515625, 0.58789063, 0.99218750, 0.58789063, 0.78515625, 0.54687500, 0.99218750, 0.54687500)
    parent.arrow.glow:SetTexCoord(0.40625000, 0.82812500, 0.66015625, 0.82812500, 0.40625000, 0.77343750, 0.66015625, 0.77343750)
    parent.text:SetSpacing(4)	
	popup:Show()
	-- TODO: Finish coding anchoring for popup from auction frame
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