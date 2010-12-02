-- Create Mixins
kAuction = LibStub("AceAddon-3.0"):NewAddon("kAuction", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
kAuction.menu = {};
kAuction.currentZone = false;
function kAuction:OnInitialize()
    -- Load Database
    kAuction.db = LibStub("AceDB-3.0"):New("kAuctionDB", kAuction.defaults)
    kAuction.raidDb = LibStub("AceDB-3.0"):New("kAuctionRaidDB")
    -- Inject Options Table and Slash Commands
	kAuction.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(kAuction.db)
	kAuction.candyBar = LibStub("CandyBar-2.0");
	kAuction.config = LibStub("AceConfig-3.0"):RegisterOptionsTable("kAuction", kAuction.options, {"kauction", "ka"})
	kAuction.dialog = LibStub("AceConfigDialog-3.0")
	kAuction.AceGUI = LibStub("AceGUI-3.0")
	kAuction.cb = LibStub:GetLibrary("CallbackHandler-1.0")
	kAuction.effects = LibStub("LibEffects-1.0")
	kAuction.oo = LibStub("AceOO-2.0")
	kAuction.qTip = LibStub("LibQTip-1.0")
	kAuction.roster = LibStub("Roster-2.1")
	kAuction.sharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	kAuction:RegisterLibSharedMediaObjects();
	kAuction.tablet = LibStub("Tablet-2.0")
	kAuction.StatLogic = LibStub("LibStatLogic-1.1")
	--kAuction.ring = LibStub("kRotaryLib-1.0")
	--kAuction:Threading_CreateTimer("createTestRing",InitializeTestRing,5,false,nil);
	--kAuction:Threading_StartTimer("createTestRing");
	--kAuction:Ring_InitalizeTestRing();
	-- Init Events
	kAuction:InitializeEvents()
	-- Comm registry
	kAuction:RegisterComm("kAuction")
	-- Frames
	kAuction.selectedAuctionIndex = 0;
	kAuction.auctions = {};	
	kAuction.auctionTabs = {};
	kAuction.localAuctionData = {};
	kAuction:Gui_InitializePopups();
	kAuction:Gui_InitializeFrames()
	kAuction:Gui_HookFrameRefreshUpdate();
	-- Menu
	kAuction.menu = CreateFrame("Frame", "Test_DropDown", UIParent, "UIDropDownMenuTemplate");
	-- Init council list
	kAuction:Server_InitializeCouncilMemberList();
end
kAuction.samples = {};
function kAuction:StartSample()
	kAuction:Debug("InitSnare Started.", 1);
	kAuction:Threading_CreateTimer("snareLoop",function() PlaySoundFile(kAuction.sharedMedia:Fetch("sound", "Snare1")) end,1,true,nil);
	kAuction:Threading_StartTimer("snareLoop");	
	tinsert(kAuction.samples, "snareLoop");
	kAuction:Threading_CreateTimer("shotLoop",function() PlaySoundFile(kAuction.sharedMedia:Fetch("sound", "Shot")) end,4,true,nil);
	kAuction:Threading_StartTimer("shotLoop");	
	tinsert(kAuction.samples, "shotLoop");
	kAuction:Threading_CreateTimer("shotLoop2",function() PlaySoundFile(kAuction.sharedMedia:Fetch("sound", "Shot")) end,3.5,true,nil);
	kAuction:Threading_StartTimer("shotLoop2");	
	tinsert(kAuction.samples, "shotLoop2");
	kAuction:Threading_CreateTimer("shotLoop3",function() PlaySoundFile(kAuction.sharedMedia:Fetch("sound", "Shot")) end,3,true,nil);
	kAuction:Threading_StartTimer("shotLoop3");	
	tinsert(kAuction.samples, "shotLoop3");
end
function kAuction:StopSample()
	for i,val in pairs(kAuction.samples) do
		kAuction:Threading_StopTimer(val);
	end
end
function InitializeTestRing(arg1)
	kAuction:Ring_InitializeTestRing();
end
function kAuction:InitializeEvents()
	kAuction.enabled = false;
	kAuction.isActiveRaid = false;
	kAuction.isInRaid = false;
	kAuction:RegisterEvent("LOOT_OPENED");
	kAuction:RegisterEvent("LOOT_CLOSED");
	kAuction:RegisterEvent("UNIT_SPELLCAST_SENT");
	kAuction:RegisterEvent("RAID_ROSTER_UPDATE");
	kAuction:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	kAuction:RegisterEvent("CHAT_MSG_WHISPER");
	--kAuction:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	if kAuction.db.profile.modules.aura.enabled then
		kAuction:RegisterEvent("UNIT_AURA");
	end
	--kAuction:RegisterEvent("UI_ERROR_MESSAGE");
end

do
	local function kAuctionFilterOutgoing(self, event, ...)
		local msg = ...
		if not msg and self then
			return kAuctionFilterOutgoing(nil, nil, self, event)
		end
		-- Check for addon prefix, suppress automatically
		if string.find(msg, kAuction.const.chatPrefix) then
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
		if string.find(msg, kAuction.const.chatPrefix) then
			return true;
		end
		if strlower(msg) == "kauction help" or strlower(msg) == "ka help" then
			return true;
		end
		if not kAuction.db.profile.looting.auctionWhisperBidSuppressionEnabled or not kAuction.db.profile.looting.auctionWhisperBidEnabled then
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
function kAuction:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1, ...);
	-- Note, for this example, you could just use 'local type = select(2, ...)'.  The others are included so that it's clear what's available.
	if (type=="SPELL_DAMAGE") then
		local spellId, spellName, spellSchool = select(9, ...)
		-- Use the following line in game version 3.0 or higher, for previous versions use the line after
		local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...)

		if destGUID == UnitGUID("player") then
			if amount and overkill and absorbed then
				kAuction:Debug("Amount: " .. amount .. ", Absorb: " .. absorbed .. ", Overkill: " .. overkill ..", Total: " .. amount + absorbed + overkill, 3);
			elseif amount and absorbed then
				kAuction:Debug("Amount: " .. amount .. ", Absorb: " .. absorbed .. ", Total: " .. amount + absorbed, 3);
			end
			-- Amount includes overkill
			-- if overkill: amount - overkill + resist + absorbed
			-- Amount, Resist, Absorbed are seperate
			-- Total damage dealt: resist + absorbed + (amount - overkill)
		end
	end
end
function kAuction:UI_ERROR_MESSAGE(arg1, arg2)
	local xPlayer,yPlayer = GetPlayerMapPosition("player");
	local xOther,yOther = GetPlayerMapPosition("raid1");
	local distance = math.sqrt((yOther - yPlayer) * (yOther - yPlayer) + (xOther - xPlayer) * (xOther - xPlayer));
	if arg2 then
		if arg2 == "Out of range." then
			if kAuction.db.profile.coords.minOutOfRange2 then
				if distance < kAuction.db.profile.coords.minOutOfRange2 then
					kAuction:Print("UPDATE outrange dist UPDATE: " .. distance .. ", old: " .. kAuction.db.profile.coords.minOutOfRange2);					
					kAuction.db.profile.coords.minOutOfRange2 = distance;	
				else
					kAuction:Debug("outrange dist: " .. distance, 3);					
				end
			else
				kAuction.db.profile.coords.minOutOfRange2 = distance;				
			end
		elseif arg2 == "You can't do that yet" then
			if kAuction.db.profile.coords.maxInRange2 then
				
				if distance > kAuction.db.profile.coords.maxInRange2 then
					kAuction:Print("UPDATE inrange dist UPDATE: " .. distance .. ", old: " .. kAuction.db.profile.coords.maxInRange2);					
					kAuction.db.profile.coords.maxInRange2 = distance;
				else
					kAuction:Debug("inrange dist: " .. distance, 3);					
				end
			else
				kAuction.db.profile.coords.maxInRange2 = distance;				
			end
		end
	end
end
function kAuction:RegisterLibSharedMediaObjects()
	-- Fonts
	kAuction.sharedMedia:Register("font", "Adventure",	[[Interface\AddOns\kAuction\Fonts\Adventure.ttf]]);
	kAuction.sharedMedia:Register("font", "Alba Super", [[Interface\AddOns\kAuction\Fonts\albas.ttf]]);
	kAuction.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kAuction\Fonts\CAS_ANTN.TTF]]);
	kAuction.sharedMedia:Register("font", "Caslon Antique", [[Interface\AddOns\kAuction\Fonts\Cella.otf]]);
	kAuction.sharedMedia:Register("font", "Chick", [[Interface\AddOns\kAuction\Fonts\chick.ttf]]);
	kAuction.sharedMedia:Register("font", "Corleone",	[[Interface\AddOns\kAuction\Fonts\Corleone.ttf]]);
	kAuction.sharedMedia:Register("font", "The Godfather",	[[Interface\AddOns\kAuction\Fonts\CorleoneDue.ttf]]);
	kAuction.sharedMedia:Register("font", "Forte",	[[Interface\AddOns\kAuction\Fonts\Forte.ttf]]);
	kAuction.sharedMedia:Register("font", "Freshbot", [[Interface\AddOns\kAuction\Fonts\freshbot.ttf]]);
	kAuction.sharedMedia:Register("font", "Jokewood", [[Interface\AddOns\kAuction\Fonts\jokewood.ttf]]);
	kAuction.sharedMedia:Register("font", "Sopranos",	[[Interface\AddOns\kAuction\Fonts\Mobsters.ttf]]);
	kAuction.sharedMedia:Register("font", "Weltron Urban", [[Interface\AddOns\kAuction\Fonts\weltu.ttf]]);
	kAuction.sharedMedia:Register("font", "Wild Ride", [[Interface\AddOns\kAuction\Fonts\WildRide.ttf]]);
	-- Sounds
	
	kAuction.sharedMedia:Register("sound", "Alarm", [[Interface\AddOns\kAuction\Sounds\alarm.mp3]]);
	kAuction.sharedMedia:Register("sound", "Alert", [[Interface\AddOns\kAuction\Sounds\alert.mp3]]);
	kAuction.sharedMedia:Register("sound", "Info", [[Interface\AddOns\kAuction\Sounds\info.mp3]]);
	kAuction.sharedMedia:Register("sound", "Long", [[Interface\AddOns\kAuction\Sounds\long.mp3]]);
	kAuction.sharedMedia:Register("sound", "Shot", [[Interface\AddOns\kAuction\Sounds\shot.mp3]]);
	kAuction.sharedMedia:Register("sound", "Sonar", [[Interface\AddOns\kAuction\Sounds\sonar.mp3]]);
	kAuction.sharedMedia:Register("sound", "Victory", [[Interface\AddOns\kAuction\Sounds\victory.mp3]]);
	kAuction.sharedMedia:Register("sound", "Victory Classic", [[Interface\AddOns\kAuction\Sounds\victoryClassic.mp3]]);
	kAuction.sharedMedia:Register("sound", "Victory Long", [[Interface\AddOns\kAuction\Sounds\victoryLong.mp3]]);
	kAuction.sharedMedia:Register("sound", "Wilhelm", [[Interface\AddOns\kAuction\Sounds\wilhelm.mp3]]);

	-- Sounds, Worms
	kAuction.sharedMedia:Register("sound", "Worms - Angry Scot Come On Then", [[Interface\AddOns\kAuction\Sounds\wangryscotscomeonthen.wav]]);
	kAuction.sharedMedia:Register("sound", "Worms - Angry Scot Coward", [[Interface\AddOns\kAuction\Sounds\wangryscotscoward.wav]]);
	kAuction.sharedMedia:Register("sound", "Worms - Angry Scot I'll Get You", [[Interface\AddOns\kAuction\Sounds\wangryscotsillgetyou.wav]]);
	kAuction.sharedMedia:Register("sound", "Worms - Sargeant Fire", [[Interface\AddOns\kAuction\Sounds\wdrillsargeantfire.wav]]);
	kAuction.sharedMedia:Register("sound", "Worms - Sargeant Stupid", [[Interface\AddOns\kAuction\Sounds\wdrillsargeantstupid.wav]]);
	kAuction.sharedMedia:Register("sound", "Worms - Sargeant Watch This", [[Interface\AddOns\kAuction\Sounds\wdrillsargeantwatchthis.wav]]);
	kAuction.sharedMedia:Register("sound", "Worms - Grandpa Coward", [[Interface\AddOns\kAuction\Sounds\wgrandpacoward.wav]]);
	kAuction.sharedMedia:Register("sound", "Worms - Grandpa Uh Oh", [[Interface\AddOns\kAuction\Sounds\wgrandpauhoh.wav]]);
	kAuction.sharedMedia:Register("sound", "Worms - I'll Get You", [[Interface\AddOns\kAuction\Sounds\willgetyou.wav]]);
	kAuction.sharedMedia:Register("sound", "Worms - Uh Oh", [[Interface\AddOns\kAuction\Sounds\wuhoh.wav]]);
	-- Drum
	kAuction.sharedMedia:Register("sound", "Snare1", [[Interface\AddOns\kAuction\Sounds\snare1.mp3]]);
end

function kAuction:OnEnable()
	if kAuction:Client_IsServer() then
		if GetNumRaidMembers() > 0 then
			kAuction.isInRaid = true;
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
			kAuction.isInRaid = true;
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
	kAuction.isLooting = false;
end
function kAuction:LOOT_OPENED()
	kAuction:Debug("EVENT: LOOT_OPENED", 3)
	kAuction.isLooting = true;
	if kAuction.enabled and kAuction.isActiveRaid and GetNumRaidMembers() > 0 and kAuction:Client_IsServer() then -- Player in raid and raid leader
		local guid = UnitGUID("target") -- NPC Looted
		local corpseName = UnitName("target");
		if not guid then -- Else Container Looted
			guid = kAuction.guids.lastObjectOpened;
			corpseName = kAuction.guids.lastObjectOpened;
		end			
		if kAuction:Server_HasCorpseBeenAuctioned(guid) == false then -- Check if corpse auctioned already.
			kAuction:Server_SetCorpseAsAuctioned(guid) -- Mark corpse as auctioned		
			for i = 1, GetNumLootItems() do
				if (LootSlotIsItem(i)) then
					if kAuction.db.profile.looting.isAutoAuction then
						kAuction:Server_AuctionItem(GetLootSlotLink(i), guid, corpseName)
					end
				end
			end		
		end		
	end
end
function kAuction:RAID_ROSTER_UPDATE()
	-- Client just joined a raid.
	if kAuction.isInRaid == false and GetNumRaidMembers() > 0 then
		kAuction.hasRunVersionCheck = false;
		kAuction.isInRaid = true;
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
	elseif kAuction.isInRaid == true and isActiveRaid == true and GetNumRaidMembers() == 0 then
		kAuction.hasRunVersionCheck = false;
		kAuction.isInRaid = false;
		-- Check if Server
		if kAuction:Client_IsServer() then
			StaticPopup_Show("kAuctionPopup_StopRaidTracking");
		end
		kAuction:Debug("FUNC: RAID_ROSTER_UPDATE - Client just left a raid.", 1);
	end
end
function kAuction:UNIT_SPELLCAST_SENT(blah, unit, spell, rank, target)
	if spell == "Opening" then
		kAuction.guids.lastObjectOpened = target;
		kAuction:Debug("FUNC: UNIT_SPELLCAST_SENT, target: " .. target .. ", spell: " .. spell, 3)
	end
end
function kAuction:SendCommunication(command, data)
	kAuction:SendCommMessage("kAuction", kAuction:Serialize(command, data), "RAID")
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
				kAuction.auctions = {};	
				kAuction.auctionTabs = {};
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
	local objUnit = kAuction.roster:GetUnitObjectFromName(name)
	if objUnit then
		if objUnit.rank == 2 then -- 0 regular, 1 assistant, 2 raid leader
			return true;
		end
	end
	return false;
end
function kAuction:ParseAuctionItemLinkCommString(string)
	local itemLink, id, seedTime, duration, corpseGuid = strsplit("_", string);
	return itemLink, id, seedTime, duration, corpseGuid;
end
function kAuction:Debug(msg, threshold)
	if kAuction.db.profile.debug.enabled then
		if threshold == nil then
			kAuction:Print(ChatFrame1, "DEBUG: " .. msg)		
		elseif threshold <= kAuction.db.profile.debug.threshold then
			kAuction:Print(ChatFrame1, "DEBUG: " .. msg)		
		end
	end
end
function kAuction:HookBidsFrameScrollUpdate()
	kAuction:BidsFrameScrollUpdate();
end
function kAuction:RegisterLootCouncilVote(auction, bid)
	if kAuction:IsLootCouncilMember(auction, UnitName("player")) then
		-- Clear current vote for council member
		kAuction:ClearLootCouncilVoteFromAuction(auction, UnitName("player"));
		kAuction:SendCommunication("BidVote", kAuction:Serialize(auction, bid));
	end
end
function kAuction:CancelLootCouncilVote(auction, bid)
	if kAuction:IsLootCouncilMember(auction, UnitName("player")) then
		-- Clear current vote for council member
		kAuction:ClearLootCouncilVoteFromAuction(auction, UnitName("player"));
		kAuction:SendCommunication("BidVoteCancel", kAuction:Serialize(auction, bid));
	end
end
function kAuction:IsLootCouncilMember(auction, councilMember)
	if IsRaidLeader() then
		return true;
	else
		local memberName = councilMember;
		if not councilMember then
			memberName = UnitName("player");
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
	--_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerTitleText"]:SetFont(kAuction.sharedMedia:Fetch("font", kAuction.db.profile.gui.frames.bids.font), 16);
	--_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerTitleRightText"]:SetFont(kAuction.sharedMedia:Fetch("font", kAuction.db.profile.gui.frames.bids.font), 16);
	if #(kAuction.auctions) > 0 and #(kAuction.auctions) >= kAuction.selectedAuctionIndex and kAuction.selectedAuctionIndex ~= 0 and kAuction.db.profile.gui.frames.bids.visible then
		--_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerTitleText"]:SetText(kAuction.auctions[kAuction.selectedAuctionIndex].itemLink);
		--_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerTitle"]:SetScript("OnEnter", function() kAuction:Gui_CurrentItemMenuOnEnter(_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerTitleText"), kAuction.auctions[kAuction.selectedAuctionIndex].itemLink) end);
		--_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerTitle"]:SetScript("OnLeave", function() GameTooltip:Hide() end);
		FauxScrollFrame_Update(kAuctionMainFrameBidScrollContainerScrollFrame,#(kAuction.auctions[kAuction.selectedAuctionIndex].bids),5,16);
		for line=1,5 do
			lineplusoffset = line + FauxScrollFrame_GetOffset(kAuctionMainFrameBidScrollContainerScrollFrame);
			if lineplusoffset <= #(kAuction.auctions[kAuction.selectedAuctionIndex].bids) then
				-- Update Bid Current Item Buttons
				kAuction:Gui_UpdateBidCurrentItemButtons(line, kAuction.auctions[kAuction.selectedAuctionIndex], kAuction.auctions[kAuction.selectedAuctionIndex].bids[lineplusoffset]);
				-- Update Bid Items Won Frame
				kAuction:Gui_UpdateBidItemsWonFrame(_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."ItemsWon"]);
				-- Update Bid Items Won Text
				kAuction:Gui_UpdateBidItemsWonText(_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."ItemsWonText"]);
				-- Update Bid Name Text
				kAuction:Gui_UpdateBidNameText(_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line.."NameText"]);
				-- Update Bid Roll Text
				kAuction:Gui_UpdateBidRollText(line, kAuction.auctions[kAuction.selectedAuctionIndex], kAuction.auctions[kAuction.selectedAuctionIndex].bids[lineplusoffset]);
				-- Update Bid Vote button
				kAuction:Gui_UpdateBidVoteButton(line, kAuction.auctions[kAuction.selectedAuctionIndex], kAuction.auctions[kAuction.selectedAuctionIndex].bids[lineplusoffset]);
				kAuction:Gui_ConfigureBidColumns(line, kAuction.auctions[kAuction.selectedAuctionIndex]);
				_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line]:Show();
			else
				_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..line]:Hide();
			end
		end
		_G[kAuction.db.profile.gui.frames.main.name]:Show();		
	end
end
function kAuction:GetFirstOpenAuctionIndex()
	for i,auction in pairs(kAuction.auctions) do
		if not auction.closed then
			return i;
		end
	end
	return 1;
end
function kAuction:MainFrameScrollUpdate()
	if kAuction.auctions and #(kAuction.auctions) > 0 and kAuction.db.profile.gui.frames.main.visible then
		local line; -- 1 through 5 of our window to scroll
		local lineplusoffset; -- an index into our data calculated from the scroll offset
		FauxScrollFrame_Update(kAuctionMainFrameMainScrollContainerScrollFrame,#(kAuction.auctions),5,16);
		_G[kAuction.db.profile.gui.frames.main.name.."TitleText"]:SetFont(kAuction.sharedMedia:Fetch("font", kAuction.db.profile.gui.frames.main.font), 16);
		for line=1,5 do
			lineplusoffset = line + FauxScrollFrame_GetOffset(kAuctionMainFrameMainScrollContainerScrollFrame);
			if lineplusoffset <= #(kAuction.auctions) then
				_G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..line.."ItemNameText"]:SetText(kAuction.auctions[lineplusoffset].itemLink);
				_G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..line.."ItemNameText"]:SetFont(kAuction.sharedMedia:Fetch("font", kAuction.db.profile.gui.frames.main.font), kAuction.db.profile.gui.frames.main.fontSize);
				_G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..line.."StatusText"]:SetFont(kAuction.sharedMedia:Fetch("font", kAuction.db.profile.gui.frames.main.font), kAuction.db.profile.gui.frames.main.fontSize);
				-- Removed r8702, replaced by dropdown system -- Update Bid Button --kAuction:Gui_UpdateAuctionBidButton(line, kAuction.auctions[lineplusoffset]);
				-- Update Close Button
				kAuction:Gui_UpdateAuctionCloseButton(line, kAuction.auctions[lineplusoffset]);
				-- Update Current Item Buttons
				kAuction:Gui_UpdateAuctionCurrentItemButtons(line, kAuction.auctions[lineplusoffset]);
				-- Update Candy Bars
				kAuction:Gui_UpdateAuctionCandyBar(line, kAuction.auctions[lineplusoffset]);
				-- Update Status
				kAuction:Gui_UpdateAuctionStatusText(line, kAuction.auctions[lineplusoffset]);
				-- Update Pullout menu
				kAuction:Gui_UpdateItemMatchMenu(line, kAuction.auctions[lineplusoffset]);
				_G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..line]:Show();
			else
				-- Update Candy Bars
				kAuction.candyBar:Unregister("auction"..line);
				_G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..line]:Hide();
			end
		end
		--_G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainer"]:Show();
		_G[kAuction.db.profile.gui.frames.main.name]:Show();
	else
		_G[kAuction.db.profile.gui.frames.main.name]:Hide();
	end
end
function kAuction:DetermineRandomAuctionWinner(iAuction)
	-- Verify raid leader
	if not IsRaidLeader() then
		return;
	end
	if kAuction.auctions and kAuction.auctions[iAuction] then
		if not kAuction.auctions[iAuction].closed then
			return;
		end
		-- Check auction type
		if kAuction.auctions[iAuction].auctionType == 1 then -- Random
			if #(kAuction.auctions[iAuction].bids) > 0 then
				local winningBid = kAuction:GetRandomAuctionWinningBid(kAuction.auctions[iAuction]);
				if winningBid then
					kAuction.auctions[iAuction].winner = winningBid.name; -- set winner
					return kAuction.auctions[iAuction].winner;
				end
			end
		end
	end
	return nil;
end
function kAuction:GetEnchanterInRaidRosterObject()
	for i,val in pairs(kAuction.db.profile.looting.disenchanters) do
		local unit = kAuction.roster:GetUnitObjectFromName(val);
		if unit then
			return unit;
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
			auction.bids[val].roll = math.random(1,kAuction.db.profile.looting.rollMaximum);
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
	if kAuction.auctions[kAuction.selectedAuctionIndex] and kAuction.auctions[kAuction.selectedAuctionIndex].bids[offset+row] then
		local wonItemList = kAuction:Item_GetPlayerWonItemList(kAuction.auctions[kAuction.selectedAuctionIndex].bids[offset+row].name);
		-- If active bid, menu locked, do not show
		if #(wonItemList) > 0 then
			--Current item mouse over, show select frame
			selectFrame = _G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrame"];
			local i = 1;
			while _G[selectFrame:GetName().."Button"..i] and i <= #(kAuction:Item_GetPlayerWonItemList(kAuction.auctions[kAuction.selectedAuctionIndex].bids[offset+row].name))  do
				_G[selectFrame:GetName().."Button"..i]:Show()
				i=i+1;
			end
			kAuction:Threading_StartTimer("kAuctionThreadingFrameBids"..row);
			if _G["kAuctionThreadingFrameBids"..row] then
				_G["kAuctionThreadingFrameBids"..row]:Show();
			end
		else
			if _G["kAuctionThreadingFrameBids"..row] then
				_G["kAuctionThreadingFrameBids"..row]:Hide();
			end
			_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrame"]:Hide();
		end
		-- Hide other Rows
		local iSelectFrame = 1;
		while _G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..iSelectFrame.."ItemsWonSelectFrame"] do
			if iSelectFrame ~= row then
				_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..iSelectFrame.."ItemsWonSelectFrame"]:Hide();
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
			local tip = kAuction.qTip:Acquire("GameTooltip", 1, "LEFT")
			tip:Clear();
			tip:SetPoint("TOP", frame, "BOTTOM", 0, 0);
			tip:AddHeader("Items Won by " .. kAuction.auctions[kAuction.selectedAuctionIndex].bids[offset+row].name);
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
	local bidType = kAuction.auctions[kAuction.selectedAuctionIndex].bids[offset+row].bidType;
	local tip = kAuction.qTip:Acquire("GameTooltip", 1, "LEFT")
	tip:Clear();
	tip:SetPoint("TOP", frame, "BOTTOM", 0, 0);
	tip:AddHeader(kAuction.auctions[kAuction.selectedAuctionIndex].bids[offset+row].name.."'s Bid Type:");
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
	local localAuctionData = kAuction:Client_GetLocalAuctionDataById(kAuction.auctions[offset + row].id);	
	-- If active bid, menu locked, do not show
	if kAuction.auctions[offset + row].currentItemSlot and not localAuctionData.bid and kAuction:GetAuctionTimeleft(kAuction.auctions[offset + row]) then
		--Current item mouse over, show select frame
		selectFrame = _G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"];
		--selectFrame = _G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame", 1];
		local i = 1;
		local matchTable = kAuction:Item_GetInventoryItemMatchTable(kAuction.auctions[offset + row].currentItemSlot)
		while _G[selectFrame:GetName().."Button"..i] do
			if i <= #(matchTable) then
				_G[selectFrame:GetName().."Button"..i]:Show()
			end
			i=i+1;			
		end
	end
	-- Hide other Rows
	local iSelectFrame = 1;
	while _G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..iSelectFrame.."CurrentItemSelectFrame"] do
		if iSelectFrame ~= row then
			_G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..iSelectFrame.."CurrentItemSelectFrame"]:Hide();
		end
		iSelectFrame = iSelectFrame + 1;
	end
	if kAuction.auctions[offset + row].currentItemSlot then
		if not localAuctionData.bid and kAuction:GetAuctionTimeleft(kAuction.auctions[offset + row]) then
			selectFrame:Show();
		end
		-- Update tooltip
		if localAuctionData.currentItemLink ~= false then
			kAuction:Gui_CurrentItemMenuOnEnter(frame,localAuctionData.currentItemLink);
		end
		kAuction:Threading_StartTimer("kAuctionThreadingFrameMain"..row);
		_G["kAuctionThreadingFrameMain"..row]:Show();
	else
		if _G["kAuctionThreadingFrameMain"..row] then
			_G["kAuctionThreadingFrameMain"..row]:Hide();
		end
	end
end
function kAuction:OnCurrentItemLeave(frame)
	kAuction:Debug("FUNC: OnCurrentItemLeave, frame: " .. frame:GetName(), 1);
	local _, _, row = string.find(frame:GetName(), "(%d+)");
	_G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"]:Hide();
end
function IsInPopoutMainFrameTimer(timerName)
	-- Hide other rows if needed
	local _, _, row = string.find(timerName, "(%d+)");
	if not kAuction:IsInPopoutMainFrame(row) then
		local i = 1;
		while _G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrameButton"..i] do
			_G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrameButton"..i]:Hide();
			i=i+1;
		end
		_G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItemSelectFrame"]:Hide();
		kAuction:Threading_StopTimer(timerName);	
		_G[timerName]:Hide();
	end
end
function IsInPopoutBidsFrameTimer(timerName)
	-- Hide other rows if needed
	local _, _, row = string.find(timerName, "(%d+)");
	if not kAuction:IsInPopoutBidsFrame(row) then
		local i = 1;
		while _G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrameButton"..i] do
			_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrameButton"..i]:Hide();
			i=i+1;
		end
		_G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWonSelectFrame"]:Hide();
		kAuction:Threading_StopTimer(timerName);
		_G[timerName]:Hide();
	end
end
function kAuction:IsInPopoutMainFrame(row)
	local objFrames = {};
	local objCurrentItemFrame = _G[kAuction.db.profile.gui.frames.main.name.."MainScrollContainerAuctionItem"..row.."CurrentItem"];
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
	local objCurrentItemFrame = _G[kAuction.db.profile.gui.frames.main.name.."BidScrollContainerBid"..row.."ItemsWon"];
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
	if kAuction.isInRaid == true and not kAuction.isActiveRaid and kAuction:Client_IsServer() then
		if kAuction:Server_IsInValidRaidZone() then -- Check for valid zone
			StaticPopup_Show("kAuctionPopup_StartRaidTracking");
		end
	elseif kAuction.isInRaid == true and kAuction.isActiveRaid == true and kAuction.enabled == true and kAuction:Client_IsServer() and not kAuction:Server_IsInValidRaidZone() and not UnitIsDeadOrGhost("player") then
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