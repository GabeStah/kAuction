--- EVENTS ---
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
	kAuctionItemsWonFrame:Hide();
	kAuction:Gui_HookFrameRefreshUpdate();
end
--- EVENTS END

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
function kAuction:Gui_GetSelectedTab()
	for iTab,vTab in pairs(self.auctionTabs) do
		if vTab.selected then
			return true;
		end
	end
	return false;
end
function kAuction:Gui_GetTabByAuctionId(id)
	for iTab,vTab in pairs(self.auctionTabs) do
		if vTab.auction.id == id then
			return vTab;
		end
	end
	return false;
end
function kAuction:Gui_IsAuctionInTabList(auction)
	for iTab,vTab in pairs(self.auctionTabs) do
		if vTab.auction.id == auction.id then
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
				tabFrame:SetScript("OnEnter", function(self) kAuction:Gui_OnEnterAuctionTab(vTab) end);
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