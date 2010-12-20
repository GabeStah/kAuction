function kAuction:Gui_OnEnterAuctionItem(frame)
	local _, _, number = string.find(frame:GetName(), "(%d+)");
	kAuction:Debug("FUNC: Gui_OnEnterAuctionItem, frame: " .. frame:GetName() .. ", number: " .. number, 3)
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
function kAuction:Gui_OnEnterAuctionTab(tab)
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
function kAuction:Gui_OnEnterBidIcon(frame)
	local offset, selectFrame = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local sTitle, sClickText, sText;
	local iIndex = offset + row;
	local auction = self.auctions[iIndex];
	local timeLeft = kAuction:GetAuctionTimeleft(auction);
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id);	
	local states = kAuction:GetAuctionStateArray(frame);
	sTitle, sClickText, sText = self:Gui_GetIconStrings(frame,'bid',states,auction,timeLeft,auction.winner)	
	frame:SetScript('OnMouseDown', function(widget,button)
		if button == 'LeftButton' then
			if states.auctionOpen and states.bid then
				kAuction:Gui_OnClickAuctionBidButton(auction, "none")
			elseif states.auctionOpen and states.noBid then
				-- Open currentitem tab
				kAuction:Gui_CreateCurrentItemFrame(auction)
			end
		end
	end);		
	-- Create tooltips
	kAuction:Gui_SetIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterCloseIcon(frame)
	local offset, selectFrame = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local sTitle, sClickText, sText;
	local iIndex = offset + row;
	local auction = self.auctions[iIndex];
	local timeLeft = kAuction:GetAuctionTimeleft(auction);
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id);	
	local states = kAuction:GetAuctionStateArray(frame);
	sTitle, sClickText, sText = self:Gui_GetIconStrings(frame,'close',states,auction,timeLeft,auction.winner)	
	-- Create tooltips
	kAuction:Gui_SetIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterStatusIcon(frame)
	local offset, selectFrame = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local sTitle, sClickText, sText;
	local iIndex = offset + row;
	local auction = self.auctions[iIndex];
	local timeLeft = kAuction:GetAuctionTimeleft(auction);
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id);	
	local states = kAuction:GetAuctionStateArray(frame);
	sTitle, sClickText, sText = self:Gui_GetIconStrings(frame,'status',states,auction,timeLeft,auction.winner)
	frame:SetScript('OnMouseDown', function(widget,button)
		kAuction:Gui_OnClickAuctionItem(widget:GetParent(),button)
	end);	
	-- Create tooltips
	kAuction:Gui_SetIconTooltipStrings(frame,sTitle,sText,sClickText)
end
function kAuction:Gui_OnEnterVoteIcon(frame)
	local offset, selectFrame = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local sTitle, sClickText, sText;
	local iIndex = offset + row;
	local auction = self.auctions[iIndex];
	local timeLeft = kAuction:GetAuctionTimeleft(auction);
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(auction.id);	
	local states = kAuction:GetAuctionStateArray(frame);
	sTitle, sClickText, sText = self:Gui_GetIconStrings(frame,'vote',states,auction,timeLeft,auction.winner)
	frame:SetScript('OnMouseDown', function(widget,button)
		kAuction:Gui_OnClickAuctionItem(widget:GetParent(),button)
	end);	
	-- Create tooltips
	kAuction:Gui_SetIconTooltipStrings(frame,sTitle,sText,sClickText)
end