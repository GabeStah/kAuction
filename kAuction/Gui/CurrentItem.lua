local sharedMedia = kAuction.sharedMedia
-- EVENTS
function kAuction:Gui_OnClickCurrentItem(frame,button)
	local offset, lineplusoffset;
	local _, _, row = string.find(frame:GetName(), "(%d+)");	
	-- Manual hack to properly set offset
	FauxScrollFrame_SetOffset(kAuctionCurrentItemFrameScrollContainerScrollFrame, floor((kAuctionCurrentItemFrameScrollContainerScrollFrameScrollBar:GetValue() / kAuction.currentItemWidgetHeight) + 0.5))
	offset = FauxScrollFrame_GetOffset(kAuctionCurrentItemFrameScrollContainerScrollFrame);
	lineplusoffset = row + offset;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(kAuctionCurrentItemFrame.auction.id);
	localAuctionData.bid = true;
	localAuctionData.currentItemLink = frame.itemLink;
	-- Create or update bid
	kAuction:Gui_OnClickAuctionBidButton(kAuctionCurrentItemFrame.auction)
	kAuction:Gui_UpdateCurrentItemScroll()
end
function kAuction:Gui_OnClickCurrentItemBestInSlot(frame)
	frame = kAuctionCurrentItemFrame;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(frame.auction.id);
	if localAuctionData then
		localAuctionData.bestInSlot = not localAuctionData.bestInSlot;
		localAuctionData.bid = false;
	end
	kAuction:Gui_UpdateCurrentItemScroll()
end
function kAuction:Gui_OnClickCurrentItemCancelIcon(frame)
	kAuction:Gui_OnClickAuctionBidButton(kAuctionCurrentItemFrame.auction, 'none')
	kAuction:Gui_UpdateCurrentItemScroll()
end
function kAuction:Gui_OnClickCurrentItemSetBonus(frame)
	frame = kAuctionCurrentItemFrame;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(frame.auction.id);
	if localAuctionData then
		localAuctionData.bid = false;
		localAuctionData.setBonus = not localAuctionData.setBonus;
	end
	kAuction:Gui_UpdateCurrentItemScroll()
end
function kAuction:Gui_OnClickCurrentItemBidType(frame)
	frame = kAuctionCurrentItemFrame;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(frame.auction.id);
	if localAuctionData then
		if localAuctionData.bidType == 'normal' then
			localAuctionData.bidType = 'offspec';
		elseif localAuctionData.bidType == 'offspec' then
			localAuctionData.bidType = 'rot';
		elseif localAuctionData.bidType == 'rot' then
			localAuctionData.bidType = 'normal';
		else
			localAuctionData.bidType = 'offspec'
		end
		localAuctionData.bid = false;
	end
	kAuction:Gui_UpdateCurrentItemScroll()
end
function kAuction:Gui_OnEnterCurrentItem(frame)
	kAuction:Gui_ShowItemTooltip(frame, frame.itemLink)
end
function kAuction:Gui_OnEnterCurrentItemAnchorIcon(frame)
	sTitle, sClickText, sText = self:Gui_GetCurrentItemIconStrings('anchor')		
	kAuction:Gui_SetCurrentItemIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterCurrentItemBestInSlotIcon(frame)
	local auction = kAuctionCurrentItemFrame.auction;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id); 
	sTitle, sClickText, sText = self:Gui_GetCurrentItemIconStrings('bestInSlot',localAuctionData)		
	kAuction:Gui_SetCurrentItemIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterCurrentItemBidTypeIcon(frame)
	local auction = kAuctionCurrentItemFrame.auction;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id); 
	sTitle, sClickText, sText = self:Gui_GetCurrentItemIconStrings('bidType',localAuctionData)		
	kAuction:Gui_SetCurrentItemIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterCurrentItemCloseIcon(frame)
	sTitle, sClickText, sText = self:Gui_GetCurrentItemIconStrings('close')		
	kAuction:Gui_SetCurrentItemIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterCurrentItemConfigIcon(frame)
	sTitle, sClickText, sText = self:Gui_GetCurrentItemIconStrings('config')		
	kAuction:Gui_SetCurrentItemIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterCurrentItemSetBonusIcon(frame)
	local auction = kAuctionCurrentItemFrame.auction;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id); 
	sTitle, sClickText, sText = self:Gui_GetCurrentItemIconStrings('setBonus',localAuctionData)		
	kAuction:Gui_SetCurrentItemIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterCurrentItemCancelIcon(frame)
	sTitle, sClickText, sText = self:Gui_GetCurrentItemIconStrings('cancel')		
	kAuction:Gui_SetCurrentItemIconTooltipStrings(frame,sTitle,sText,sClickText)	
end
function kAuction:Gui_OnEnterCurrentItemGraphic(frame)
	kAuction:Gui_ShowItemTooltip(frame, frame:GetParent().itemLink)
end
function kAuction:Gui_OnEnterCurrentItemContainerIcon(frame)
	local auction = frame:GetParent():GetParent().auction;
	kAuction:Gui_ShowItemTooltip(frame, auction.itemLink)
end
function kAuction:Gui_OnEnterCurrentItemNameText(frame)
	kAuction:Gui_ShowItemTooltip(frame:GetParent(), frame:GetParent().itemLink)
end
-- EVENTS END

function kAuction:Gui_AttachCurrentItemFrame(anchorPoint, parent, relativePoint, xOffset, yOffset)
	local f = kAuctionCurrentItemFrame;
	local fArrow = kAuctionCurrentItemFrameArrow;
	local fGlow = kAuctionCurrentItemFrameGlow;
	local fArrowIcon = kAuctionCurrentItemFrameArrowArrow;
	local fGlowIcon = kAuctionCurrentItemFrameArrowGlow;
	local arrowWidth = 21;
	local arrowHeight = 53;
	--fArrow:SetSize(500,500)
	fArrowIcon:SetAllPoints(true)
	f:ClearAllPoints()
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:SetSize(250,250)
	fArrow:ClearAllPoints()
	fArrow:SetFrameStrata("FULLSCREEN_DIALOG")
	--(ULx,ULy,LLx,LLy,URx,URy,LRx,LRy);
	if anchorPoint == 'LEFT' or anchorPoint == 'BOTTOMLEFT' or anchorPoint == 'TOPLEFT' then
		fArrow:SetSize(arrowWidth, arrowHeight)
		fGlowIcon:SetSize(arrowWidth, arrowHeight)
		fArrowIcon:SetTexCoord(0.78515625, 0.58789063, 0.99218750, 0.58789063, 0.78515625, 0.54687500, 0.99218750, 0.54687500)
		fGlowIcon:SetTexCoord(0.40625000, 0.82812500, 0.66015625, 0.82812500, 0.40625000, 0.77343750, 0.66015625, 0.77343750)
		if anchorPoint == 'BOTTOMLEFT' then
			f:SetPoint(anchorPoint, parent, relativePoint, xOffset + arrowWidth, yOffset - f:GetHeight() / 2)
			fArrow:SetPoint('BOTTOMRIGHT', fArrow:GetParent(), 'BOTTOMLEFT', 0, (f:GetHeight() / 2) - (fArrow:GetHeight() / 2))
		elseif anchorPoint == 'BOTTOMRIGHT' then
			f:SetPoint(anchorPoint, parent, relativePoint, xOffset + arrowWidth, yOffset + f:GetHeight() / 2)
			fArrow:SetPoint('BOTTOMRIGHT', fArrow:GetParent(), 'BOTTOMLEFT', 0, (f:GetHeight() / 2) - (fArrow:GetHeight() / 2))
		else
			f:SetPoint(anchorPoint, parent, relativePoint, xOffset + arrowWidth, yOffset)
			fArrow:SetPoint(anchorPoint, parent, relativePoint, xOffset, yOffset)
		end		
	elseif anchorPoint == 'RIGHT' or anchorPoint == 'BOTTOMRIGHT' or anchorPoint == 'TOPRIGHT' then
		fArrow:SetSize(arrowWidth, arrowHeight)
		fGlowIcon:SetSize(arrowWidth, arrowHeight)
		fArrowIcon:SetTexCoord(0.99218750, 0.54687500, 0.78515625, 0.54687500, 0.99218750, 0.58789063, 0.78515625, 0.58789063)
		fGlowIcon:SetTexCoord(0.66015625, 0.77343750, 0.40625000, 0.77343750, 0.66015625, 0.82812500, 0.40625000, 0.82812500)
		if anchorPoint == 'BOTTOMRIGHT' then
			f:SetPoint(anchorPoint, parent, relativePoint, xOffset - arrowWidth, yOffset - f:GetHeight() / 2)
			fArrow:SetPoint('BOTTOMLEFT', fArrow:GetParent(), 'BOTTOMRIGHT', 0, (f:GetHeight() / 2) - (fArrow:GetHeight() / 2))
		elseif anchorPoint == 'TOPRIGHT' then
			f:SetPoint(anchorPoint, parent, relativePoint, xOffset - arrowWidth, yOffset + f:GetHeight() / 2)
			fArrow:SetPoint('BOTTOMLEFT', fArrow:GetParent(), 'BOTTOMRIGHT', 0, (f:GetHeight() / 2) - (fArrow:GetHeight() / 2))
		else
			f:SetPoint(anchorPoint, parent, relativePoint, xOffset - arrowWidth, yOffset)
			fArrow:SetPoint(anchorPoint, parent, relativePoint, xOffset, yOffset)
		end
	elseif anchorPoint == 'TOP' then
		fArrow:SetSize(arrowHeight, arrowWidth)
		fGlowIcon:SetSize(arrowHeight, arrowWidth)
		fArrowIcon:SetTexCoord(0.99218750, 0.58789063, 0.99218750, 0.54687500, 0.78515625, 0.58789063, 0.78515625, 0.54687500)
		fGlowIcon:SetTexCoord(0.66015625, 0.82812500, 0.66015625, 0.77343750, 0.40625000, 0.82812500, 0.40625000, 0.77343750)	
		kAuctionCurrentItemFrame:SetPoint(anchorPoint, parent, relativePoint, xOffset, yOffset - arrowWidth)
	elseif anchorPoint == 'BOTTOM' then
		fArrow:SetSize(arrowHeight, arrowWidth)
		fGlowIcon:SetSize(arrowHeight, arrowWidth)
		fArrowIcon:SetTexCoord(0.78515625, 0.54687500, 0.78515625, 0.58789063, 0.99218750, 0.54687500, 0.99218750, 0.58789063)
		fGlowIcon:SetTexCoord(0.40625000, 0.77343750, 0.40625000, 0.82812500, 0.66015625, 0.77343750, 0.66015625, 0.82812500)
		kAuctionCurrentItemFrame:SetPoint(anchorPoint, parent, relativePoint, xOffset, yOffset + arrowWidth)
	end
end
function kAuction:Gui_CreateCurrentItemFrame(auction)
	local frameIndex = kAuction:Gui_GetFrameIndexOfAuction(auction);
	if not frameIndex then return nil end
	local fCurItem = _G['kAuctionMainFrameMainScrollContainerAuctionItem'..frameIndex..'CurrentItem']
	local frame = kAuctionCurrentItemFrame;
	local auctionIcon = kAuctionCurrentItemFrameItemContainerIcon;
	-- Set retrievable auction data
	frame.auction = auction;
	frame.anchorFrame = fCurItem;
	frame.active = true;
	auctionIcon:SetNormalTexture(kAuction:Item_GetTextureOfItem(auction.itemLink));
	frame.matchTable = kAuction:Item_GetInventoryItemMatchTable(auction.currentItemSlot)
	if frame:IsVisible() then
		kAuction:Gui_UpdateCurrentItemScroll(frame)
	else
		if kAuction.db.profile.gui.frames.currentItem.anchorSide == 'LEFT' then
			kAuction:Gui_AttachCurrentItemFrame('BOTTOMRIGHT', fCurItem, 'LEFT', 0, 0)
		else
			kAuction:Gui_AttachCurrentItemFrame('BOTTOMLEFT', fCurItem, 'RIGHT', 0, 0)
		end
		kAuction:Gui_ShowCurrentItem()
	end
end
function kAuction:Gui_GetCurrentItemIconStrings(name,localAuction)
	local sTitle, sClickText, sText;
	if name == 'anchor' then
		if kAuction.db.profile.gui.frames.currentItem.anchorSide == 'LEFT' then
			sTitle, sText, sClickText = 'Toggle Anchor', ('Click to change the anchor attachment side to the RIGHT.'), 'Left-Click to change to RIGHT anchor.'	
		else
			sTitle, sText, sClickText = 'Toggle Anchor', ('Click to change the anchor attachment side to the LEFT.'), 'Left-Click to change to LEFT anchor.'	
		end
	end	
	if name == 'bidType' then
		if localAuction.bidType then
			if localAuction.bidType == 'normal' then
				sTitle, sText, sClickText = 'Bid Type', ('Click to change bid type to %s, used for your non-primary role.'):format("Offspec"), 'Left-Click to change to Offspec.'	
			elseif localAuction.bidType == 'offspec' then
				sTitle, sText, sClickText = 'Bid Type', ('Click to change bid type to %s, useful if you want the item only if it will be disenchanted.'):format("Rot"), 'Left-Click to change to Rot.'	
			elseif localAuction.bidType == 'rot' then
				sTitle, sText, sClickText = 'Bid Type', ('Click to change bid type to %s, used for your primary role.'):format("Mainspec"), 'Left-Click to change to Mainspec.'	
			end
		else
			sTitle, sText, sClickText = 'Bid Type', ('Click to change bid type to %s, used for your non-primary role.'):format("Offspec"), 'Left-Click to change to Offspec.'
		end
	end
	if name == 'bestInSlot' then 
		if localAuction.bestInSlot then
			sTitle, sText, sClickText = 'Best In Slot', ('Click to remove the Best in Slot flag from this item.'), 'Left-Click to remove Best in Slot.'	
		else
			sTitle, sText, sClickText = 'Best In Slot', ('Click to mark this item as Best in Slot.'), 'Left-Click to set as Best in Slot.'
		end
	end	
	if name == 'setBonus' then 
		if localAuction.setBonus then
			sTitle, sText, sClickText = 'Set Bonus', ('Click to remove the Set Bonus flag from this item.'), 'Left-Click to remove Set Bonus.'	
		else
			sTitle, sText, sClickText = 'Set Bonus', ('Click to indicate this item would complete an armor Set Bonus if acquired.'), 'Left-Click to set as Set Bonus.'
		end
	end		
	if name == 'close' then 
		sTitle, sText, sClickText = 'Close', ('Click to close the Current Item window.  Your current bid settings will be saved if you return to this window again.'), 'Left-Click to Close.'	
	end	
	if name == 'cancel' then 
		sTitle, sText, sClickText = 'Cancel Bid', ('Click to Cancel your bid.'), 'Left-Click to Cancel.'	
	end	
	if name == 'config' then 
		sTitle, sText, sClickText = 'Config', ('NOT YET IMPLEMENTED.')
	end			
	return sTitle, sClickText, sText
end
function kAuction:Gui_HideCurrentItem()
	kAuctionCurrentItemFrame:Hide();
end
function kAuction:Gui_SetCurrentItemIconTooltipStrings(frame, title, text, clickText)	
	if not title or not text then return nil end
	self:Gui_SetFrameBackdropColor(frame:GetParent(),0.9,0.9,0.9,0.1);
	GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
	GameTooltip:ClearLines();
	GameTooltip:SetPoint("BOTTOMRIGHT", kAuctionCurrentItemFrame, "TOPRIGHT");
	GameTooltip:SetPoint("BOTTOMLEFT", kAuctionCurrentItemFrame, "TOPLEFT");
	GameTooltip:AddLine(("|cFF%s%s|r"):format(self.colorHex['orange'], title));
	GameTooltip:AddLine(("|cFF%s%s|r"):format(self.colorHex['white'], text), _, _, _, true);
	if clickText then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(("|cFF%s%s|r"):format(self.colorHex['gold'], clickText));
	end
	GameTooltip:Show();
	GameTooltip:SetWidth(kAuctionCurrentItemFrame:GetWidth())
	frame:SetScript("OnLeave", function(widget,event,val)
		GameTooltip:Hide();
		self:Gui_SetFrameBackdropColor(widget:GetParent(),0,0,0,0);
	end);	
end
function kAuction:Gui_ShowCurrentItem()
	kAuctionCurrentItemFrame:Show();
end
function kAuction:Gui_UpdateCurrentItemIcons(frame, objAuction)
	local cancel = _G[frame:GetName().."Cancel"];
	local bestInSlot = _G["kAuctionCurrentItemFrameTitleBestInSlot"];
	local setBonus = _G["kAuctionCurrentItemFrameTitleSetBonus"];
	local bidType = _G["kAuctionCurrentItemFrameTitleBidTypeText"];
	local statusText = _G["kAuctionCurrentItemFrameItemContainerText"];
	local itemText = _G[frame:GetName().."ItemNameText"];
	local itemIcon = _G[frame:GetName().."CurrentItem"];
	local localAuctionData = self:Client_GetLocalAuctionDataById(objAuction.id);
	cancel:Hide();
	-- reset backdrop
	frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});			
	kAuction:Gui_SetFrameBackdropColor(frame,0,0,0,0);	
	if localAuctionData.bid and localAuctionData.itemLink then
		if localAuctionData.currentItemLink == frame.itemLink then
			-- Update anchors
			
			-- Update backdrop
			kAuction:Gui_SetFrameBackdropColor(frame,0,1,0.2,0.15);	
			cancel:Show();
		end
	end
	-- Setup icon states
	if localAuctionData.bidType then
		if localAuctionData.bidType == 'normal' then
			bidType:SetTextColor(0,1,0)
			bidType:SetText("Mainspec")
		elseif localAuctionData.bidType == 'offspec' then
			bidType:SetTextColor(1,1,0)
			bidType:SetText("Offspec")
		elseif localAuctionData.bidType == 'rot' then
			bidType:SetTextColor(1,0,0)
			bidType:SetText("Rot")
		end
	else
		bidType:SetTextColor(0,1,0)
		bidType:SetText("Mainspec")
	end
	if localAuctionData.bid then
		statusText:SetText("Bid submitted!")
	else
		statusText:SetText("Bid by selecting the item you wish to replace.")
	end
	if localAuctionData.bestInSlot then
		bestInSlot:SetHighlightTexture([[Interface\AddOns\kAuction\Images\Textures\medal2-grey]])
		bestInSlot:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\medal2]])
	else
		bestInSlot:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\medal2-grey]])
		bestInSlot:SetHighlightTexture([[Interface\AddOns\kAuction\Images\Textures\medal2]])			
	end
	if localAuctionData.setBonus then
		setBonus:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\shield-blue]])
		setBonus:SetHighlightTexture([[Interface\AddOns\kAuction\Images\Textures\shield-red]])
	else
		setBonus:SetNormalTexture([[Interface\AddOns\kAuction\Images\Textures\shield-red]])
		setBonus:SetHighlightTexture([[Interface\AddOns\kAuction\Images\Textures\shield-blue]])						
	end
	local time = kAuction:GetAuctionTimeleft(objAuction);
	local states = kAuction:GetAuctionStateArray(objAuction);
	local texture = kAuction:Item_GetTextureOfItem(frame.itemLink);
	itemIcon:SetNormalTexture(texture)
end
function kAuction:Gui_UpdateCurrentItemScroll()
	local frame = kAuctionCurrentItemFrame;
	local auction, matches, i = frame.auction, frame.matchTable, 1;
	local scrollHeight = kAuctionCurrentItemFrameScrollContainer:GetHeight();
	local itemFrameCount = floor((scrollHeight / kAuction.currentItemWidgetHeight) + 0.5) or 1;
	-- Check for matches
	if matches and #matches > 0 then
		local line, lineplusoffset;
		-- Manual hack to properly set offset
		FauxScrollFrame_SetOffset(kAuctionCurrentItemFrameScrollContainerScrollFrame, floor((kAuctionCurrentItemFrameScrollContainerScrollFrameScrollBar:GetValue() / kAuction.currentItemWidgetHeight) + 0.5))
		FauxScrollFrame_Update(kAuctionCurrentItemFrameScrollContainerScrollFrame,#matches,itemFrameCount,kAuction.currentItemWidgetHeight);
		for line=1,itemFrameCount do
			lineplusoffset = line + FauxScrollFrame_GetOffset(kAuctionCurrentItemFrameScrollContainerScrollFrame);
			if lineplusoffset <= #matches then
				local itemFrame = _G["kAuctionCurrentItemFrameScrollContainerCurrentItem"..line];
				itemFrame.itemLink = matches[lineplusoffset]
				local fNameText = _G["kAuctionCurrentItemFrameScrollContainerCurrentItem"..line.."ItemNameText"];
				fNameText:SetText(GetItemInfo(matches[lineplusoffset]))
				fNameText:SetTextColor(kAuction:Item_GetColor(matches[lineplusoffset]))
				fNameText:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.main.font), 10);		
				kAuction:Gui_UpdateCurrentItemIcons(itemFrame,auction)
				itemFrame:Show();
			else
				_G["kAuctionCurrentItemFrameScrollContainerCurrentItem"..line]:Hide();
			end
		end
	end
end