function kAuction:Gui_ShowCurrentItemFrame(auction)
	local frame = kAuctionCurrentItemFrame;
	local auctionIcon = kAuctionCurrentItemFrameItemContainerIcon;
	-- Set retrievable auction data
	frame.auction = auction;
	auctionIcon:SetNormalTexture(kAuction:Item_GetTextureOfItem(auction.itemLink));
	frame.matchTable = kAuction:Item_GetInventoryItemMatchTable(auction.currentItemSlot)
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
	local itemFrameCount = floor(scrollHeight / kAuction.currentItemWidgetHeight) or 1;
	kAuction:Debug('Gui_UpdateCurrentItemScroll: '.. #matches .. ' matches, itemFrameCount: '..itemFrameCount, 1)
	-- TODO: Determine why FauxScrollOffset is incorrect during scrolling/update, but queried afterward is correct
	-- Check for matches
	if matches and #matches > 0 then
		local line; -- 1 through 5 of our window to scroll
		local lineplusoffset; -- an index into our data calculated from the scroll offset
		FauxScrollFrame_Update(kAuctionCurrentItemFrameScrollContainerScrollFrame,#matches,itemFrameCount,kAuction.currentItemWidgetHeight);
		for line=1,itemFrameCount do
			kAuction:Debug("CurrentItemScrollUpdate: Line: "..line, 1)
			local offset = FauxScrollFrame_GetOffset(kAuctionCurrentItemFrameScrollContainerScrollFrame);
			kAuction:Debug("CurrentItemScrollUpdate: offset: "..offset, 1)
			lineplusoffset = line + offset;
			kAuction:Debug("CurrentItemScrollUpdate: lineplusoffset: "..lineplusoffset, 1)
			if lineplusoffset <= #matches then
				local itemFrame = _G["kAuctionCurrentItemFrameScrollContainerCurrentItem"..line];
				itemFrame.itemLink = matches[lineplusoffset]
				itemFrame:Show();
				local fNameText = _G["kAuctionCurrentItemFrameScrollContainerCurrentItem"..line.."ItemNameText"];
				fNameText:SetText(GetItemInfo(matches[lineplusoffset]))
				fNameText:SetTextColor(kAuction:Item_GetColor(matches[lineplusoffset]))
				fNameText:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.main.font), 10);		
				kAuction:Gui_UpdateCurrentItemIcons(itemFrame,auction)
			else
				_G["kAuctionCurrentItemFrameScrollContainerCurrentItem"..line]:Hide();
			end
		end
	end
	kAuction:Debug("CURRENT ITEM OFFSET: "..FauxScrollFrame_GetOffset(kAuctionCurrentItemFrameScrollContainerScrollFrame), 1)
end