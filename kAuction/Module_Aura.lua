-- Author      : Gabe
-- Create Date : 9/3/2009 3:25:32 PM
kAuction.gui.frames.modules.aura = {};
function kAuction:Aura_InitializeFrames()
	-- Main frame
	kAuction.gui.frames.modules.aura.main = kAuction.AceGUI:Create("Frame")
	kAuction.gui.frames.modules.aura.main:SetCallback("OnClose",function(widget,event) kAuction.AceGUI:Release(widget) end);
	kAuction.gui.frames.modules.aura.main:SetTitle("kAuction Aura")
	kAuction.gui.frames.modules.aura.main:SetLayout("Fill")
	kAuction.gui.frames.modules.aura.main:SetWidth(900);
	-- Create main frame
	kAuction:Aura_RefreshMainFrame(true);
end
function kAuction:UNIT_AURA(...)
	-- validate for player
	if not select(2,...) == "player" then return end
	-- First, check for enabled module
	if not kAuction.db.profile.modules.aura.enabled then return end
	local booMatchAura = false;
	local currentZone = GetRealZoneText();	
	local intCurrentTalentSpec = GetActiveTalentGroup();
	-- Next, check if valid aura checks exist
	if kAuction.db.profile.modules.aura.auras and #kAuction.db.profile.modules.aura.auras > 0 then
		for iAura,vAura in pairs(kAuction.db.profile.modules.aura.auras) do
			if kAuction:Aura_Validate(vAura, intCurrentTalentSpec, currentZone) then
				-- Match found, remove
				CancelUnitBuff("player", GetSpellInfo(vAura.id));
			end
		end
	end
end
function kAuction:Aura_Enable(auraId)
	if kAuction.db.profile.modules.aura.auras and #kAuction.db.profile.modules.aura.auras > 0 then
		for i,aura in pairs(kAuction.db.profile.modules.aura.auras) do
			-- Check if auraId found
			if aura.id == auraId then
				kAuction:Debug("Enabling AuraID: " .. auraId, 3);
				kAuction.db.profile.modules.aura.auras[i].enabled = true;
			end
		end
	end
end
function kAuction:Aura_Disable(auraId)
	if kAuction.db.profile.modules.aura.auras and #kAuction.db.profile.modules.aura.auras > 0 then
		for i,aura in pairs(kAuction.db.profile.modules.aura.auras) do
			-- Check if auraId found
			if aura.id == auraId then
				kAuction:Debug("Disabling AuraID: " .. auraId, 3);
				kAuction.db.profile.modules.aura.auras[i].enabled = false;
			end
		end
	end
end
function kAuction:Aura_Validate(aura, talentSpec, currentZone)
	local booPassed = false;
	local booSpec = false;
	local booZone = false;
	local booMatch = false;
	local intMatchIndex = nil;
	if aura.enabled then -- Aura enabled
		kAuction:Debug("Aura_Validate - Aura check for ["..GetSpellInfo(aura.id).."], aura.enabled.", 3);
		for i=1,40 do
			local id = select(11, UnitAura("player", i));
			-- Check if matching buff is detected
			if tonumber(aura.id) == tonumber(id) then
				kAuction:Debug("Aura_Validate - Aura check for ["..GetSpellInfo(aura.id).."], match found.", 3);
				intMatchIndex = i;
				booMatch = true;
				break;
			end
		end
		-- If match, continue verification
		if booMatch then
			-- Check specs first
			if aura.specs then
				if aura.specs[talentSpec] then -- Active spec equal to true spec
					booSpec = true;
					kAuction:Debug("Aura_Validate - Aura check for ["..GetSpellInfo(aura.id).."], removed due to Active Talent Spec match of " .. talentSpec..".", 1);
				end
			end
			-- Check zones next
			if aura.zones then
				for iZone,vZone in pairs(aura.zones) do
					-- Check if current zone exists in list and is false
					if vZone.name == currentZone and vZone.enabled then
						booZone = true;
						kAuction:Debug("Aura_Validate - Aura check for ["..GetSpellInfo(aura.id).."], removed due to Current Enabled Zone match of " .. vZone.name..".", 1);
					end
				end
			end
			-- Check Criteria
			if aura.criteria and #aura.criteria > 0 then
				local idAura;
				for iCrit,vCrit in pairs(aura.criteria) do
					-- Check that auras exist
					if vCrit.auras and #vCrit.auras > 0 then
						for iA,vA in pairs(vCrit.auras) do
							-- Check for comparison type
							for i=1,40 do
								idBuff = select(11, UnitBuff("player", i));
								idDebuff = select(11, UnitDebuff("player", i));
								-- Check if matching buff is detected
								if tonumber(vA.id) == idBuff then
									if booSpec and booZone then
										kAuction:Debug("Aura_Validate - Removing aura ["..GetSpellInfo(aura.id).."], due to Criteria Group "..iCrit.." detecting Criteria Aura match of: " .. GetSpellInfo(vA.id), 1);
										return intMatchIndex;
									end
								end
								-- Check if matching debuff is detected
								if tonumber(vA.id) == idDebuff then
									if booSpec and booZone then
										kAuction:Debug("Aura_Validate - Removing aura ["..GetSpellInfo(aura.id).."], due to Criteria Group "..iCrit.." detecting Criteria Aura match of: " .. GetSpellInfo(vA.id), 1);
										return intMatchIndex;
									end
								end
							end						
						end
					end
				end
			else
				if booSpec and booZone then
					kAuction:Debug("Aura_Validate - Removing aura ["..GetSpellInfo(aura.id).."], due to no valid Criteria Group but matching Zone and Talent Spec.", 1);
					return intMatchIndex;
				end
			end
		end
	end
	return nil;
end
function kAuction:Aura_RefreshMainFrame(initialLoad)
	kAuction.gui.frames.modules.aura.main:ReleaseChildren();
	
	kAuction.gui.frames.modules.aura.content = kAuction.AceGUI:Create("SimpleGroup")
	kAuction.gui.frames.modules.aura.content:SetLayout("Fill");	
	kAuction.gui.frames.modules.aura.content:SetHeight(100);
	kAuction.gui.frames.modules.aura.main:AddChild(kAuction.gui.frames.modules.aura.content);
	
	kAuction.gui.frames.modules.aura.addNewBox = kAuction.AceGUI:Create('EditBox');
	kAuction.gui.frames.modules.aura.addNewBox:SetWidth(210);
	kAuction.gui.frames.modules.aura.addNewBox:SetLabel('Add a New Aura');
	kAuction.gui.frames.modules.aura.addNewBox:SetPoint("TOPLEFT", kAuction.gui.frames.modules.aura.main.frame, "TOPLEFT", 10, 13);
	kAuction.gui.frames.modules.aura.addNewBox:SetCallback('OnEnterPressed', function(widget,event,val)
		if val ~= '' and GetSpellInfo(tonumber(val)) then
			kAuction:Aura_Create(val);
			kAuction.gui.frames.modules.aura.addNewBox:SetText('');
			kAuction:Aura_RefreshMainFrame();
		else
			print("kAuction: Invalid spell id entered, add aura canceled.");
		end
	end);
	--kAuction.gui.frames.modules.aura.content:AddChild(kAuction.gui.frames.modules.aura.addNewBox);
	kAuction.gui.frames.modules.aura.main:AddChild(kAuction.gui.frames.modules.aura.addNewBox);		
	
	-- Build Section Dropdown
	kAuction:Aura_CreateWidget_Tree(kAuction.gui.frames.modules.aura.content, initialLoad);
	kAuction.gui.frames.modules.aura.main:Show()
end

function kAuction:Aura_GetIndexById(id)
	for i,v in pairs(kAuction.db.profile.modules.aura.auras) do
		if tonumber(v.id) == tonumber(id) then
			-- Item exists already
			return i;
		end
	end	
	return nil;
end
--[[
	criteria = {
		{
			comparison = "or", -- OR, AND, NOT
			auras = {
				{id = 25899},
				{id = 20911}, -- Blessing of Sanctuary OR Greater Blessing of Sanctuary
			},
		}
	},	
]]
function kAuction:Aura_Create(id, enabled)
	if not type(id) == "number" then return end
	local valid = GetSpellInfo(id);
	if not valid then 
		kAuction:Print("The spell id '"..id.."' was not found in local cache or is invalid -- aura addition was cancelled.");
		return;
	end
	local iIndex = kAuction:Aura_GetIndexById(iId);
	if kAuction.db.profile.modules.aura.auras[iIndex] then -- Exists, return id
		kAuction:Print("The spell id '"..id.."' already exists -- aura addition was cancelled.");
		return;	
	else -- Doesn't exist, create
		tinsert(kAuction.db.profile.modules.aura.auras, {
			criteriaType = "ALL",
			criteria = {},
			enabled = enabled,
			id = tonumber(id), 
			specs = {
				[1] = true,
				[2] = false,
			},
			zones = {
				{name="Crystalsong Forest", enabled = true},
				{name="Icecrown Citadel", enabled = true},
				{name="Naxxramas", enabled = true},
				{name="Onyxia's Lair", enabled = true},
				{name="Orgrimmar", enabled = true},
				{name="The Obsidian Sanctum", enabled = true},
				{name="Trial of the Crusader", enabled = true},
				{name="Ulduar", enabled = true},
				{name="Vault of Archavon", enabled = true},
			},
		});
		return iId;		
	end
end
function kAuction:Aura_Delete(id)
	local index = kAuction:Aura_GetIndexById(id);
	if index then
		-- Remove item from local
		tremove(kAuction.db.profile.modules.aura.auras, index);
	end	
end
function kAuction:Aura_DeleteCriteriaGroup(aura, group)
	for i,v in pairs(aura.criteria) do
		if v == group then
			tremove(aura.criteria, i);
		end
	end
end
function kAuction:Aura_DeleteCriteriaGroupAura(group, id)
	for i,v in pairs(group.auras) do
		if v.id == id then
			tremove(group.auras, i);
		end
	end
end
function kAuction:Aura_CreateWidget_Tree(parent)
	local list = kAuction.db.profile.modules.aura.auras;
	if not list or #list == 0 then return end
	local tree = {};
	for i,v in pairs(list) do
		local sName, sRank, sIcon = GetSpellInfo(v.id);
		tinsert(tree, {icon = sIcon, text = sName, value = v.id,
			children = {
				{
					text = 'Delete',
					value = '_delete_' .. v.id,
				},
			},});
	end
	kAuction.gui.frames.modules.aura.tree = kAuction.AceGUI:Create("TreeGroup")
	kAuction.gui.frames.modules.aura.tree:SetCallback('OnGroupSelected', function(widget,event,value,d,e)
		local s1, s2, s3 = strsplit('_', value);
		if s2 == 'delete' then
			StaticPopupDialogs["kAuctionPopup_PromptAuraDelete"] = {
				text = "|cFF"..kAuction:RGBToHex(0,255,0).."kAuction|r|nDo you really wish to delete the |cFF"..kAuction:RGBToHex(0,255,0).. GetSpellInfo(tonumber(s3)) .."|r Aura?",
				OnAccept = function()
					kAuction:Aura_Delete(tonumber(s3));
					kAuction:Aura_RefreshMainFrame();					
				end,
				button1 = "Delete",
				button2 = "Cancel",
				OnCancel = function()
					return;
				end,
				timeout = 0,
				whileDead = 1,
				hideOnEscape = 1,
				hasEditBox = false,
				showAlert = true,
			};	
			StaticPopup_Show("kAuctionPopup_PromptAuraDelete");
		end
		if s3 then
			kAuction:Aura_ShowAura(kAuction.gui.frames.modules.aura.tree, tonumber(s3));
		else
			kAuction:Aura_ShowAura(kAuction.gui.frames.modules.aura.tree, value);
		end
	end);
	kAuction.gui.frames.modules.aura.tree:SetLayout("Fill")
	kAuction.gui.frames.modules.aura.tree:SetTree(tree)
	parent:AddChild(kAuction.gui.frames.modules.aura.tree);	
end
function kAuction:Aura_GetById(id)
	if kAuction.db.profile.modules.aura.auras and id then
		for i,v in pairs(kAuction.db.profile.modules.aura.auras) do
			if id == v.id then
				return v;
			end
		end
	end
	return nil;
end
function kAuction:Aura_AddCriteriaGroup(id)
	local aura = kAuction:Aura_GetById(id);
	if not aura then return end
	tinsert(aura.criteria, {
		comparison = "ANY",
		buffs = {},
	});
end
function kAuction:Aura_AddCriteriaGroupAura(group, id)
	if not type(id) == "number" then return end
	local valid = GetSpellInfo(id);
	if not valid then 
		kAuction:Print("The spell id '"..id.."' was not found in local cache or is invalid -- aura addition was cancelled.");
		return;
	end
	local booFound = false;
	if not group.auras then group.auras = {} end
	for i,v in pairs(group.auras) do
		if v.id == tonumber(id) then
			booFound = true;
		end
	end
	if booFound then -- Exists, return id
		kAuction:Print("The spell id '"..id.."' already exists -- aura addition was cancelled.");
		return;	
	else -- Doesn't exist, create
		tinsert(group.auras, {id = id});
	end
end
--[[
criteria = {
	{
		comparison = "ANY", -- ANY, ALL, NONE
		auras = {
			{25899, 20911}, -- Blessing of Sanctuary OR Greater Blessing of Sanctuary
		},
	}
},	
]]
function kAuction:Aura_ShowAura(parent, id)
	if not id then return end
	local aura = kAuction:Aura_GetById(id);
	-- Check if valid weight returned
	if aura then
		if kAuction.gui.frames.modules.aura.tree then
			kAuction.gui.frames.modules.aura.tree:ReleaseChildren();
		end
		local fScroll = kAuction.AceGUI:Create("ScrollFrame")
		fScroll:SetFullWidth(true);
		fScroll:SetLayout("Flow")
		
		-- About
		local lAbout = kAuction.AceGUI:Create("Label");
		lAbout:SetFullWidth(true);
		lAbout:SetText("The kAuction Aura Module is primarily designed to automatically remove specific auras (buffs) from the player based on certain criteria.  These criteria can be zone, current talent spec, and also a mix and match of other auras currently active or not active on the player.  To enter new auras to track and remove, use the box at the top left and enter the exact spell id.");
		fScroll:AddChild(lAbout);
		
		-- Settings Header
		local fSettingsHeader = kAuction.AceGUI:Create("Heading");
		fSettingsHeader:SetFullWidth(true);
		fSettingsHeader:SetText(GetSpellInfo(aura.id) .. " Settings");
		fScroll:AddChild(fSettingsHeader);
		
		local fInlineSettings = kAuction.AceGUI:Create("SimpleGroup");
		fInlineSettings:SetFullWidth(true);
		fInlineSettings:SetLayout("Flow");
		fInlineSettings.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fInlineSettings.frame,0,0,0,0);
		fScroll:AddChild(fInlineSettings);	
		
		local iIcon = kAuction.AceGUI:Create("Icon");
		iIcon:SetImageSize(35, 35);
		iIcon:SetWidth(35);
		iIcon:SetHeight(35);
		iIcon:SetImage(select(3, GetSpellInfo(aura.id)));
		iIcon:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:ClearLines();
			GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");						
			GameTooltip:SetHyperlink(("spell:%s"):format(aura.id))
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
		end);
		iIcon:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
		end);
		fInlineSettings:AddChild(iIcon);
		
		local cEnabled = kAuction.AceGUI:Create("CheckBox");
		cEnabled:SetType('checkbox');
		cEnabled:SetValue(aura.enabled);
		cEnabled:SetLabel('Enabled');
		cEnabled:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:ClearLines();
			GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Enabled|r");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
				"Determines if this Aura will be checked for auto-removal.|r");
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
		end);
		cEnabled:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
		end);
		cEnabled:SetCallback("OnValueChanged", function(widget,event,val)
			kAuction.gui.frames.modules.aura.auraValueChanged = true;
			kAuction:Aura_SetFlag(aura.id, 'enabled', val);
		end);
		fInlineSettings:AddChild(cEnabled);
		
		-- Active Talent Tree Header
		local fSettingsHeaderTalent = kAuction.AceGUI:Create("Heading");
		fSettingsHeaderTalent:SetFullWidth(true);
		fSettingsHeaderTalent:SetText("Active Talent Tree Criteria");
		fScroll:AddChild(fSettingsHeaderTalent);
		
		local fInlineSettingsTalent = kAuction.AceGUI:Create("SimpleGroup");
		fInlineSettingsTalent:SetFullWidth(true);
		fInlineSettingsTalent:SetLayout("Flow");
		fInlineSettingsTalent.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fInlineSettingsTalent.frame,0,0,0,0);
		fScroll:AddChild(fInlineSettingsTalent);	
		
		-- talent tree criteria
		local cTalent1 = kAuction.AceGUI:Create("CheckBox");
		cTalent1:SetType('checkbox');
		cTalent1:SetValue(aura.specs[1]);
		cTalent1:SetLabel("Talent Spec #1");
		cTalent1:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:ClearLines();
			GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).. "Talent Spec #1 Toggle|r");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
				"Determines if this buff will auto-remove when Talent Spec #1 is active.|r");
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
		end);
		cTalent1:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
		end);
		cTalent1:SetCallback("OnValueChanged", function(widget,event,val)
			kAuction.gui.frames.modules.aura.auraValueChanged = true;
			aura.specs[1] = val;
		end);
		fInlineSettingsTalent:AddChild(cTalent1);
		
		-- talent tree criteria
		local cTalent2 = kAuction.AceGUI:Create("CheckBox");
		cTalent2:SetType('checkbox');
		cTalent2:SetValue(aura.specs[2]);
		cTalent2:SetLabel("Talent Spec #2");
		cTalent2:SetCallback("OnEnter", function(widget,event,val)
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:ClearLines();
			GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Talent Spec #2 Toggle");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
				"Determines if this buff will auto-remove when Talent Spec #2 is active.|r");
			GameTooltip:Show();
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
		end);
		cTalent2:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
		end);
		cTalent2:SetCallback("OnValueChanged", function(widget,event,val)
			kAuction.gui.frames.modules.aura.auraValueChanged = true;
			aura.specs[2] = val;
		end);
		fInlineSettingsTalent:AddChild(cTalent2);
					
		-- Zone Criteria Header
		local fSettingsHeaderZone = kAuction.AceGUI:Create("Heading");
		fSettingsHeaderZone:SetFullWidth(true);
		fSettingsHeaderZone:SetText("Zone Criteria");
		fScroll:AddChild(fSettingsHeaderZone);
		
		local fInlineSettingsZone = kAuction.AceGUI:Create("SimpleGroup");
		fInlineSettingsZone:SetFullWidth(true);
		fInlineSettingsZone:SetLayout("Flow");
		fInlineSettingsZone.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
		kAuction:Gui_SetFrameBackdropColor(fInlineSettingsZone.frame,0,0,0,0);
		fScroll:AddChild(fInlineSettingsZone);
		
		if aura.zones and #aura.zones > 0 then
			for i,v in pairs(aura.zones) do
				local cZone = kAuction.AceGUI:Create("CheckBox");
				cZone:SetType('checkbox');
				cZone:SetValue(v.enabled);
				cZone:SetLabel(v.name);
				cZone:SetCallback("OnEnter", function(widget,event,val)
					GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
					GameTooltip:ClearLines();
					GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
					GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0)..v.name.. " Enabled|r");
					GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
						"Determines if "..v.name.." is a valid zone in which to remove this buff.|r");
					GameTooltip:Show();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
				end);
				cZone:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				cZone:SetCallback("OnValueChanged", function(widget,event,val)
					kAuction.gui.frames.modules.aura.auraValueChanged = true;
					v.enabled = val;
				end);
				fInlineSettingsZone:AddChild(cZone);		
			end
		end

		-- Criteria Header
		local fSettingsCriteriaHeader = kAuction.AceGUI:Create("Heading");
		fSettingsCriteriaHeader:SetFullWidth(true);
		fSettingsCriteriaHeader:SetText("Other Buffs");
		fScroll:AddChild(fSettingsCriteriaHeader);
		
		-- Overall Comparison Type
		--[[
		fCritCompOverall = kAuction.AceGUI:Create("Dropdown");
		fCritCompOverall:SetList({["ANY"] = "ANY", ["ALL"] = "ALL", ["NONE"] = "NONE"});
		fCritCompOverall:SetValue(aura.criteriaType);
		fCritCompOverall:SetLabel("Overall Comparison Type");
		fCritCompOverall:SetCallback("OnValueChanged", function(widget,event,val)
			kAuction.gui.frames.modules.aura.auraValueChanged = true;
			aura.criteriaType = val;
		end);
		fCritCompOverall:SetCallback("OnEnter", function(widget,event,val)
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:ClearLines();
			GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Overall Comparison Type|r");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
			"Determine each individual group of criteria buffs below compare to one another.|n"..
			"If the all criteria groups meet the comparison type, the check |n"..
			"is considered valid and this buff is valid for auto-removal.|n"..
			"|n"..
			"'ANY' - If any of the below criteria groups are valid, the buff is valid for auto-removal.|n"..
			"'ALL' - Only if all below criteria groups are valid is the buff valid for auto-removal.|n"..
			"'NONE' - If none of the below criteria groups are valid, the buff is valid for auto-removal.|r");
			GameTooltip:Show();
		end);
		fCritCompOverall:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
		end);
		fScroll:AddChild(fCritCompOverall);
		]]
		-- Create Criteria Group
		bCreateCriteria = kAuction.AceGUI:Create("Button");
		bCreateCriteria:SetText("Add New Criteria Group");
		bCreateCriteria:SetWidth(190); -- 45	
		bCreateCriteria:SetCallback("OnClick", function(widget,event,val)
			kAuction:Aura_AddCriteriaGroup(aura.id);
			kAuction:Aura_ShowAura(kAuction.gui.frames.modules.aura.tree, aura.id);
		end);
		bCreateCriteria:SetCallback("OnEnter", function(widget,event,val)
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
			GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
			GameTooltip:ClearLines();
			GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Add Criteria Group|r");
			GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
			"Click to add a new criteria group set of buffs to validate.|r");
			GameTooltip:Show();
		end);
		bCreateCriteria:SetCallback("OnLeave", function(widget,event,val)
			GameTooltip:Hide();
			kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
		end);
		fScroll:AddChild(bCreateCriteria);
		
		if aura.criteria and #aura.criteria > 0 then
			--[[
				criteria = {
					{
						comparison = "ANY", -- ANY, ALL, NONE
						buffs = {
							{25899, 20911}, -- Blessing of Sanctuary OR Greater Blessing of Sanctuary
						},
					}
				},	
			]]			
			for i,v in pairs(aura.criteria) do
				local fInlineSettingsCriteria = kAuction.AceGUI:Create("SimpleGroup");
				fInlineSettingsCriteria:SetFullWidth(true);
				fInlineSettingsCriteria:SetLayout("Flow");
				fInlineSettingsCriteria.frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",});
				kAuction:Gui_SetFrameBackdropColor(fInlineSettingsCriteria.frame,0,0,0,0);
				fScroll:AddChild(fInlineSettingsCriteria);
				
				local fSettingsCritGroupHeader = kAuction.AceGUI:Create("Heading");
				fSettingsCritGroupHeader:SetFullWidth(true);
				fSettingsCritGroupHeader:SetText("Criteria Group "..i);
				fInlineSettingsCriteria:AddChild(fSettingsCritGroupHeader);
				
				local eAddBuff = kAuction.AceGUI:Create('EditBox');
				eAddBuff:SetWidth(210);
				eAddBuff:SetLabel('Add a New Criteria Aura to Criteria Group '..i);
				eAddBuff:SetPoint("TOPRIGHT", fSettingsCritGroupHeader.frame, "BOTTOMRIGHT", 0, 15);
				eAddBuff:SetCallback('OnEnterPressed', function(widget,event,val)
					if val ~= '' then
						kAuction:Aura_AddCriteriaGroupAura(v, val);
						eAddBuff:SetText('');
						kAuction:Aura_ShowAura(kAuction.gui.frames.modules.aura.tree, aura.id);
					end
				end);
				fInlineSettingsCriteria:AddChild(eAddBuff);
				
				--[[
				-- Create Other Buff Comparison
				fCriteriaComparison = kAuction.AceGUI:Create("Dropdown");
				fCriteriaComparison:SetList({["ANY"] = "ANY", ["ALL"] = "ALL", ["NONE"] = "NONE"});
				fCriteriaComparison:SetValue(v.comparison);
				fCriteriaComparison:SetLabel("Comparison Type");
				fCriteriaComparison:SetCallback("OnValueChanged", function(widget,event,val)
					kAuction.gui.frames.modules.aura.auraValueChanged = true;
					v.comparison = val;
				end);
				fCriteriaComparison:SetCallback("OnEnter", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
					GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
					GameTooltip:ClearLines();
					GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
					GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Comparison Type|r");
					GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
					"Determine how the buffs in this Criteria will validate against each other.|n"..
					"Each buff listed is compared to each other buff via the selected comparison type.|n"..
					"If the all buffs meet the criteria, the check is considered valid and this buff is valid for auto-removal.|n"..
					"|n"..
					"'ANY' - If any of the specified buffs are detected on the player, a criteria is considered valid.|n"..
					"'ALL' - Only if all specified buffs are detected is the criteria check considered valid.|n"..
					"'NONE' - If none of the specified buffs are detected, the criteria check considered valid.|r");
					GameTooltip:Show();
				end);
				fCriteriaComparison:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				fInlineSettingsCriteria:AddChild(fCriteriaComparison);
				]]
				-- Delete Criteria Group
				bDeleteGroup = kAuction.AceGUI:Create("Button");
				bDeleteGroup:SetText("Delete Group");
				bDeleteGroup:SetWidth(130);
				bDeleteGroup:SetCallback("OnClick", function(widget,event,val)
					kAuction:Aura_DeleteCriteriaGroup(aura, v);
					kAuction:Aura_ShowAura(kAuction.gui.frames.modules.aura.tree, aura.id);
				end);
				bDeleteGroup:SetCallback("OnEnter", function(widget,event,val)
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
					GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
					GameTooltip:ClearLines();
					GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
					GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Delete Criteria Group|r");
					GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
					"Click to delete the entirety of Criteria Group " .. i .." aura from this Criteria Group.|r");
					GameTooltip:Show();
				end);
				bDeleteGroup:SetCallback("OnLeave", function(widget,event,val)
					GameTooltip:Hide();
					kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
				end);
				fInlineSettingsCriteria:AddChild(bDeleteGroup);
				
				if v.auras and #v.auras > 0 then
					for iAura,vAura in pairs(v.auras) do
						-- Aura
						local lAura = kAuction.AceGUI:Create("InteractiveLabel");
						lAura:SetText(GetSpellInfo(vAura.id));
						lAura:SetImage(select(3, GetSpellInfo(vAura.id)));
						lAura:SetImageSize(30, 30);
						lAura:SetCallback("OnEnter", function(widget,event,val)
							GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
							GameTooltip:ClearLines();
							GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");						
							GameTooltip:SetHyperlink(("spell:%s"):format(vAura.id))
							GameTooltip:Show();
							kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
						end);
						lAura:SetCallback("OnLeave", function(widget,event,val)
							GameTooltip:Hide();
							kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
						end);
						fInlineSettingsCriteria:AddChild(lAura);
						-- Create Criteria Group
						bDeleteAura = kAuction.AceGUI:Create("Button");
						bDeleteAura:SetText("Delete Aura");
						bDeleteAura:SetWidth(80);
						bDeleteAura:SetCallback("OnClick", function(widget,event,val)
							kAuction:Aura_DeleteCriteriaGroupAura(v, vAura.id);
							kAuction:Aura_ShowAura(kAuction.gui.frames.modules.aura.tree, aura.id);
						end);
						bDeleteAura:SetCallback("OnEnter", function(widget,event,val)
							kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0.9,0.9,0.9,0.1);
							GameTooltip:SetOwner(WorldFrame,"ANCHOR_NONE");
							GameTooltip:ClearLines();
							GameTooltip:SetPoint("TOPRIGHT", widget.frame, "TOPLEFT");
							GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,150,0).."Delete Criteria Group Aura|r");
							GameTooltip:AddLine("|cFF"..kAuction:RGBToHex(255,255,255,1)..
							"Click to delete the "..GetSpellInfo(vAura.id).." aura from this Criteria Group.|r");
							GameTooltip:Show();
						end);
						bDeleteAura:SetCallback("OnLeave", function(widget,event,val)
							GameTooltip:Hide();
							kAuction:Gui_SetFrameBackdropColor(widget.parent.frame,0,0,0,0);
						end);
						fInlineSettingsCriteria:AddChild(bDeleteAura);
						bDeleteAura:SetRelativeWidth(0.18);					
						lAura:SetRelativeWidth(0.8);
											
					end
				end
			end	
		end
		
		if parent then
			parent:AddChild(fScroll);
		else
			kAuction.gui.frames.modules.aura.tree:AddChild(fScroll);
		end
	end
end
function kAuction:Aura_SetFlag(id, flagType, value)
	local index = kAuction:Aura_GetIndexById(id);
	if index then
		kAuction.db.profile.modules.aura.auras[index][flagType] = value;
		return true;
	end
	return false;
end