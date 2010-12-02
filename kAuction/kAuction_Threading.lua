-- Author      : Gabe
-- Create Date : 2/19/2009 12:42:59 AM
function kAuction:Threading_CreateTimer(name,func,delay,rep,arg)
	kAuction.threading.timerPool[name] = { func=func,delay=delay,rep=rep,elapsed=delay,arg=arg };
	local newFrame = CreateFrame("Frame",name,UIParent)	
	newFrame:SetPoint("TOPLEFT", -50, -50);
	newFrame:SetScript("OnUpdate", function(self, elapsed) kAuction:Threading_OnUpdate(self, elapsed) end);
	newFrame:Hide();
end
function kAuction:Threading_IsTimerActive(name)
	for i,j in ipairs(kAuction.threading.timers) do
		if j==name then
			return i;
		end
	end
	return nil;
end
function kAuction:Threading_OnUpdate(frame, elapsed)
	local timerPool
	for _,name in ipairs(kAuction.threading.timers) do
		-- Check for proper frame match
		if frame:GetName() == name then
			timerPool = kAuction.threading.timerPool[name]
			timerPool.elapsed = timerPool.elapsed - elapsed
			if timerPool.elapsed < 0 then
				if timerPool.arg then
					timerPool.func(timerPool.arg)
				else
					timerPool.func()
				end
				if timerPool.rep then
					timerPool.elapsed = timerPool.delay
				else
					kAuction:Threading_StopTimer(name)
				end
			end
		end
	end	
end
function kAuction:Threading_StartTimer(name,delay)
	if kAuction.threading.timerPool[name] then
		kAuction.threading.timerPool[name].elapsed = delay or kAuction.threading.timerPool[name].delay
		if not kAuction:Threading_IsTimerActive(name) then
			tinsert(kAuction.threading.timers, name);
			_G[name]:Show();
		end
	end
end
function kAuction:Threading_StopTimer(name)
	local i = kAuction:Threading_IsTimerActive(name)
	if i then
		tremove(kAuction.threading.timers,i)
		if #(kAuction.threading.timers) < 1 then
			_G[name]:Hide();
		end
	end
end
function kAuction:Threading_UpdateThreadingFrame(name)
	local frame = _G[name];
	if not frame then -- Create
		if string.find(name, "kAuctionThreadingFrameMain") then
			kAuction:Threading_CreateTimer(name,IsInPopoutMainFrameTimer,kAuction.db.profile.gui.frames.main.itemPopoutDuration,1,name);
		elseif string.find(name, "kAuctionThreadingFrameBids") then
			kAuction:Threading_CreateTimer(name,IsInPopoutBidsFrameTimer,kAuction.db.profile.gui.frames.bids.itemPopoutDuration,1,name);
		end
	end
end