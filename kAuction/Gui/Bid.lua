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
			frameCurrentItem:SetScript("OnEnter", function() kAuction:Gui_OnEnterCurrentItemMenu(frameCurrentItem, bid.currentItemLink) end);
			frameCurrentItemIcon:SetTexture(kAuction:Item_GetTextureOfItem(bid.currentItemLink));
		else
			frameCurrentItem:SetScript("OnEnter", function() end);
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