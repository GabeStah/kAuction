-- Create Mixins
local _G = _G

local kAuction = LibStub("AceAddon-3.0"):NewAddon("kAuction", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
_G.kAuction = kAuction
kAuction.menu = {};
kAuction.colorHex = {};
kAuction.timers = {};
kAuction.updates = {};
kAuction.updates[1] = 0;
kAuction.updates[2] = 0;
kAuction.currentZone = false;
local sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
kAuction.sharedMedia = sharedMedia
function kAuction:OnInitialize()
    -- Load Database
    self.db = LibStub("AceDB-3.0"):New("kAuctionDB", self.defaults)
    self.raidDb = LibStub("AceDB-3.0"):New("kAuctionRaidDB")
    -- Inject Options Table and Slash Commands
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kAuction", self.options, {"kauction", "ka"})
	self.dialog = LibStub("AceConfigDialog-3.0")
	self.AceGUI = LibStub("AceGUI-3.0")
	--self.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	self.effects = LibStub("LibEffects-1.0")
	--self.oo = LibStub("AceOO-2.0")
	self.qTip = LibStub("LibQTip-1.0")
	self:RegisterLibSharedMediaObjects();
	--self.tablet = LibStub("Tablet-2.0")
	--self.StatLogic = LibStub("LibStatLogic-1.1")
	-- Init Events
	self:InitializeEvents()
	-- Comm registry
	self:RegisterComm("kAuction")
	-- Frames
	self.selectedAuctionIndex = 0;
	self.auctions = {};	
	self.auctionTabs = {};
	self.localAuctionData = {};
	self:Gui_InitializePopups();
	self:Gui_InitializeFrames()
	self:Gui_HookFrameRefreshUpdate();
	self.playerName = UnitName("player");
	-- Menu
	self.menu = CreateFrame("Frame", "Test_DropDown", UIParent, "UIDropDownMenuTemplate");
	-- Init council list
	self:Server_InitializeCouncilMemberList();
end

function kAuction:InitializeEvents()
	self.enabled = false;
	self.isActiveRaid = false;
	self.isInRaid = false;
	kAuction:RegisterEvent("LOOT_OPENED");
	kAuction:RegisterEvent("LOOT_CLOSED");
	kAuction:RegisterEvent("UNIT_SPELLCAST_SENT");
	kAuction:RegisterEvent("RAID_ROSTER_UPDATE");
	kAuction:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	--kAuction:RegisterEvent("CHAT_MSG_WHISPER");
	
	-- Update
	_G[self.db.profile.gui.frames.main.name]:SetScript("OnUpdate", function(frame,elapsed) kAuction:OnUpdate(1, elapsed) end)
	-- Color Hex codes
	kAuction.colorHex['green'] = kAuction:RGBToHex(0,255,0);
	kAuction.colorHex['red'] = kAuction:RGBToHex(255,0,0);
	kAuction.colorHex['yellow'] = kAuction:RGBToHex(255,255,0);
	kAuction.colorHex['white'] = kAuction:RGBToHex(255,255,255,1);
	kAuction.colorHex['grey'] = kAuction:RGBToHex(128,128,128);
	kAuction.colorHex['orange'] = kAuction:RGBToHex(255,165,0);
	kAuction.colorHex['gold'] = kAuction:RGBToHex(175,150,0);
	kAuction.colorHex['test'] = kAuction:RGBToHex(100,255,0);
end
--[[
do
	local function kAuctionFilterOutgoing(self, event, ...)
		local msg = ...
		if not msg and self then
			return kAuctionFilterOutgoing(nil, nil, self, event)
		end
		-- Check for addon prefix, suppress automatically
		if string.find(msg, self.const.chatPrefix) then
			return true;
		end
		return false;
	end
	local function kAuctionFilterIncoming(self, event, ...)
		local msg = ...;
		if not msg and self then
			return kAuctionFilterIncoming(nil, nil, self, event)
		end		
		-- Check for addon prefix, suppress automatically
		if string.find(msg, self.const.chatPrefix) then
			return true;
		end
		if strlower(msg) == "kauction help" or strlower(msg) == "ka help" then
			return true;
		end
		if not self.db.profile.looting.auctionWhisperBidSuppressionEnabled or not self.db.profile.looting.auctionWhisperBidEnabled then
			return false;
		end
		local isBid, localAuctionData = kAuction:Gui_GetWhisperBidType(msg,true);
		if isBid then
			return true;
		end
		return false;
	end
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", kAuctionFilterOutgoing)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", kAuctionFilterOutgoing)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", kAuctionFilterIncoming)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", kAuctionFilterIncoming)
end
function kAuction:CHAT_MSG_WHISPER(event, msg, name)
	kAuction:Gui_OnWhisper(msg, name, false);
end
]]
function kAuction:RegisterLibSharedMediaObjects()
	-- Fonts
	sharedMedia:Register("font", "Adventure",	[[Interface\AddOns\kAuction\Fonts\Adventure.ttf]]);
	sharedMedia:Register("font", "Alba Super", [[Interface\AddOns\kAuction\Fonts\albas.ttf]]);
	sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kAuction\Fonts\CAS_ANTN.TTF]]);
	sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kAuction\Fonts\Cella.otf]]);
	sharedMedia:Register("font", "Chick", [[Interface\AddOns\kAuction\Fonts\chick.ttf]]);
	sharedMedia:Register("font", "Corleone",	[[Interface\AddOns\kAuction\Fonts\Corleone.ttf]]);
	sharedMedia:Register("font", "The Godfather",	[[Interface\AddOns\kAuction\Fonts\CorleoneDue.ttf]]);
	sharedMedia:Register("font", "Forte",	[[Interface\AddOns\kAuction\Fonts\Forte.ttf]]);
	sharedMedia:Register("font", "Freshbot", [[Interface\AddOns\kAuction\Fonts\freshbot.ttf]]);
	sharedMedia:Register("font", "Jokewood", [[Interface\AddOns\kAuction\Fonts\jokewood.ttf]]);
	sharedMedia:Register("font", "Sopranos",	[[Interface\AddOns\kAuction\Fonts\Mobsters.ttf]]);
	sharedMedia:Register("font", "Weltron Urban", [[Interface\AddOns\kAuction\Fonts\weltu.ttf]]);
	sharedMedia:Register("font", "Wild Ride", [[Interface\AddOns\kAuction\Fonts\WildRide.ttf]]);
	-- Sounds
	
	sharedMedia:Register("sound", "Alarm", [[Interface\AddOns\kAuction\Sounds\alarm.mp3]]);
	sharedMedia:Register("sound", "Alert", [[Interface\AddOns\kAuction\Sounds\alert.mp3]]);
	sharedMedia:Register("sound", "Info", [[Interface\AddOns\kAuction\Sounds\info.mp3]]);
	sharedMedia:Register("sound", "Long", [[Interface\AddOns\kAuction\Sounds\long.mp3]]);
	sharedMedia:Register("sound", "Shot", [[Interface\AddOns\kAuction\Sounds\shot.mp3]]);
	sharedMedia:Register("sound", "Sonar", [[Interface\AddOns\kAuction\Sounds\sonar.mp3]]);
	sharedMedia:Register("sound", "Victory", [[Interface\AddOns\kAuction\Sounds\victory.mp3]]);
	sharedMedia:Register("sound", "Victory Classic", [[Interface\AddOns\kAuction\Sounds\victoryClassic.mp3]]);
	sharedMedia:Register("sound", "Victory Long", [[Interface\AddOns\kAuction\Sounds\victoryLong.mp3]]);
	sharedMedia:Register("sound", "Wilhelm", [[Interface\AddOns\kAuction\Sounds\wilhelm.mp3]]);

	-- Sounds, Worms
	sharedMedia:Register("sound", "Worms - Angry Scot Come On Then", [[Interface\AddOns\kAuction\Sounds\wangryscotscomeonthen.wav]]);
	sharedMedia:Register("sound", "Worms - Angry Scot Coward", [[Interface\AddOns\kAuction\Sounds\wangryscotscoward.wav]]);
	sharedMedia:Register("sound", "Worms - Angry Scot I'll Get You", [[Interface\AddOns\kAuction\Sounds\wangryscotsillgetyou.wav]]);
	sharedMedia:Register("sound", "Worms - Sargeant Fire", [[Interface\AddOns\kAuction\Sounds\wdrillsargeantfire.wav]]);
	sharedMedia:Register("sound", "Worms - Sargeant Stupid", [[Interface\AddOns\kAuction\Sounds\wdrillsargeantstupid.wav]]);
	sharedMedia:Register("sound", "Worms - Sargeant Watch This", [[Interface\AddOns\kAuction\Sounds\wdrillsargeantwatchthis.wav]]);
	sharedMedia:Register("sound", "Worms - Grandpa Coward", [[Interface\AddOns\kAuction\Sounds\wgrandpacoward.wav]]);
	sharedMedia:Register("sound", "Worms - Grandpa Uh Oh", [[Interface\AddOns\kAuction\Sounds\wgrandpauhoh.wav]]);
	sharedMedia:Register("sound", "Worms - I'll Get You", [[Interface\AddOns\kAuction\Sounds\willgetyou.wav]]);
	sharedMedia:Register("sound", "Worms - Uh Oh", [[Interface\AddOns\kAuction\Sounds\wuhoh.wav]]);
	-- Drum
	sharedMedia:Register("sound", "Snare1", [[Interface\AddOns\kAuction\Sounds\snare1.mp3]]);
	-- Icons
	sharedMedia:Register("texture", "user-mystery", [[Interface\AddOns\kAuction\Images\Textures\user-mystery.tga]]);
	sharedMedia:Register("texture", "user-add", [[Interface\AddOns\kAuction\Images\Textures\user-add.tga]]);
	sharedMedia:Register("texture", "user-check", [[Interface\AddOns\kAuction\Images\Textures\user-check.tga]]);
	sharedMedia:Register("texture", "user-delete", [[Interface\AddOns\kAuction\Images\Textures\user-delete.tga]]);
	sharedMedia:Register("texture", "star", [[Interface\AddOns\kAuction\Images\Textures\star.tga]]);
	sharedMedia:Register("texture", "star-half", [[Interface\AddOns\kAuction\Images\Textures\star-half.tga]]);
	sharedMedia:Register("texture", "star-none", [[Interface\AddOns\kAuction\Images\Textures\star-none.tga]]);
	sharedMedia:Register("texture", "star2-full", [[Interface\AddOns\kAuction\Images\Textures\star2-full.tga]]);
	sharedMedia:Register("texture", "star2-half", [[Interface\AddOns\kAuction\Images\Textures\star2-half.tga]]);
	sharedMedia:Register("texture", "star2-empty", [[Interface\AddOns\kAuction\Images\Textures\star2-empty.tga]]);
	sharedMedia:Register("texture", "clock", [[Interface\AddOns\kAuction\Images\Textures\clock.tga]]);
	sharedMedia:Register("texture", "clockdark", [[Interface\AddOns\kAuction\Images\Textures\clockdark.tga]]);
	sharedMedia:Register("texture", "x", [[Interface\AddOns\kAuction\Images\Textures\x.tga]]);
	sharedMedia:Register("texture", "check", [[Interface\AddOns\kAuction\Images\Textures\check.tga]]);
	sharedMedia:Register("texture", "exclaim", [[Interface\AddOns\kAuction\Images\Textures\exclaim.tga]]);
	sharedMedia:Register("texture", "xdark", [[Interface\AddOns\kAuction\Images\Textures\xdark.tga]]);
end

function kAuction:OnEnable()
	if kAuction:Client_IsServer() then
		if GetNumRaidMembers() > 0 then
			self.isInRaid = true;
			kAuction:SendCommunication("RaidServer");
			if kAuction:Server_IsInValidRaidZone() then -- Check for valid zone
				StaticPopup_Show("kAuctionPopup_StartRaidTracking");
			end
			kAuction:Debug("FUNC: OnEnable, ClientIsServer = true, raid exists, enabled = true.", 1)
		else
			kAuction:Debug("FUNC: OnEnable, ClientIsServer = true, raid doesn't exist, enabled = false.", 1)
		end
	else
		if GetNumRaidMembers() > 0 then
			self.isInRaid = true;
			kAuction:SendCommunication("RaidHasServer", nil);
			kAuction:Debug("FUNC: OnEnable, ClientIsServer = false, raid exists, RaidHasServer comm sent.", 1)
		else
			kAuction:Debug("FUNC: OnEnable, ClientIsServer = false, raid doesn't exist, enabled = false.", 1)
		end
	end
end
function kAuction:OnDisable()
    -- Called when the addon is disabled
end
function kAuction:LOOT_CLOSED()
	kAuction:Debug("EVENT: LOOT_CLOSED", 3)
	self.isLooting = false;
end
function kAuction:LOOT_OPENED()
	kAuction:Debug("EVENT: LOOT_OPENED", 3)
	self.isLooting = true;
	if self.enabled and self.isActiveRaid and GetNumRaidMembers() > 0 and kAuction:Client_IsServer() then -- Player in raid and raid leader
		local guid = UnitGUID("target") -- NPC Looted
		local corpseName = UnitName("target");
		if not guid then -- Else Container Looted
			guid = self.guids.lastObjectOpened;
			corpseName = self.guids.lastObjectOpened;
		end			
		if kAuction:Server_HasCorpseBeenAuctioned(guid) == false then -- Check if corpse auctioned already.
			kAuction:Server_SetCorpseAsAuctioned(guid) -- Mark corpse as auctioned		
			for i = 1, GetNumLootItems() do
				if (LootSlotIsItem(i)) then
					if self.db.profile.looting.isAutoAuction then
						kAuction:Server_AuctionItem(GetLootSlotLink(i), guid, corpseName)
					end
				end
			end		
		end		
	end
end
function kAuction:RAID_ROSTER_UPDATE()
	-- Client just joined a raid.
	if self.isInRaid == false and GetNumRaidMembers() > 0 then
		self.hasRunVersionCheck = false;
		self.isInRaid = true;
		-- Check if Server, and valid zone
		if kAuction:Client_IsServer() then
			kAuction:SendCommunication("RaidServer");
			if kAuction:Server_IsInValidRaidZone() then -- Check for valid zone
				StaticPopup_Show("kAuctionPopup_StartRaidTracking");
			end
		else
			kAuction:SendCommunication("RaidHasServer", nil);
		end
		kAuction:Debug("FUNC: RAID_ROSTER_UPDATE - Client just joined a raid.", 1);
	-- Client just left a raid.
	elseif self.isInRaid == true and isActiveRaid == true and GetNumRaidMembers() == 0 then
		self.hasRunVersionCheck = false;
		self.isInRaid = false;
		-- Check if Server
		if kAuction:Client_IsServer() then
			StaticPopup_Show("kAuctionPopup_StopRaidTracking");
		end
		kAuction:Debug("FUNC: RAID_ROSTER_UPDATE - Client just left a raid.", 1);
	end
end
function kAuction:UNIT_SPELLCAST_SENT(blah, unit, spell, rank, target)
	if spell == "Opening" then
		self.guids.lastObjectOpened = target;
		kAuction:Debug("FUNC: UNIT_SPELLCAST_SENT, target: " .. target .. ", spell: " .. spell, 3)
	end
end
function kAuction:SendCommunication(command, data, priority)
	local prio = 'NORMAL'
	if priority then
		if priority == 1 then
			prio = 'BULK'
		elseif priority == 3 then
			prio = 'ALERT'
		end
	end
	kAuction:SendCommMessage("kAuction", kAuction:Serialize(command, data), "RAID", nil, prio)
end
function kAuction:OnCommReceived(prefix, serialObject, distribution, sender)
	kAuction:Debug("FUNC: OnCommReceived, FIRE", 3)
	local success, command, data = kAuction:Deserialize(serialObject)
	if success then
		if prefix == "kAuction" and distribution == "RAID" then
			if (command == "Auction" and kAuction:IsPlayerRaidLeader(sender)) then
				kAuction:Client_AuctionReceived(data);
			end
			if (command == "AuctionDelete" and kAuction:IsPlayerRaidLeader(sender)) then
				kAuction:Client_AuctionDeleteReceived(sender, data);
			end
			if (command == "AuctionWinner" and kAuction:IsPlayerRaidLeader(sender)) then
				kAuction:Client_AuctionWinnerReceived(sender, data);
			end
			if (command == "Bid") then
				kAuction:Client_BidReceived(sender, data);
			end
			if (command == "BidCancel") then
				kAuction:Client_BidCancelReceived(sender, data);
			end
			if (command == "BidVote") then
				kAuction:Client_BidVoteReceived(sender, data);
			end
			if (command == "BidVoteCancel") then
				kAuction:Client_BidVoteCancelReceived(sender, data);
			end
			if (command == "DataUpdate") then
				kAuction:Client_DataUpdateReceived(sender, data);
				-- Update Raid DB Xml
				if kAuction:Client_IsServer() then
					kAuction:Server_UpdateRaidDb();
				end				
			end
			if (command == "RaidEnd") and kAuction:IsPlayerRaidLeader(sender) then
				self.auctions = {};	
				self.auctionTabs = {};
			end			
			if (command == "RaidHasServer") then
				kAuction:Server_RaidHasServerReceived(sender);
			end
			if (command == "RaidServer") then
				kAuction:Client_RaidServerReceived(sender);
			end
			if (command == "RequestAuraCancel") then
				kAuction:Client_AuraCancelReceived(sender, data);
			end
			if (command == "RequestAuraEnable") then
				kAuction:Client_AuraEnableReceived(sender, data);
			end
			if (command == "RequestAuraDisable") then
				kAuction:Client_AuraDisableReceived(sender, data);
			end
			if (command == "Version") then
				kAuction:Server_VersionReceived(sender, data);
			end
			if (command == "VersionInvalid") and kAuction:IsPlayerRaidLeader(sender) then
				kAuction:Client_VersionInvalidReceived(sender, data);
			end
			if (command == "VersionRequest") and kAuction:IsPlayerRaidLeader(sender) then
				kAuction:Client_VersionRequestReceived(sender, data);
			end
			-- Refresh frames
			kAuction:Gui_HookFrameRefreshUpdate();
		end
	end
end
function kAuction:IsPlayerRaidLeader(name)
	local i, n, rank
	for i = 1, GetNumRaidMembers() do
		name, rank = GetRaidRosterInfo(i)
		if rank == 2 then
			if n == name then
				return true
			else
				return false
			end
		end
	end
	return false;
end
function kAuction:ParseAuctionItemLinkCommString(string)
	local itemLink, id, seedTime, duration, corpseGuid = strsplit("_", string);
	return itemLink, id, seedTime, duration, corpseGuid;
end
function kAuction:Debug(msg, threshold)
	if self.db.profile.debug.enabled then
		if threshold == nil then
			kAuction:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= self.db.profile.debug.threshold then
			kAuction:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end
function kAuction:HookBidsFrameScrollUpdate()
	kAuction:BidsFrameScrollUpdate();
end
function kAuction:RegisterLootCouncilVote(auction, bid)
	if kAuction:IsLootCouncilMember(auction, self.playerName) then
		-- Clear current vote for council member
		kAuction:ClearLootCouncilVoteFromAuction(auction, self.playerName);
		kAuction:SendCommunication("BidVote", kAuction:Serialize(auction, bid), 3);
	end
end
function kAuction:CancelLootCouncilVote(auction, bid)
	if kAuction:IsLootCouncilMember(auction, self.playerName) then
		-- Clear current vote for council member
		kAuction:ClearLootCouncilVoteFromAuction(auction, self.playerName);
		kAuction:SendCommunication("BidVoteCancel", kAuction:Serialize(auction, bid), 3);
	end
end
function kAuction:IsLootCouncilMember(auction, councilMember)
	if IsRaidLeader() then
		return true;
	else
		local memberName = councilMember;
		if not councilMember then
			memberName = self.playerName;
		end
		for i,member in pairs(auction.councilMembers) do
			if memberName == member then
				return true;
			end
		end	
	end
	return false;
end
function kAuction:ClearLootCouncilVoteFromAuction(auction, councilMember)
	for i,bid in pairs(auction.bids) do -- Loop through bids
		for iCouncil, vCouncil in pairs(bid.lootCouncilVoters) do -- Loop through Council Voters
			if vCouncil == councilMember then -- Find council name match in bid voters
				kAuction:Debug("FUNC: ClearLootCouncilVoteFromAuction, auction.itemLink: " .. auction.itemLink, 1)
				-- Remove entry
				tremove(bid.lootCouncilVoters, iCouncil);
			end
		end
	end
	return true;
end
function kAuction:BidHasCouncilMemberVote(bid, councilMember)
	for i,vCouncil in pairs(bid.lootCouncilVoters) do
		if councilMember == vCouncil then
			return true;
		end
	end
	return false;
end
function kAuction:BidsFrameScrollUpdate()
	local line; -- 1 through 5 of our window to scroll
	local lineplusoffset; -- an index into our data calculated from the scroll offset
	--_G[self.db.profile.gui.frames.main.name.."BidScrollContainerTitleText"]:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.bids.font), 16);
	--_G[self.db.profile.gui.frames.main.name.."BidScrollContainerTitleRightText"]:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.bids.font), 16);
	if #(self.auctions) > 0 and #(self.auctions) >= self.selectedAuctionIndex and self.selectedAuctionIndex ~= 0 and self.db.profile.gui.frames.bids.visible then
		--_G[self.db.profile.gui.frames.main.name.."BidScrollContainerTitleText"]:SetText(self.auctions[self.selectedAuctionIndex].itemLink);
		--_G[self.db.profile.gui.frames.main.name.."BidScrollContainerTitle"]:SetScript("OnEnter", function() kAuction:Gui_CurrentItemMenuOnEnter(_G[self.db.profile.gui.frames.main.name.."BidScrollContainerTitleText"), self.auctions[self.selectedAuctionIndex].itemLink) end);
		--_G[self.db.profile.gui.frames.main.name.."BidScrollContainerTitle"]:SetScript("OnLeave", function() GameTooltip:Hide() end);
		FauxScrollFrame_Update(kAuctionMainFrameBidScrollContainerScrollFrame,#(self.auctions[self.selectedAuctionIndex].bids),5,16);
		for line=1,5 do
			lineplusoffset = line + FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
			if lineplusoffset <= #(self.auctions[self.selectedAuctionIndex].bids) then
				-- Update Bid Current Item Buttons
				kAuction:Gui_UpdateBidCurrentItemButtons(line, self.auctions[self.selectedAuctionIndex], self.auctions[self.selectedAuctionIndex].bids[lineplusoffset]);
				-- Update Bid Items Won Frame
				kAuction:Gui_UpdateBidItemsWonFrame(_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."ItemsWon"]);
				-- Update Bid Items Won Text
				kAuction:Gui_UpdateBidItemsWonText(_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."ItemsWonText"]);
				-- Update Bid Name Text
				kAuction:Gui_UpdateBidNameText(_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."NameText"]);
				-- Update Bid Roll Text
				kAuction:Gui_UpdateBidRollText(line, self.auctions[self.selectedAuctionIndex], self.auctions[self.selectedAuctionIndex].bids[lineplusoffset]);
				-- Update Bid Vote button
				kAuction:Gui_UpdateBidVoteButton(line, self.auctions[self.selectedAuctionIndex], self.auctions[self.selectedAuctionIndex].bids[lineplusoffset]);
				kAuction:Gui_ConfigureBidColumns(line, self.auctions[self.selectedAuctionIndex]);
				_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line]:Show();
			else
				_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line]:Hide();
			end
		end
		_G[self.db.profile.gui.frames.main.name]:Show();		
	end
end
function kAuction:GetFirstOpenAuctionIndex()
	for i,auction in pairs(self.auctions) do
		if not auction.closed then
			return i;
		end
	end
	return 1;
end
function kAuction:OnUpdate(index, elapsed)
	kAuction.updates[index] = kAuction.updates[index] + elapsed;
	if (kAuction.updates[index] > 0.1) then
		kAuction.updates[index] = 0;
		kAuction:MainFrameScrollUpdate()
	end
	-- Destroy scheduled timers that have expired
	kAuction.updates[2] = kAuction.updates[2] + elapsed;
	if (kAuction.updates[2] > 1) then
		kAuction.updates[2] = 0;
		for i = #self.timers, 1, -1 do
			if self.timers[i].expires + 10 <= time() then
				self:CancelTimer(self.timers[i].timer, true)				
				table.remove(self.timers, i)
			end
		end
	end	
end
function kAuction:MainFrameScrollUpdate()
	-- BASE MEMORY USAGE: +0KB
	if self.auctions and #(self.auctions) > 0 and self.db.profile.gui.frames.main.visible then
		local line; -- 1 through 5 of our window to scroll
		local lineplusoffset; -- an index into our data calculated from the scroll offset
		FauxScrollFrame_Update(kAuctionMainFrameMainScrollContainerScrollFrame,#(self.auctions),5,16);
		_G[self.db.profile.gui.frames.main.name.."TitleText"]:SetFont(sharedMedia:Fetch("font", self.db.profile.gui.frames.main.font), 16);
		for line=1,5 do
			lineplusoffset = line + FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
			if lineplusoffset <= #(self.auctions) then
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
	else
		_G[self.db.profile.gui.frames.main.name]:Hide();
	end
end
function kAuction:DetermineRandomAuctionWinner(iAuction)
	-- Verify raid leader
	if not IsRaidLeader() then
		return;
	end
	if self.auctions and self.auctions[iAuction] then
		if not self.auctions[iAuction].closed then
			return;
		end
		-- Check auction type
		if self.auctions[iAuction].auctionType == 1 then -- Random
			if #(self.auctions[iAuction].bids) > 0 then
				local winningBid = kAuction:GetRandomAuctionWinningBid(self.auctions[iAuction]);
				if winningBid then
					self.auctions[iAuction].winner = winningBid.name; -- set winner
					return self.auctions[iAuction].winner;
				end
			end
		end
	end
	return nil;
end
function kAuction:GetEnchanterInRaidRosterObject()
	for i,val in pairs(self.db.profile.looting.disenchanters) do
		for iR = 1, GetNumRaidMembers() do
			if val == GetRaidRosterInfo(iR) then
				return true
			end
		end
	end
	return nil;
end
function kAuction:GetRandomAuctionWinningBid(auction)
	if auction.auctionType ~= 1 then
		return;
	end
	while kAuction:DoesRandomAuctionHaveHighRoll(auction) == false do
		-- Do nothing
	end
	local booNormalExists = false;
	local booOffspecExists = false;
	for i,bid in pairs(auction.bids) do
		if bid.bidType == "normal" then
			booNormalExists = true;
		elseif bid.bidType == "offspec" then
			booOffspecExists = true;
		end
	end
	local highRoll = kAuction:GetAuctionHighRoll(auction);
	if booNormalExists then
		for i,bid in pairs(auction.bids) do
			if bid.bidType == "normal" and bid.roll == highRoll then
				return bid;
			end
		end
	elseif booNormalExists then
		for i,bid in pairs(auction.bids) do
			if bid.bidType == "offspec" and bid.roll == highRoll then
				return bid;
			end
		end
	else
		for i,bid in pairs(auction.bids) do
			if bid.roll == highRoll then
				return bid;
			end
		end
	end
	return nil;
end
function kAuction:DoesRandomAuctionHaveHighRoll(auction)
	if auction.auctionType ~= 1 then
		return;
	end
	-- Check if normal bidTypes, if so, ignore offspec entry rolls
	local booNormalExists = false;
	local booOffspecExists = false;
	for i,bid in pairs(auction.bids) do
		if bid.bidType == "normal" then
			booNormalExists = true;
		elseif bid.bidType == "offspec" then
			booOffspecExists = true;
		end
	end
	local highBids = {};
	local highRoll = kAuction:GetAuctionHighRoll(auction);
	if booNormalExists then
		for i,bid in pairs(auction.bids) do
			if bid.bidType == "normal" and bid.roll == highRoll then
				tinsert(highBids, #(highBids)+1, i);
			end
		end
	elseif booOffspecExists then
		for i,bid in pairs(auction.bids) do
			if bid.bidType == "offspec" and bid.roll == highRoll then
				tinsert(highBids, #(highBids)+1, i);
			end
		end
	else
		for i,bid in pairs(auction.bids) do
			if bid.roll == highRoll then
				tinsert(highBids, #(highBids)+1, i);
			end
		end
	end
	-- Redo matching high rolls
	if #(highBids) > 1 then
		for i,val in pairs(highBids) do
			auction.bids[val].roll = math.random(1,self.db.profile.looting.rollMaximum);
		end
	end
	if #(highBids) == 1 then
		return true;
	else
		return false;
	end
end
function kAuction:GetAuctionHighRoll(auction)
	if auction.auctionType ~= 1 then
		return;
	end
	local booNormalExists = false;
	local booOffspecExists = false;
	for i,bid in pairs(auction.bids) do
		if bid.bidType == "normal" then
			booNormalExists = true;
		elseif bid.bidType == "offspec" then
			booOffspecExists = true;
		end
	end
	if booNormalExists then
		local highRoll = 0;
		for i,bid in pairs(auction.bids) do
			if bid.bidType == "normal" then
				if bid.roll > highRoll then
					highRoll = bid.roll;
				end
			end
		end
		return highRoll;
	elseif booNormalExists then
		local highRoll = 0;
		for i,bid in pairs(auction.bids) do
			if bid.bidType == "offspec" then
				if bid.roll > highRoll then
					highRoll = bid.roll;
				end
			end
		end
		return highRoll;
	else
		local highRoll = 0;
		for i,bid in pairs(auction.bids) do
			if bid.roll > highRoll then
				highRoll = bid.roll;
			end
		end
		return highRoll;		
	end
	return nil;
end
function kAuction:GetAuctionTimeleft(objAuction, offset)
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(objAuction.id);
	kAuction:Debug("FUNC: GetAuctionTimeleft, localstarttime: " .. localAuctionData.localStartTime .. ", time: " .. time(), 2)
	if offset then
		if offset >= 0 then
			if (time() - localAuctionData.localStartTime) > objAuction.duration + offset then -- auction closed
				objAuction.closed = true;
				kAuction:Debug("FUNC: GetAuctionTimeleft offset >= 0, value: 0", 2)
				return nil;
			else
				kAuction:Debug("FUNC: GetAuctionTimeleft, value: " .. (objAuction.duration + offset) - (time() - localAuctionData.localStartTime), 2)
				return (objAuction.duration + offset) - (time() - localAuctionData.localStartTime);
			end	
		else
			if (time() + offset - localAuctionData.localStartTime) > objAuction.duration then -- auction closed
				objAuction.closed = true;
				kAuction:Debug("FUNC: GetAuctionTimeleft, offset < 0: 0", 2)
				return nil;
			else
				kAuction:Debug("FUNC: GetAuctionTimeleft, value: " .. (objAuction.duration) - (time() + offset - localAuctionData.localStartTime), 2)
				return (objAuction.duration) - (time() + offset - localAuctionData.localStartTime);
			end				
		end
	else
		if (time() - localAuctionData.localStartTime) > objAuction.duration then -- auction closed
			objAuction.closed = true;
			kAuction:Debug("FUNC: GetAuctionTimeleft, no offset, value: 0", 2)
			return nil;
		else
			kAuction:Debug("FUNC: GetAuctionTimeleft, value: " .. objAuction.duration - (time() - localAuctionData.localStartTime), 2)
			return objAuction.duration - (time() - localAuctionData.localStartTime);
		end
	end
end
function kAuction:RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end
function kAuction:ColorizeSubstringInString(subject, substring, r, g, b)
	local t = {};
	for i = 1, strlen(subject) do
		local iStart, iEnd = string.find(strlower(subject), strlower(substring), i, strlen(substring) + i - 1)
		if iStart and iEnd then
			for iTrue = iStart, iEnd do
				t[iTrue] = true;
			end
		else
			if not t[i] then
				t[i] = false;
			end
		end
	end
	local sOut = '';
	local sColor = kAuction:RGBToHex(r*255,g*255,b*255);
	for i = 1, strlen(subject) do
		if t[i] == true then
			sOut = sOut .. "|cFF"..sColor..strsub(subject, i, i).."|r";
		else
			sOut = sOut .. strsub(subject, i, i);
		end
	end
	if strlen(sOut) > 0 then
		return sOut;
	else
		return nil;
	end
end
function kAuction:OnBidItemsWonEnter(frame)
	kAuctionTooltip:Hide(); -- Clear tooltip
	offset = FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local selectFrame;	
	if self.auctions[self.selectedAuctionIndex] and self.auctions[self.selectedAuctionIndex].bids[offset+row] then
		local wonItemList = kAuction:Item_GetPlayerWonItemList(self.auctions[self.selectedAuctionIndex].bids[offset+row].name);
		-- If active bid, menu locked, do not show
		if #(wonItemList) > 0 then
			--Current item mouse over, show select frame
			selectFrame = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrame"];
			local i = 1;
			while _G[selectFrame:GetName().."Button"..i] and i <= #(kAuction:Item_GetPlayerWonItemList(self.auctions[self.selectedAuctionIndex].bids[offset+row].name))  do
				_G[selectFrame:GetName().."Button"..i]:Show()
				i=i+1;
			end
			--kAuction:Threading_StartTimer("kAuctionThreadingFrameBids"..row);
			if _G["kAuctionThreadingFrameBids"..row] then
				_G["kAuctionThreadingFrameBids"..row]:Show();
			end
		else
			if _G["kAuctionThreadingFrameBids"..row] then
				_G["kAuctionThreadingFrameBids"..row]:Hide();
			end
			_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrame"]:Hide();
		end
		-- Hide other Rows
		local iSelectFrame = 1;
		while _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..iSelectFrame.."ItemsWonSelectFrame"] do
			if iSelectFrame ~= row then
				_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..iSelectFrame.."ItemsWonSelectFrame"]:Hide();
			end
			iSelectFrame = iSelectFrame + 1;
		end
		if #(wonItemList) > 0 then
			kAuction:Gui_OnBidRollOnLeave(nil);
			kAuction:Gui_OnBidItemsWonLeave(nil);		
			selectFrame:Show();
			-- Update tooltip
			--[[
			if localAuctionData.currentItemLink ~= false then
				kAuction:Gui_CurrentItemMenuOnEnter(frame,localAuctionData.currentItemLink);
			end
			]]
			local tip = self.qTip:Acquire("GameTooltip", 1, "LEFT")
			tip:Clear();
			tip:SetPoint("TOP", frame, "BOTTOM", 0, 0);
			tip:AddHeader("Items Won by " .. self.auctions[self.selectedAuctionIndex].bids[offset+row].name);
			tip:AddLine("");
			tip:AddLine("");
			tip:AddLine("");
			local fontRed = CreateFont("kAuctionBidItemsWonFontRed")
			fontRed:CopyFontObject(GameTooltipText)
			fontRed:SetTextColor(1,0,0)
			local fontGreen = CreateFont("kAuctionBidItemsWonFontGreen")
			fontGreen:CopyFontObject(GameTooltipText)
			fontGreen:SetTextColor(0,1,0)
			local fontYellow = CreateFont("kAuctionBidItemsWonFontYellow")
			fontYellow:CopyFontObject(GameTooltipText)
			fontYellow:SetTextColor(1,1,0)
			tip:SetCell(2, 1, "Normal", fontGreen);
			tip:SetCell(3, 1, "Offspec", fontYellow);
			tip:SetCell(4, 1, "Rot", fontRed);
			tip:Show();
		end
	end	
end
function kAuction:OnBidNameOnEnter(frame)
	offset = FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local bidType = self.auctions[self.selectedAuctionIndex].bids[offset+row].bidType;
	local tip = self.qTip:Acquire("GameTooltip", 1, "LEFT")
	tip:Clear();
	tip:SetPoint("TOP", frame, "BOTTOM", 0, 0);
	tip:AddHeader(self.auctions[self.selectedAuctionIndex].bids[offset+row].name.."'s Bid Type:");
	tip:AddLine("");
	local fontRed = CreateFont("kAuctionBidItemsWonFontRed")
	fontRed:CopyFontObject(GameTooltipText)
	fontRed:SetTextColor(1,0,0)
	local fontGreen = CreateFont("kAuctionBidItemsWonFontGreen")
	fontGreen:CopyFontObject(GameTooltipText)
	fontGreen:SetTextColor(0,1,0)
	local fontYellow = CreateFont("kAuctionBidItemsWonFontYellow")
	fontYellow:CopyFontObject(GameTooltipText)
	fontYellow:SetTextColor(1,1,0)
	if bidType == "normal" then
		tip:SetCell(2, 1, "Normal", fontGreen);
	elseif bidType == "offspec" then
		tip:SetCell(2, 1, "Offspec", fontYellow);
	else
		tip:SetCell(2, 1, "Rot", fontRed);
	end
	tip:Show();
end
function kAuction:OnCurrentItemEnter(frame)
	kAuction:Debug("FUNC: OnCurrentItemEnter, frame: " .. frame:GetName(), 3);
	kAuctionTooltip:Hide(); -- Clear tooltip
	offset = FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	local selectFrame;
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(self.auctions[offset + row].id);	
	-- If active bid, menu locked, do not show
	if self.auctions[offset + row].currentItemSlot and not localAuctionData.bid and kAuction:GetAuctionTimeleft(self.auctions[offset + row]) then
		--Current item mouse over, show select frame
		selectFrame = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"];
		--selectFrame = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame", 1];
		local i = 1;
		local matchTable = kAuction:Item_GetInventoryItemMatchTable(self.auctions[offset + row].currentItemSlot)
		while _G[selectFrame:GetName().."Button"..i] do
			if i <= #(matchTable) then
				_G[selectFrame:GetName().."Button"..i]:Show()
			end
			i=i+1;			
		end
	end
	-- Hide other Rows
	local iSelectFrame = 1;
	while _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..iSelectFrame.."CurrentItemSelectFrame"] do
		if iSelectFrame ~= row then
			_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..iSelectFrame.."CurrentItemSelectFrame"]:Hide();
		end
		iSelectFrame = iSelectFrame + 1;
	end
	if self.auctions[offset + row].currentItemSlot then
		if not localAuctionData.bid and kAuction:GetAuctionTimeleft(self.auctions[offset + row]) then
			selectFrame:Show();
		end
		-- Update tooltip
		if localAuctionData.currentItemLink ~= false then
			kAuction:Gui_CurrentItemMenuOnEnter(frame,localAuctionData.currentItemLink);
		end
		--kAuction:Threading_StartTimer("kAuctionThreadingFrameMain"..row);
	else
		if _G["kAuctionThreadingFrameMain"..row] then
			_G["kAuctionThreadingFrameMain"..row]:Hide();
		end
	end
end
function kAuction:OnCurrentItemLeave(frame)
	kAuction:Debug("FUNC: OnCurrentItemLeave, frame: " .. frame:GetName(), 1);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"]:Hide();
end
function IsInPopoutMainFrameTimer(timerName)
	-- Hide other rows if needed
	local _, _, row = string.find(timerName, "(%d+)");
	if not kAuction:IsInPopoutMainFrame(row) then
		local i = 1;
		while _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrameButton"..i] do
			_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrameButton"..i]:Hide();
			i=i+1;
		end
		_G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"]:Hide();
		--kAuction:Threading_StopTimer(timerName);	
		_G[timerName]:Hide();
	end
end
function IsInPopoutBidsFrameTimer(timerName)
	-- Hide other rows if needed
	local _, _, row = string.find(timerName, "(%d+)");
	if not kAuction:IsInPopoutBidsFrame(row) then
		local i = 1;
		while _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrameButton"..i] do
			_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrameButton"..i]:Hide();
			i=i+1;
		end
		_G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrame"]:Hide();
		--kAuction:Threading_StopTimer(timerName);
		_G[timerName]:Hide();
	end
end
function kAuction:IsInPopoutMainFrame(row)
	local objFrames = {};
	local objCurrentItemFrame = _G[self.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItem"];
	if objCurrentItemFrame then
		tinsert(objFrames, #(objFrames)+1, objCurrentItemFrame);
		if _G[objCurrentItemFrame:GetName().."SelectFrame"] then
			tinsert(objFrames, #(objFrames)+1, _G[objCurrentItemFrame:GetName().."SelectFrame"]);	
			local iButton = 1;
			while _G[objCurrentItemFrame:GetName().."SelectFrameButton"..iButton] do
				tinsert(objFrames, #(objFrames)+1, _G[objCurrentItemFrame:GetName().."SelectFrameButton"..iButton]);
				iButton=iButton+1;
			end
		end
	end
	local currentFrame = GetMouseFocus();
	for i,val in pairs(objFrames) do
		kAuction:Debug("FUNC: IsInPopoutMainFrame, FrameCheck: "..val:GetName(), 2);
		if val == currentFrame then
			kAuction:Debug("FUNC: IsInPopoutMainFrame, Row: "..row..", VALUE: true", 2);
			return true;
		end
	end
end
function kAuction:IsInPopoutBidsFrame(row)
	local objFrames = {};
	local objCurrentItemFrame = _G[self.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWon"];
	if objCurrentItemFrame then
		tinsert(objFrames, #(objFrames)+1, objCurrentItemFrame);
		if _G[objCurrentItemFrame:GetName().."SelectFrame"] then
			tinsert(objFrames, #(objFrames)+1, _G[objCurrentItemFrame:GetName().."SelectFrame"]);	
			local iButton = 1;
			while _G[objCurrentItemFrame:GetName().."SelectFrameButton"..iButton] do
				tinsert(objFrames, #(objFrames)+1, _G[objCurrentItemFrame:GetName().."SelectFrameButton"..iButton]);
				iButton=iButton+1;
			end
		end
	end
	local currentFrame = GetMouseFocus();
	for i,val in pairs(objFrames) do
		kAuction:Debug("FUNC: IsInPopoutBidsFrame, FrameCheck: "..val:GetName(), 2);
		if val == currentFrame then
			kAuction:Debug("FUNC: IsInPopoutBidsFrame, Row: "..row..", VALUE: true", 2);
			return true;
		end
	end
end
function kAuction:ZONE_CHANGED_NEW_AREA()
	-- Check if entering a valid raid zone
	if self.isInRaid == true and not self.isActiveRaid and kAuction:Client_IsServer() then
		if kAuction:Server_IsInValidRaidZone() then -- Check for valid zone
			StaticPopup_Show("kAuctionPopup_StartRaidTracking");
		end
	elseif self.isInRaid == true and self.isActiveRaid == true and self.enabled == true and kAuction:Client_IsServer() and not kAuction:Server_IsInValidRaidZone() and not UnitIsDeadOrGhost("player") then
		StaticPopup_Show("kAuctionPopup_StopRaidTracking");
	end
end
function kAuction:SplitString(subject, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( subject, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( subject, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( subject, delimiter, from  )
	end
	table.insert( result, string.sub( subject, from  ) )
	return result
end
function kAuction:DeleteAuction(auction)
	local lAuction = self.auctions[kAuction:Client_GetAuctionIndexByAuctionId(auction.id)];
	if lAuction then
		tremove(self.auctions, kAuction:Client_GetAuctionIndexByAuctionId(auction.id))
		if kAuction:Client_IsServer() then
			kAuction:SendCommunication("AuctionDelete", auction, 3);	
		end
	end
	kAuction:Gui_HookFrameRefreshUpdate();	
end