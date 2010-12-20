local sharedMedia = kAuction.sharedMedia
function kAuction:Gui_OnEnterItemsWonAnchorIcon(frame)
	sTitle, sClickText, sText = self:Gui_GetItemsWonIconStrings('anchor')		
	kAuction:Gui_SetItemsWonIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterItemsWonCloseIcon(frame)
	sTitle, sClickText, sText = self:Gui_GetItemsWonIconStrings('close')		
	kAuction:Gui_SetItemsWonIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterItemsWonItem(frame)
	kAuction:Gui_ShowItemTooltip(frame, frame.itemLink)
end
function kAuction:Gui_OnEnterItemsWonItemGraphic(frame)
	kAuction:Gui_ShowItemTooltip(frame, frame:GetParent().itemLink)
end
function kAuction:Gui_OnEnterItemsWonItemNameText(frame)
	kAuction:Gui_ShowItemTooltip(frame:GetParent(), frame:GetParent().itemLink)
end

function kAuction:Gui_AttachItemsWonFrame(anchorPoint, parent, relativePoint, xOffset, yOffset, itemCount)
	local f = kAuctionItemsWonFrame;
	local fArrow = kAuctionItemsWonFrameArrow;
	local fGlow = kAuctionItemsWonFrameGlow;
	local fArrowIcon = kAuctionItemsWonFrameArrowArrow;
	local fGlowIcon = kAuctionItemsWonFrameArrowGlow;
	local arrowWidth = 21;
	local arrowHeight = 53;
	fArrowIcon:SetAllPoints(true)
	f:ClearAllPoints()
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	local titleFrame = kAuctionItemsWonFrameTitle;
	f:SetSize(200,titleFrame:GetHeight() + (kAuction.itemsWonWidgetHeight * itemCount) + 5)
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
		fArrow:SetPoint('BOTTOM', fArrow:GetParent(), 'TOP', 0, 0)		
		f:SetPoint(anchorPoint, parent, relativePoint, xOffset, yOffset - arrowWidth)
	elseif anchorPoint == 'BOTTOM' then
		fArrow:SetSize(arrowHeight, arrowWidth)
		fGlowIcon:SetSize(arrowHeight, arrowWidth)
		fArrowIcon:SetTexCoord(0.78515625, 0.54687500, 0.78515625, 0.58789063, 0.99218750, 0.54687500, 0.99218750, 0.58789063)
		fGlowIcon:SetTexCoord(0.40625000, 0.77343750, 0.40625000, 0.82812500, 0.66015625, 0.77343750, 0.66015625, 0.82812500)
		--f:SetPoint(anchorPoint, parent, relativePoint, xOffset - arrowWidth, yOffset - f:GetHeight() / 2)
		fArrow:SetPoint('TOP', fArrow:GetParent(), 'BOTTOM', 0, 0)		
		f:SetPoint(anchorPoint, parent, relativePoint, xOffset, yOffset + arrowWidth)
	end
end
function kAuction:Gui_CreateItemsWonFrame(parent, matchTable, player)
	local frame = kAuctionItemsWonFrame;
	-- Set retrievable auction data
	frame.active = true;
	frame.anchorFrame = parent;
	frame.player = player;
	frame.matchTable = matchTable;
	if frame:IsVisible() then
		kAuction:Gui_UpdateItemsWonScroll()
	else
		if self.db.profile.gui.frames.itemsWon.anchorSide == 'BOTTOM' then
			kAuction:Gui_AttachItemsWonFrame('BOTTOM', frame.anchorFrame, 'TOP', 0, 0, #matchTable)
		elseif self.db.profile.gui.frames.itemsWon.anchorSide == 'TOP' then
			kAuction:Gui_AttachItemsWonFrame('TOP', frame.anchorFrame, 'BOTTOM', 0, 0, #matchTable)
		end
		kAuction:Gui_ShowItemsWonFrame()
	end
end
function kAuction:Gui_GetItemsWonIconStrings(name,localAuction)
	local sTitle, sClickText, sText;
	if name == 'anchor' then
		sTitle, sText, sClickText = 'Toggle Anchor', ('Click to toggle the Anchor Side.'), 'Left-Click to toggle anchor.'	
	end
	if name == 'close' then 
		sTitle, sText, sClickText = 'Close', ('Click to close the Items Won window.'), 'Left-Click to Close.'	
	end	
	return sTitle, sClickText, sText
end
function kAuction:Gui_HideItemsWonFrame()
	kAuctionItemsWonFrame:Hide();
end
function kAuction:Gui_ShowItemsWonFrame()
	kAuctionItemsWonFrame:Show();
end
function kAuction:Gui_SetItemsWonIconTooltipStrings(frame, title, text, clickText)	
	if not title or not text then return nil end
	self:Gui_SetFrameBackdropColor(frame:GetParent(),0.9,0.9,0.9,0.1);
	GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
	GameTooltip:ClearLines();
	GameTooltip:SetPoint("BOTTOMRIGHT", kAuctionItemsWonFrame, "TOPRIGHT");
	GameTooltip:SetPoint("BOTTOMLEFT", kAuctionItemsWonFrame, "TOPLEFT");
	GameTooltip:AddLine(("|cFF%s%s|r"):format(self.colorHex['orange'], title));
	GameTooltip:AddLine(("|cFF%s%s|r"):format(self.colorHex['white'], text), _, _, _, true);
	if clickText then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(("|cFF%s%s|r"):format(self.colorHex['gold'], clickText), _, _, _, true);
	end
	GameTooltip:Show();
	frame:SetScript("OnLeave", function(widget,event,val)
		GameTooltip:Hide();
		self:Gui_SetFrameBackdropColor(widget:GetParent(),0,0,0,0);
	end);	
end
function kAuction:Gui_UpdateItemsWonIcons(frame, objAuction, match)
	local itemText = _G[frame:GetName().."ItemNameText"];
	local itemIcon = _G[frame:GetName().."Item"];
	-- reset backdrop
	if match.bidType then
		if match.bidType == 'normal' then
			itemText:SetTextColor(0.5,1,0,1)
			--kAuction:Gui_SetFrameBackdropColor(frame,0.5,1,0,1);	
		elseif match.bidType == 'offspec' then
			itemText:SetTextColor(1,0.75,0,0.9)
			--kAuction:Gui_SetFrameBackdropColor(frame,1,0.75,0,0.9);	
		elseif match.bidType == 'rot' then
			itemText:SetTextColor(0.8,0.15,0.15,0.9)
			--kAuction:Gui_SetFrameBackdropColor(frame,0.8,0.15,0.15,0.9);	
		end
	else
		itemText:SetTextColor(0.5,1,0,1)
		--kAuction:Gui_SetFrameBackdropColor(frame,0.5,1,0,1);
	end
	local texture = kAuction:Item_GetTextureOfItem(frame.itemLink);
	itemIcon:SetNormalTexture(texture)
end
function kAuction:Gui_UpdateItemsWonScroll()
	local frame = kAuctionItemsWonFrame;
	local matches, i = frame.matchTable, 1;
	local scrollHeight = kAuctionItemsWonFrameScrollContainer:GetHeight();
	local itemFrameCount = floor((scrollHeight / kAuction.itemsWonWidgetHeight) + 0.5) or 1;
	-- Check for matches
	if matches and #matches > 0 then
		local line, lineplusoffset;
		-- Manual hack to properly set offset
		FauxScrollFrame_SetOffset(kAuctionItemsWonFrameScrollContainerScrollFrame, floor((kAuctionItemsWonFrameScrollContainerScrollFrameScrollBar:GetValue() / kAuction.itemsWonWidgetHeight) + 0.5))
		FauxScrollFrame_Update(kAuctionItemsWonFrameScrollContainerScrollFrame,#matches,itemFrameCount,kAuction.itemsWonWidgetHeight);
		for line=1,itemFrameCount do
			kAuction:Debug("Gui_UpdateItemsWonScroll, Matches: "..#matches..", line: " .. line, 1)
			lineplusoffset = line + FauxScrollFrame_GetOffset(kAuctionItemsWonFrameScrollContainerScrollFrame);
			local itemFrame = _G["kAuctionItemsWonFrameScrollContainerItem"..line];
			if lineplusoffset <= #matches then
				itemFrame.itemLink = matches[lineplusoffset].itemLink
				local fNameText = _G["kAuctionItemsWonFrameScrollContainerItem"..line.."ItemNameText"];
				fNameText:SetText(GetItemInfo(matches[lineplusoffset].itemLink))
				fNameText:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.main.font), 10);		
				-- TODO: Finish ItemsWon menu display, such as item tooltips and icons
				kAuction:Gui_UpdateItemsWonIcons(itemFrame,auction,matches[lineplusoffset])
				itemFrame:Show();
			else
				itemFrame:Hide();
			end
		end
	end
end