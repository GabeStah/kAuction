local sharedMedia = kAuction.sharedMedia
-- EVENTS
function kAuction:Gui_OnClickItemsWonFrane(frame)
	local offset, selectFrame = FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
	kAuction:Debug("Gui_OnClickItemsWonFrane ON CLICk", 1)
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local sTitle, sClickText, sText;
	local iIndex = offset + row;
	local auction = self.auctions[self.selectedAuctionIndex]
	local bid = auction.bids[iIndex];
	-- Check if already visible with same name, then toggle off
	if kAuctionItemsWonFrame:IsVisible() and bid.name == kAuctionItemsWonFrame.player then
		kAuctionItemsWonFrame:Hide()
		return nil;
	end
	local matchTable = kAuction:Item_GetPlayerWonItemList(bid.name);
	kAuction:Gui_CreateItemsWonFrame(frame, matchTable, bid.name)
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
		tip:ClearAllPoints();
		tip:Clear();
		if self.db.profile.gui.frames.itemsWon.anchorSide == 'BOTTOM' then
			tip:SetPoint("TOP", frame, "BOTTOM", 0, 0);
		elseif self.db.profile.gui.frames.itemsWon.anchorSide == 'TOP' then
			tip:SetPoint("BOTTOM", frame, "TOP", 0, 0);
		end
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
		if self.db.profile.gui.frames.itemsWon.anchorSide == 'BOTTOM' then
			tip:SetPoint("TOP", frame, "BOTTOM", 0, 0);
		elseif self.db.profile.gui.frames.itemsWon.anchorSide == 'TOP' then
			tip:SetPoint("BOTTOM", frame, "TOP", 0, 0);
		end
		tip:AddHeader("Votes Hidden");
		tip:Show();
	elseif auction.auctionType == 1 then
		if auction.visiblePublicBidRolls or kAuction:Client_IsServer() or kAuction:IsLootCouncilMember(auction) then
			self.qTip:Release(self.qTip:Acquire("GameTooltip"));
		else
			local rollFrame = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."Roll"];
			tip:ClearAllPoints();
			tip:Clear();
			if self.db.profile.gui.frames.itemsWon.anchorSide == 'BOTTOM' then
				tip:SetPoint("TOP", frame, "BOTTOM", 0, 0);
			elseif self.db.profile.gui.frames.itemsWon.anchorSide == 'TOP' then
				tip:SetPoint("BOTTOM", frame, "TOP", 0, 0);
			end
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
function kAuction:Gui_OnEnterBidCurrentItemIcon(frame)
	kAuction:Gui_ShowItemTooltip(frame, frame.itemLink)
end
-- EVENTS END

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
function kAuction:Gui_CreateBidItemWonMenuButton(row,index,itemLink)
	local button
	if _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrameButton"..index] then
		button = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrameButton"..index];
	else
		button = CreateFrame("CheckButton",self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrameButton"..index,_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrame"..index],"ActionButtonTemplate")
	end
	button:SetChecked(false);
	button:SetScript("OnEnter",function() kAuction:Gui_OnEnterCurrentItemMenu(button,itemLink) end)
	button:SetScript("OnLeave",function() GameTooltip:Hide() end)
	_G[button:GetName().."Icon"]:SetTexture(kAuction:Item_GetTextureOfItem(itemLink))
	return button;
end
function kAuction:Gui_UpdateBidCurrentItemButtons(index, auction, bid)
	local frameCurrentItem = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..index.."CurrentItem"];
	local frameCurrentItemIcon = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..index.."CurrentItemIcon"];
	if (auction.visiblePublicBidCurrentItems or kAuction:Client_IsServer() or kAuction:IsLootCouncilMember(auction)) and auction.currentItemSlot then -- Equippable and .visiblePublicBidCurrentItems = true
		if bid.currentItemLink then
			frameCurrentItem:SetScript("OnEnter", function() kAuction:Gui_ShowItemTooltip(frameCurrentItem, bid.currentItemLink) end);
			frameCurrentItemIcon:SetTexture(kAuction:Item_GetTextureOfItem(bid.currentItemLink));
		else
			frameCurrentItem:SetScript("OnEnter", nil);
			frameCurrentItemIcon:SetTexture(kAuction:Item_GetEmptyPaperdollTextureOfItem(auction.itemLink) or kAuction:Item_GetEmptyPaperdollTextureOfItemSlot(auction.currentItemSlot));
		end
		frameCurrentItem:SetScript("OnLeave",function() GameTooltip:Hide() end)
	else
		frameCurrentItem:SetScript("OnEnter", nil);
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