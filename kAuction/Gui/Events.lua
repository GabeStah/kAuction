
function kAuction:Gui_OnEnterCurrentItem(frame)
	kAuction:Debug("ON ENTER ID:"..frame:GetParent():GetID(), 1)
	kAuction:Gui_ShowItemTooltip(frame, frame:GetParent().itemLink)
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
				kAuction:Gui_OnClickAuctionBidButton(auction, "normal")
			end
		elseif button == 'RightButton' then
			kAuction:Gui_CreateAuctionItemDropdown(auction, widget)
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
function kAuction:Gui_OnEnterCurrentItemContainerIcon(frame)
	local auction = frame:GetParent():GetParent().auction;
	kAuction:Gui_ShowItemTooltip(frame, auction.itemLink)
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
function kAuction:Gui_OnEnterBidRoll(frame)
	offset = FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
	local _, _, line = string.find(frame:GetName(), "(%d+)");
	local auction = self.auctions[self.selectedAuctionIndex];
	--kAuction:Gui_OnLeaveBidRoll(nil);
	--kAuction:Gui_OnLeaveBidItemsWon(nil);
	local tip = self.qTip:Acquire("GameTooltip", 4, "LEFT", "LEFT", "RIGHT", "RIGHT")	
	if auction.auctionType == 2 and (auction.visiblePublicBidVoters or kAuction:Client_IsServer() or kAuction:IsLootCouncilMember(auction)) then
		local bid = self.auctions[self.selectedAuctionIndex].bids[offset + line];
		local rollFrame = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."Roll"];
		kAuction:Debug("FUNC: Gui_OnEnterBidRoll, Hovering.", 1);
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
function kAuction:Gui_OnLeaveBidRoll(frame)
	--self.qTip:Release();
	local tip = self.qTip:Acquire("GameTooltip");
	tip:Hide();
end
function kAuction:Gui_OnLeaveBidItemsWon(frame)
	local tip = self.qTip:Acquire("GameTooltip");
	tip:Hide();
end