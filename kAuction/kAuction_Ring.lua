-- Author      : Gabe
-- Create Date : 3/2/2009 3:56:10 PM
function kAuction:Ring_CreateRing(name, propsTable)
	local id, status = kAuction.ring:CreateRing(name, propsTable);
	return id, status;
end
function kAuction:Ring_InitializeTestRing()
	kAuction:Debug("FUNC: Ring_InitializeTestRing, Creating test ring.", 1);
	kAuction.ring = _G["OneRingLib"];
	if not (type(kAuction.ring) == "table" and type(kAuction.ring.CreateRing) == "function") then
		kAuction:Debug("FILE: kAuction_Ring, OneRingLib or OneRingLib.CreateRing not valid.", 1);
		return;
	end
	local rname, rdesc = "BlahName", {
		{"func", r=1, g=1, b=0}, -- yellow star
		{"func", r=1, g=0.5, b=0.05}, -- orange circle
		{"func", r=1, g=0.30, b=1}, -- purple diamond
		{"func", r=0.20, g=1, b=0.20}, -- green triangle
		{"func", r=0.65, g=0.84, b=1}, -- silver moon
		{"func", r=0.20, g=0.20, b=1}, -- blue square
		{"func", r=1, g=0.10, b=0.10}, -- red cross
		{"func", r=0.74, g=0.70, b=0.60}, -- white skull
		name="Blah", hotkey="ALT-H"
	};
	local function ringClick(ring, id)
		if GetRaidTargetIndex("target") == id then id = 0; end
		SetRaidTarget("target", id);
	end
	for i=1,8 do
		rdesc[i][2], rdesc[i][3], rdesc[i].icon = ringClick, i, "Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. i;
	end
	kAuction.ring:CreateRing(rname, rdesc);
end
function kAuction:Ring_CreateTestRing()
	OneRing:RegisterRing(rname, function() kAuction:Ring_InitializeTestRing() end);
end
function Ring_RingClick(id)
	if GetRaidTargetIndex("target") == id then id = 0; end
	SetRaidTarget("target", id);
end