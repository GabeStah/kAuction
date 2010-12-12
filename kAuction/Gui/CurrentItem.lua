local sharedMedia = kAuction.sharedMedia
-- EVENTS
function kAuction:Gui_OnEnterCurrentItem(frame)
	kAuction:Gui_ShowItemTooltip(frame, frame.itemLink)
end
function kAuction:Gui_OnEnterCurrentItemIcon(frame)
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

function kAuction:Gui_Attach(anchorPoint, parent, relativePoint, xOffset, yOffset)
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
		kAuctionCurrentItemFrame:SetPoint(anchorPoint, parent, relativePoint, xOffset + arrowWidth, yOffset)
		if anchorPoint == 'BOTTOMLEFT' then
			kAuctionCurrentItemFrame:SetPoint(anchorPoint, parent, relativePoint, xOffset + arrowWidth, yOffset - kAuctionCurrentItemFrame:GetHeight() / 2)
			fArrow:SetPoint('BOTTOMRIGHT', fArrow:GetParent(), 'BOTTOMLEFT', 0, (kAuctionCurrentItemFrame:GetHeight() / 2) - (fArrow:GetHeight() / 2))
		elseif anchorPoint == 'BOTTOMRIGHT' then
			kAuctionCurrentItemFrame:SetPoint(anchorPoint, parent, relativePoint, xOffset + arrowWidth, yOffset + kAuctionCurrentItemFrame:GetHeight() / 2)
			fArrow:SetPoint('BOTTOMRIGHT', fArrow:GetParent(), 'BOTTOMLEFT', 0, (kAuctionCurrentItemFrame:GetHeight() / 2) - (fArrow:GetHeight() / 2))
		else
			kAuctionCurrentItemFrame:SetPoint(anchorPoint, parent, relativePoint, xOffset + arrowWidth, yOffset)
			fArrow:SetPoint(anchorPoint, parent, relativePoint, xOffset, yOffset)
		end		
	elseif anchorPoint == 'RIGHT' or anchorPoint == 'BOTTOMRIGHT' or anchorPoint == 'TOPRIGHT' then
		fArrow:SetSize(arrowWidth, arrowHeight)
		fGlowIcon:SetSize(arrowWidth, arrowHeight)
		fArrowIcon:SetTexCoord(0.99218750, 0.54687500, 0.78515625, 0.54687500, 0.99218750, 0.58789063, 0.78515625, 0.58789063)
		fGlowIcon:SetTexCoord(0.66015625, 0.77343750, 0.40625000, 0.77343750, 0.66015625, 0.82812500, 0.40625000, 0.82812500)
		if anchorPoint == 'BOTTOMRIGHT' then
			kAuctionCurrentItemFrame:SetPoint(anchorPoint, parent, relativePoint, xOffset - arrowWidth, yOffset - kAuctionCurrentItemFrame:GetHeight() / 2)
			fArrow:SetPoint('BOTTOMLEFT', fArrow:GetParent(), 'BOTTOMRIGHT', 0, (kAuctionCurrentItemFrame:GetHeight() / 2) - (fArrow:GetHeight() / 2))
		elseif anchorPoint == 'TOPRIGHT' then
			kAuctionCurrentItemFrame:SetPoint(anchorPoint, parent, relativePoint, xOffset - arrowWidth, yOffset + kAuctionCurrentItemFrame:GetHeight() / 2)
			fArrow:SetPoint('BOTTOMLEFT', fArrow:GetParent(), 'BOTTOMRIGHT', 0, (kAuctionCurrentItemFrame:GetHeight() / 2) - (fArrow:GetHeight() / 2))
		else
			kAuctionCurrentItemFrame:SetPoint(anchorPoint, parent, relativePoint, xOffset - arrowWidth, yOffset)
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
function kAuction:Gui_ShowCurrentItemFrame(auction, parent)
	local frame = kAuctionCurrentItemFrame;
	local auctionIcon = kAuctionCurrentItemFrameItemContainerIcon;
	-- Set retrievable auction data
	frame.auction = auction;
	auctionIcon:SetNormalTexture(kAuction:Item_GetTextureOfItem(auction.itemLink));
	frame.matchTable = kAuction:Item_GetInventoryItemMatchTable(auction.currentItemSlot)
	-- Test attach arrow
	--kAuction:Gui_Attach('BOTTOMLEFT', _G[parent:GetParent():GetName()..'Close'], 'RIGHT', 0, 0)
	kAuction:Gui_Attach('BOTTOMRIGHT', parent, 'LEFT', 0, 0)
	if frame:IsVisible() then
		kAuction:Gui_UpdateCurrentItemScroll(frame)
	else
		frame:Show();
	end
end
function kAuction:Gui_UpdateCurrentItemIcons(frame, objAuction)
	local close = _G[frame:GetName().."Close"];
	local itemIcon = _G[frame:GetName().."CurrentItem"];
	local localAuctionData = self:Client_GetLocalAuctionDataById(objAuction.id);
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