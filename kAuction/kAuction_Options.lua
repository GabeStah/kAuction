-- Author      : Gabe
-- Create Date : 2/15/2009 7:20:42 PM
kAuction.minRequiredVersion = 0.9251;
kAuction.version = 0.9251;
kAuction.versions = {};

kAuction.const = {};
kAuction.const.items = {};
kAuction.const.raid = {};
kAuction.const.raid.presenceTick = 60;
kAuction.const.items.ItemEquipLocs = {
	{name = "INVTYPE_AMMO", slotName = "AmmoSlot", slotNumber = 0, formattedName = "Ammo",},
	{name = "INVTYPE_HEAD", slotName = "HeadSlot", slotNumber = 1, formattedName = "Head",},
	{name = "INVTYPE_NECK", slotName = "NeckSlot", slotNumber = 2, formattedName = "Neck",},
	{name = "INVTYPE_SHOULDER", slotName = "ShoulderSlot", slotNumber = 3, formattedName = "Shoulder",},
	{name = "INVTYPE_BODY", slotName = "ShirtSlot", slotNumber = 4, formattedName = "Shirt",},
	{name = "INVTYPE_CHEST", slotName = "ChestSlot", slotNumber = 5, formattedName = "Chest",},
	{name = "INVTYPE_ROBE", slotName = "ChestSlot", slotNumber = 5, formattedName = "Chest",},
	{name = "INVTYPE_WAIST", slotName = "WaistSlot", slotNumber = 6, formattedName = "Waist",},
	{name = "INVTYPE_LEGS", slotName = "LegsSlot", slotNumber = 7, formattedName = "Legs",},
	{name = "INVTYPE_FEET", slotName = "FeetSlot", slotNumber = 8, formattedName = "Feet",},
	{name = "INVTYPE_WRIST", slotName = "WristSlot", slotNumber = 9, formattedName = "Wrist",},
	{name = "INVTYPE_HAND", slotName = "HandsSlot", slotNumber = 10, formattedName = "Hands",},
	{name = "INVTYPE_FINGER", slotName = "Finger0Slot", slotNumber = 11, formattedName = "Finger",},
	{name = "INVTYPE_TRINKET", slotName = "Trinket0Slot", slotNumber = 13, formattedName = "Trinket",},
	{name = "INVTYPE_CLOAK", slotName = "BackSlot", slotNumber = 15, formattedName = "Back",},
	{name = "INVTYPE_WEAPON", slotName = "MainHandSlot", slotNumber = 16, formattedName = "Main Hand",},
	{name = "INVTYPE_SHIELD", slotName = "SecondaryHandSlot", slotNumber = 17, formattedName = "Offhand",},
	{name = "INVTYPE_2HWEAPON", slotName = "MainHandSlot", slotNumber = 16, formattedName = "Main Hand",},
	{name = "INVTYPE_WEAPONMAINHAND", slotName = "MainHandSlot", slotNumber = 16, formattedName = "Main Hand",},
	{name = "INVTYPE_WEAPONOFFHAND", slotName = "SecondaryHandSlot", slotNumber = 17, formattedName = "Offhand",},
	{name = "INVTYPE_HOLDABLE", slotName = "SecondaryHandSlot", slotNumber = 17, formattedName = "Offhand",},
	{name = "INVTYPE_RANGED", slotName = "RangedSlot", slotNumber = 18, formattedName = "Ranged",},
	{name = "INVTYPE_THROWN", slotName = "RangedSlot", slotNumber = 18, formattedName = "Ranged",},
	{name = "INVTYPE_RANGEDRIGHT", slotName = "RangedSlot", slotNumber = 18, formattedName = "Ranged",},
	{name = "INVTYPE_RELIC", slotName = "RangedSlot", slotNumber = 18, formattedName = "Ranged",},
	{name = "INVTYPE_TABARD", slotName = "TabardSlot", slotNumber = 19, formattedName = "Tabard",},
	{name = "INVTYPE_BAG", slotName = "Bag0Slot", slotNumber = 20, formattedName = "Bag",},
	{name = "INVTYPE_QUIVER", slotName = nil, slotNumber = 20, formattedName = "Ammo",},
};
kAuction.const.chatPrefix = "<kAuction> ";
kAuction.const.wishlist = {};
kAuction.const.wishlist.autoUpdateFrequency = 10;
kAuction.const.wishlist.atlasLootTableName = "AtlasLootWishList";
kAuction.defaults = {
	profile = {
		modules = {
			aura = {
				enabled = true,
				auras = {
					{
						criteria = {
							{
								comparison = "ANY", -- ANY, ALL, NONE
								auras = {
									{id = 73780}, -- Infest Heroic 
									{id = 70541}, -- Infest Normal
									{id = 33844}, -- Entangling Roots
								},
							},
						},
						criteriaType = "ALL",
						enabled = false,
						id = 47440, -- Commanding Shout
						specs = {
							[1] = true,
							[2] = true,
						},
						zones = {
							{name="Crystalsong Forest", enabled = true},
							{name="Icecrown Citadel", enabled = true},
							{name="Naxxramas", enabled = false},
							{name="Onyxia's Lair", enabled = false},
							{name="Orgrimmar", enabled = false},
							{name="The Obsidian Sanctum", enabled = false},
							{name="Trial of the Crusader", enabled = false},
							{name="Ulduar", enabled = false},
							{name="Vault of Archavon", enabled = false},
						},
					},
					{
						criteria = {
							{
								comparison = "ANY", -- ANY, ALL, NONE
								auras = {
									{id = 73780}, -- Infest Heroic 
									{id = 70541}, -- Infest Normal
									{id = 33844}, -- Entangling Roots
								},
							},
						},
						criteriaType = "ALL",
						enabled = false,
						id = 72590, -- Fortitude (Scroll)
						specs = {
							[1] = true,
							[2] = true,
						},
						zones = {
							{name="Crystalsong Forest", enabled = true},
							{name="Icecrown Citadel", enabled = true},
							{name="Naxxramas", enabled = false},
							{name="Onyxia's Lair", enabled = false},
							{name="Orgrimmar", enabled = false},
							{name="The Obsidian Sanctum", enabled = false},
							{name="Trial of the Crusader", enabled = false},
							{name="Ulduar", enabled = false},
							{name="Vault of Archavon", enabled = false},
						},
					},
					{
						criteria = {
							{
								comparison = "ANY", -- ANY, ALL, NONE
								auras = {
									{id = 73780}, -- Infest Heroic 
									{id = 70541}, -- Infest Normal
									{id = 33844}, -- Entangling Roots
								},
							},
						},
						criteriaType = "ALL",
						enabled = false,
						id = 72586, -- Mark of the Wild (Drums)
						specs = {
							[1] = true,
							[2] = true,
						},
						zones = {
							{name="Crystalsong Forest", enabled = true},
							{name="Icecrown Citadel", enabled = true},
							{name="Naxxramas", enabled = false},
							{name="Onyxia's Lair", enabled = false},
							{name="Orgrimmar", enabled = false},
							{name="The Obsidian Sanctum", enabled = false},
							{name="Trial of the Crusader", enabled = false},
							{name="Ulduar", enabled = false},
							{name="Vault of Archavon", enabled = false},
						},
					},
					{
						criteria = {
							{
								comparison = "ANY", -- ANY, ALL, NONE
								auras = {
									{id = 73780}, -- Infest Heroic 
									{id = 70541}, -- Infest Normal
									{id = 33844}, -- Entangling Roots
								},
							},
						},
						criteriaType = "ALL",
						enabled = false,
						id = 48162, -- Prayer of Fortitude
						specs = {
							[1] = true,
							[2] = true,
						},
						zones = {
							{name="Crystalsong Forest", enabled = true},
							{name="Icecrown Citadel", enabled = true},
							{name="Naxxramas", enabled = false},
							{name="Onyxia's Lair", enabled = false},
							{name="Orgrimmar", enabled = false},
							{name="The Obsidian Sanctum", enabled = false},
							{name="Trial of the Crusader", enabled = false},
							{name="Ulduar", enabled = false},
							{name="Vault of Archavon", enabled = false},
						},
					},
					{
						criteria = {
							{
								comparison = "ANY", -- ANY, ALL, NONE
								auras = {
									{id = 73780}, -- Infest Heroic 
									{id = 70541}, -- Infest Normal
									{id = 33844}, -- Entangling Roots
								},
							},
						},
						criteriaType = "ALL",
						enabled = false,
						id = 48470, -- Gift of the Wild
						specs = {
							[1] = true,
							[2] = true,
						},
						zones = {
							{name="Crystalsong Forest", enabled = true},
							{name="Icecrown Citadel", enabled = true},
							{name="Naxxramas", enabled = false},
							{name="Onyxia's Lair", enabled = false},
							{name="Orgrimmar", enabled = false},
							{name="The Obsidian Sanctum", enabled = false},
							{name="Trial of the Crusader", enabled = false},
							{name="Ulduar", enabled = false},
							{name="Vault of Archavon", enabled = false},
						},
					},
				},
			},
			theTraitorKing = {
				enabled = true,
			},
		},
		coords = {
		},
		debug = {
			enabled = false,
			threshold = 1,
		},
		bidding = {
			auctionReceivedEffect = 3,
			auctionReceivedSound = "Info",
			auctionReceivedTextAlert = 2,
			auctionWinnerReceivedEffect = 1,
			auctionWinnerReceivedSound = "Sonar",
			auctionWinnerReceivedTextAlert = 2,
			auctionWonEffect = 3,
			auctionWonSound = "Victory",
			auctionWonTextAlert = 2,
			autoPopulateCurrentItem = true,
		},
		gui = {
			frames = {
				bids = {
					font = "ABF",
					fontSize = 12,
					itemPopoutDuration = 1,					
					minimized = false,
					visible = true,
					width = 325,
				},
				main = {
					autoRemoveAuctions = false,
					autoRemoveAuctionsDelay = 20,
					barBackgroundColor = {r = 0.5, g = 0.5, b = 0.5, a = 0.5},
					barColor = {r = 1, g = 0, b = 0, a = 1},
					barTexture = "BantoBar",
					font = "ABF",
					fontSize = 12,
					height = 152,
					itemPopoutDuration = 1,					
					minimized = false,
					name = "kAuctionMainFrame",
					scale = 1,
					selectedBarBackgroundColor = {r = 0.5, g = 0.5, b = 0.5, a = 0.5},
					selectedBarColor = {r = 0, g = 1, b = 0, a = 0.3},
					selectedBarTexture = "BantoBar",
					visible = true,
					width = 325,
					tabs = {
						selectedColor = {r = 0.1, g = 0, b = 0.9, a = 0.25},
						highlightColor = {r = 0.05, g = 0, b = 0.85, a = 0.15},
						inactiveColor = {r = 0, g = 0, b = 0, a = 0},
					},
				},
			},
		},
		items = {
			blackList = { -- Items
				"Badge of Justice",
				"Emblem of Conquest",
				"Emblem of Heroism",
				"Emblem of Valor",
				"Emblem of Triumph",
			},	
			blackListSelected = 1,
			itemTypeWhiteList = {
				{name = "INVTYPE_BAG", auctionType = 1, pattern = INVTYPE_BAG}, -- Random
				{name = "ITEM_BIND_QUEST", auctionType = false, pattern = ITEM_BIND_QUEST},
				{name = "ITEM_SOULBOUND", auctionType = false, pattern = ITEM_SOULBOUND},
				{name = "ITEM_STARTS_QUEST", auctionType = 1, pattern = ITEM_STARTS_QUEST}, -- Random
			},
			itemTypeWhiteListSelected = 1,
			whiteList = { -- Items		
				--MISC
				{name = "Archivum Data Disc", auctionType = 1},
				{name = "Heroic Key to the Focusing Iris", auctionType = 1, currentItemSlot = 2}, -- Random, Neck
				{name = "Key to the Focusing Iris", auctionType = 1, currentItemSlot = 2}, -- Random, Neck
				{name = "Large Satchel of Spoils", auctionType = 1}, -- Random
				{name = "Reins of the Twilight Drake", auctionType = 1}, -- Random
				{name = "Reply-Code Alpha", auctionType = 1}, -- Random
				{name = "Satchel of Spoils", auctionType = 1}, -- Random
				{name = "Trophy of the Crusade", auctionType = 2},
			},	
			whiteListConfig = {
				add = {
					auctionTypeSelected = 0,
					itemSlotSelected = 0,
					name = false,
				},
			},			
			whiteListSelected = 1,
		},
		looting = {
			auctionWhisperBidEnabled = true,
			auctionWhisperBidSuppressionEnabled = true,
			auctionWhisperBidSuppressionDelay = 60,
			auctionCloseDelay = 3,
			auctionDuration = 25,
			auctionCloseVoteDuration = 20,
			auctionType = 2, -- 1: Random, 2: Council
			autoAwardRandomAuctions = true,
			autoAssignIfMasterLoot = true,
			councilMembers = {
				"Pohx",
				"Kulldam",
				"Khrashdin",
				"Kilwenn",
				"Huggeybear",
				"Ugra",
				"Kheelan",
			},
			councilMemberSelected = 1,
			disenchanters = { -- Disenchanters
				"Khrashdin",
				"Thawfore",
				"Wakamii",
			},	
			disenchanterSelected = 1,
			displayFirstOpenAuction = false,
			isAutoAuction = true,
			rarityThreshold = 4, -- Epic
			lootManager = nil,
			rollMaximum = 100,
			visiblePublicBidCurrentItems = true,
			visiblePublicBidRolls = true,
			visiblePublicBidVoters = true,
			visiblePublicDetails = true,
		},
		wishlist = {
			enabled = true,
			autoUpdate = true,
			config = {
				selectedSection = 'search',
				searchReturnLimit = 50,
				searchMinRarity = 4,
				searchMinItemLevel = 226,
				searchSortKey = 'name',
				searchSortOrderNormal = true,
				searchThrottleLevel = 10,
				searchThrottleEquipmentLevel = 8,
				spellSearchReturnLimit = 50,
				spellSearchSortKey = 'name',
				spellSearchSortOrderNormal = true,
				listSortKey = 'name',
				listSortOrderNormal = true,
				gemMinRarity = 4,
				gemMinItemLevel = 80,
				font = "Arial Narrow",
				fontSize = 10,
				iconSize = 15,
				searchFilters = {
					
				},
			},
		},
		wishlists = {
		},
		zones = {
			validZones = {
				"Naxxramas",
				"The Eye of Eternity",
				"The Obsidian Sanctum",
				"Ulduar",
				"Trial of the Crusader",
			},
			zoneSelected = 1,
		}
	},
};
kAuction.guids = {};
kAuction.guids.wasAuctioned = {};
kAuction.guids.lastObjectOpened = nil;
kAuction.threading = {};
kAuction.threading.timers = {};
kAuction.threading.timerPool = {};
-- Create Options Table
kAuction.options = {
    name = "kAuction",
    handler = kAuction,
    type = 'group',
    args = {
		description = {
			name = '',
			type = 'description',
			order = 0,
			hidden = true,
		},	
		show = {
			name = 'Show',
			type = 'execute',
			desc = 'Show the main kAuction frame.',
			guiHidden = true,
			func = function()
				if kAuction.auctions and #kAuction.auctions > 0 then
					kAuctionMainFrame:Show()
				else
					kAuction:Print("No auction data found on local client system -- hiding kAuction frame until valid auction data received.");
				end
			end,
		},
		bidding = {
			name = 'Bidding',
			type = 'group',
			cmdHidden = true,
			args = {
				autoPopulateCurrentItem = {
					name = 'Auto Populate Current Item',
					desc = 'Determines if bidding frame will auto-populate Current Item selection with slot item currently equipped on your character.',
					type = 'toggle',
					set = function(info,value) kAuction.db.profile.bidding.autoPopulateCurrentItem = value end,
					get = function(info) return kAuction.db.profile.bidding.autoPopulateCurrentItem end,
					width = 'full',
				},				
			},
		},
		events = {
			name = 'Events',
			type = 'group',
			cmdHidden = true,
			args = {
				framesInline = {
					name = 'Auction Received Events',
					type = 'group',
					guiInline = true,
					args = {
						auctionReceivedEffect = {
							name = 'Auction Received Effect',
							desc = 'Screen alert effect executed when a new auction is detected.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Flash',
								[3] = 'Shake',
							},
							style = 'dropdown',
							set = function(info,value)
								kAuction.db.profile.bidding.auctionReceivedEffect = value
								kAuction:Gui_TriggerEffectsAuctionReceived()
							end,
							get = function(info) return kAuction.db.profile.bidding.auctionReceivedEffect end,
							order = 1,
						},
						auctionReceivedSound = {
							type = 'select',
							dialogControl = 'LSM30_Sound', --Select your widget here
							name = 'Auction Alert Sound',
							desc = 'Sound played when a new auction is detected.',
							values = AceGUIWidgetLSMlists.sound, -- this table needs to be a list of keys found in the sharedmedia type you want
							get = function(info)
								return kAuction.db.profile.bidding.auctionReceivedSound -- variable that is my current selection
							end,
							set = function(info,value)
								kAuction.db.profile.bidding.auctionReceivedSound = value; -- saves our new selection the the current one
							end,
							order = 2,
						},
						auctionReceivedTextAlert = {
							name = 'Auction Received Text Alert',
							desc = 'Determines if and where a text alert is displayed when a new auction is detected.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Chat Window',
								--[3] = 'Raid Warning',
							},
							style = 'dropdown',
							set = function(info,value)
								kAuction.db.profile.bidding.auctionReceivedTextAlert = value
							end,
							get = function(info) return kAuction.db.profile.bidding.auctionReceivedTextAlert end,
							order = 3,
						},	
						displayFirstOpenAuction = {
							name = 'Scroll to First Open Auction',
							type = 'toggle',
							desc = 'Determines if kAuction will automatically scroll the Auction list to display the first Active auction whenever a new auction is detected.  If unchecked, scrolling will not be automated and new auctions may appear further down the list.  |cFF'..kAuction:RGBToHex(200,0,0)..'NOTE: This feature is in alpha and can cause graphical display issues, though functionality is not affected.|r',
							set = function(info,value) kAuction.db.profile.looting.displayFirstOpenAuction = value end,
							get = function(info) return kAuction.db.profile.looting.displayFirstOpenAuction end,
							width = 'full',
							order = 4,
						},
					},
				},
				framesInline2 = {
					name = 'Auction Winner Received Events',
					type = 'group',
					guiInline = true,
					args = {
						auctionWonEffect = {
							name = 'Auction Winner Received Effect',
							desc = 'Screen alert effect executed when an auction winner is declared.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Flash',
								[3] = 'Shake',
							},
							style = 'dropdown',
							set = function(info,value)
								kAuction.db.profile.bidding.auctionWinnerReceivedEffect = value
								kAuction:Gui_TriggerEffectsAuctionWinnerReceived()
							end,
							get = function(info) return kAuction.db.profile.bidding.auctionWinnerReceivedEffect end,
							order = 1,
						},
						auctionWonSound = {
							type = 'select',
							dialogControl = 'LSM30_Sound',
							name = 'Auction Winner Received Sound',
							desc = 'Sound played when an auction winner is declared.',
							values = AceGUIWidgetLSMlists.sound,
							get = function(info)
								return kAuction.db.profile.bidding.auctionWinnerReceivedSound;
							end,
							set = function(info,value)
								kAuction.db.profile.bidding.auctionWinnerReceivedSound = value;
							end,
							order = 2,
						},
						auctionWonTextAlert = {
							name = 'Auction Winner Received Text Alert',
							desc = 'Determines if and where a text alert is displayed when an auction winner is declared.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Chat Window',
							},
							style = 'dropdown',
							set = function(info,value)
								kAuction.db.profile.bidding.auctionWinnerReceivedTextAlert = value
							end,
							get = function(info) return kAuction.db.profile.bidding.auctionWinnerReceivedTextAlert end,
							order = 3,
						},
					},
				},
				framesInline3 = {
					name = 'Auction Won Events',
					type = 'group',
					guiInline = true,
					args = {
						auctionWonEffect = {
							name = 'Auction Won Effect',
							desc = 'Screen alert effect executed when you win an auction.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Flash',
								[3] = 'Shake',
							},
							style = 'dropdown',
							set = function(info,value)
								kAuction.db.profile.bidding.auctionWonEffect = value
								kAuction:Gui_TriggerEffectsAuctionWon()
							end,
							get = function(info) return kAuction.db.profile.bidding.auctionWonEffect end,
							order = 1,
						},
						auctionWonSound = {
							type = 'select',
							dialogControl = 'LSM30_Sound', --Select your widget here
							name = 'Auction Won Sound',
							desc = 'Sound played when you win an auction.',
							values = AceGUIWidgetLSMlists.sound, -- this table needs to be a list of keys found in the sharedmedia type you want
							get = function(info)
								return kAuction.db.profile.bidding.auctionWonSound -- variable that is my current selection
							end,
							set = function(info,value)
								kAuction.db.profile.bidding.auctionWonSound = value; -- saves our new selection the the current one
							end,
							order = 2,
						},
						auctionWonTextAlert = {
							name = 'Auction Won Text Alert',
							desc = 'Determines if and where a text alert is displayed when you win an auction.',
							type = 'select',
							values = {
								[1] = 'None',
								[2] = 'Chat Window',
								--[3] = 'Raid Warning',
							},
							style = 'dropdown',
							set = function(info,value)
								kAuction.db.profile.bidding.auctionWonTextAlert = value
							end,
							get = function(info) return kAuction.db.profile.bidding.auctionWonTextAlert end,
							order = 3,
						},
					},
				},								
			},	
		},	
		admin = {
			name = 'Admin',
			type = 'group',
			cmdHidden = true,
			args = {
				auctions = {
					name = 'Auctions',
					type = 'group',
					cmdHidden = true,
					order = 1,
					args = {
						description = {
							name = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec fermentum vestibulum odio. Donec elit felis, condimentum auctor, sagittis non, adipiscing sit amet, massa. Praesent tortor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla vulputate mi at purus ultrices viverra. Integer felis turpis, accumsan non, vestibulum vitae, euismod id, ligula. Aliquam erat volutpat. Fusce gravida fermentum justo. Sed eu lectus. Morbi pharetra quam vitae ligula. Suspendisse eget nibh. In hac habitasse platea dictumst. Aliquam erat volutpat. Fusce nisl dui, euismod cursus, sagittis in, mollis a, felis. Vivamus arcu odio, molestie id, venenatis ut, elementum vel, ante.',
							type = 'description',
							order = 0,
							hidden = true,
						},
						auctionType = {
							name = 'Auction Type',
							desc = 'Type of auction to perform.  Random will auto-generate random rolls for all bidders, whereas Loot Council will let Raid Leader assign drops.',
							type = 'select',
							values = {
								[1] = 'Random',
								[2] = 'Loot Council',
							},
							style = 'dropdown',
							set = function(info,value) kAuction.db.profile.looting.auctionType = value end,
							get = function(info) return kAuction.db.profile.looting.auctionType end,
							order = 1,
						},			
						auctionDuration = {
							name = 'Auction Duration',
							desc = 'Default auction timeout length.',
							type = 'range',
							min = 5,
							max = 120,
							step = 1,
							set = function(info,value)
								kAuction.db.profile.looting.auctionDuration = value
							end,
							get = function(info) return kAuction.db.profile.looting.auctionDuration end,
							order = 2,
						},				
						rarityThreshold = {
							name = 'Rarity Threshold',
							desc = 'Description for Rarity Threshold',
							type = 'select',
							values = {
								[0] = 'Poor',
								[1] = 'Common',
								[2] = 'Uncommon',
								[3] = 'Rare',
								[4] = 'Epic',
								[5] = 'Legendary',
							},
							style = 'dropdown',
							set = function(info,value) kAuction.db.profile.looting.rarityThreshold = value end,
							get = function(info) return kAuction.db.profile.looting.rarityThreshold end,
							order = 3,
						},
						rollMaximum = {
							name = 'Maximum Roll Limit',
							desc = 'Random auction type rolls utilize a random number generated between 1 and the Maximum Roll Limit.',
							type = 'range',
							min = 1,
							max = 200,
							step = 1,
							set = function(info,value) kAuction.db.profile.looting.rollMaximum = value end,
							get = function(info) return kAuction.db.profile.looting.rollMaximum end,
							order = 4,
						},				
						auctionCloseDelay = {
							name = 'Auction Close Delay',
							desc = 'Seconds to delay auction close announcements.',
							type = 'range',
							min = 0,
							max = 10,
							step = 1,
							set = function(info,value) kAuction.db.profile.looting.auctionCloseDelay = value end,
							get = function(info) return kAuction.db.profile.looting.auctionCloseDelay end,
							order = 5,
						},
						auctionCloseVoteDuration = {
							name = 'Auction Close Vote Delay',
							desc = 'Seconds after auction closure to allow Loot Council voting.',
							type = 'range',
							min = 0,
							max = 120,
							step = 1,
							set = function(info,value) kAuction.db.profile.looting.auctionCloseVoteDuration = value end,
							get = function(info) return kAuction.db.profile.looting.auctionCloseVoteDuration end,
							order = 6,
						},													
						isAutoAuction = {
							name = 'Auto Auction',
							desc = 'Auto Auction Desc',
							type = 'toggle',
							set = function(info,value) kAuction.db.profile.looting.isAutoAuction = value end,
							get = function(info) return kAuction.db.profile.looting.isAutoAuction end,
							width = 'full',
						},	
						autoAssignIfMasterLoot = {
							name = 'Auto Assign Items via Master Loot',
							type = 'toggle',
							desc = 'Auto Assign Items via Master Loot',
							set = function(info,value) kAuction.db.profile.looting.autoAssignIfMasterLoot = value end,
							get = function(info) return kAuction.db.profile.looting.autoAssignIfMasterLoot end,
							width = 'full',
						},														
						autoAwardRandomAuctions = {
							name = 'Auto Award Random Auctions',
							type = 'toggle',
							desc = 'Auto Award Random Auctions',
							set = function(info,value) kAuction.db.profile.looting.autoAwardRandomAuctions = value end,
							get = function(info) return kAuction.db.profile.looting.autoAwardRandomAuctions end,
							width = 'full',
						},				
						whisperBidInline = {
							name = 'Whisper Bid System',
							type = 'group',
							guiInline = true,
							args = {
								auctionWhisperBidEnabled = {
									name = 'Whisper Bid Enabled',
									desc = 'Enable/disable the Whisper Bid system.',
									type = 'toggle',
									set = function(info,value) kAuction.db.profile.looting.auctionWhisperBidEnabled = value end,
									get = function(info) return kAuction.db.profile.looting.auctionWhisperBidEnabled end,
									width = 'full',
									order = 1,
								},	
								auctionWhisperBidSuppressionEnabled = {
									name = 'Whisper Suppression Enabled',
									desc = 'Enable/disable suppression of auction-based whisper messages, which will hide incoming and outgoing messages during and for a brief time after relevant auctions are created.',
									type = 'toggle',
									set = function(info,value) kAuction.db.profile.looting.auctionWhisperBidSuppressionEnabled = value end,
									get = function(info) return kAuction.db.profile.looting.auctionWhisperBidSuppressionEnabled end,
									width = 'full',
									order = 2,
								},							
								auctionWhisperBidSuppressionDelay = {
									name = 'Auction Whisper Bid Suppression Delay',
									desc = 'Seconds after auction closure to continue suppression of whispers containing auctioned itemlinks.',
									type = 'range',
									min = 0,
									max = 300,
									step = 5,
									set = function(info,value) kAuction.db.profile.looting.auctionWhisperBidSuppressionDelay = value end,
									get = function(info) return kAuction.db.profile.looting.auctionWhisperBidSuppressionDelay end,
									order = 3,							
								},											
							},
						},						
						bidsInline = {
							name = 'Bid Details Public Visibility',
							type = 'group',
							guiInline = true,
							args = {
								visiblePublicDetails = {
									name = 'Bids Details Visibility',
									type = 'toggle',
									desc = 'Determines if auctions can be selected to display Bids window detail information.',
									set = function(info,value) kAuction.db.profile.looting.visiblePublicDetails = value end,
									get = function(info) return kAuction.db.profile.looting.visiblePublicDetails end,
									width = 'full',
								},							
								visiblePublicBidCurrentItems = {
									name = 'Current Item Visibility',
									type = 'toggle',
									desc = 'Determines if Bids window displays the Current Item submitted for bidders.',
									set = function(info,value) kAuction.db.profile.looting.visiblePublicBidCurrentItems = value end,
									get = function(info) return kAuction.db.profile.looting.visiblePublicBidCurrentItems end,
									width = 'full',
								},	
								visiblePublicBidRolls = {
									name = 'Roll Visibility',
									type = 'toggle',
									desc = 'Determines if Bids window displays the Roll produced by kAuction for Random Auctions.',
									set = function(info,value) kAuction.db.profile.looting.visiblePublicBidRolls = value end,
									get = function(info) return kAuction.db.profile.looting.visiblePublicBidRolls end,
									width = 'full',
								},	
								visiblePublicBidVoters = {
									name = 'Voter Visibility',
									type = 'toggle',
									desc = 'Determines if Bids window displays the Loot Council Voter details for bidders.',
									set = function(info,value) kAuction.db.profile.looting.visiblePublicBidVoters = value end,
									get = function(info) return kAuction.db.profile.looting.visiblePublicBidVoters end,
									width = 'full',
								},		
							},
						},
						--[[			
						lootManager = {
							type = 'input',
							name = 'Loot Manager',
							desc = 'Player assigned to manage loot rights.  If empty, Loot Management assigned to Raid Leader.',
							set = function(info,value) kAuction.db.profile.looting.lootManager = value end,
							get = function(info) return kAuction.db.profile.looting.lootManager end,
						},	
						]]				
					},
				},			
				disenchantment = {
					name = 'Disenchantment',
					type = 'group',
					cmdHidden = true,
					order = 2,
					args = {
						description = {
							name = 'Use these settings to edit a list of valid Disenchanters who may be present at your raids.  To add a new player as a disenchanter, enter the name in the Add box and press Enter.  The current list of Enchanters is found in the Enchanters dropdown.  To remove an Enchanter, select the name in the drop down and press Delete.',
							type = 'description',
							order = 0,
						},
						add = {
							name = 'Add',
							type = 'input',
							desc = 'Add disenchanter Name to list.',
							get = function(info) return nil end,
							set = function(info,value)
								tinsert(kAuction.db.profile.looting.disenchanters, value);
								table.sort(kAuction.db.profile.looting.disenchanters);
							end,
							order = 1,
							width = 'full',
						},
						disenchanters = {
							name = 'Disenchanters',
							type = 'select',
							style = 'dropdown',
							desc = 'Current list of Disenchanters.',
							values = function() return kAuction.db.profile.looting.disenchanters end,
							get = function(info) return kAuction.db.profile.looting.disenchanterSelected end,
							set = function(info,value) kAuction.db.profile.looting.disenchanterSelected = value end,
							order = 2,
						},
						delete = {
							name = 'Delete',
							type = 'execute',
							desc = 'Delete selected disenchanter Name from list.',
							func = function()
								tremove(kAuction.db.profile.looting.disenchanters, kAuction.db.profile.looting.disenchanterSelected);
								table.sort(kAuction.db.profile.looting.disenchanters);
								kAuction.db.profile.looting.disenchanterSelected = 1;
							end,
							order = 3,
						},
					},
				},
				councilMembersInline = {
					name = 'Loot Council',
					type = 'group',
					cmdHidden = true,
					order = 5,
					args = {
						description = {
							name = 'Use these settings to edit a list of valid Loot Council members who may vote on Loot Council-type Auctions.  To add a new player as a Loot Council member, enter the name in the Add box and press Enter.  The current list of Loot Council members is found in the Members dropdown.  To remove an Member, select the name in the drop down and press Delete.',
							type = 'description',
							order = 0,
						},
						add = {
							name = 'Add',
							type = 'input',
							desc = 'Add council Member to list.',
							get = function(info) return nil end,
							set = function(info,value)
								tinsert(kAuction.db.profile.looting.councilMembers, value);
								table.sort(kAuction.db.profile.looting.councilMembers);
							end,
							order = 1,
							width = 'full',
						},
						councilMembers = {
							name = 'Members',
							type = 'select',
							desc = 'Current list of Loot Council members.',
							style = 'dropdown',
							values = function() return kAuction.db.profile.looting.councilMembers end,
							get = function(info) return kAuction.db.profile.looting.councilMemberSelected end,
							set = function(info,value) kAuction.db.profile.looting.councilMemberSelected = value end,
							order = 2,
						},
						delete = {
							name = 'Delete',
							type = 'execute',
							desc = 'Delete selected council Member from list.',
							func = function()
								tremove(kAuction.db.profile.looting.councilMembers, kAuction.db.profile.looting.councilMemberSelected);
								kAuction:Server_InitializeCouncilMemberList();
								kAuction.db.profile.looting.councilMemberSelected = 1;
							end,
							order = 3,
						},					
					},
				},
				items = {
					name = 'Item Blacklist',
					type = 'group',
					cmdHidden = true,
					order = 3,
					args = {
						description = {
							name = 'Use these settings to edit a list of Blacklisted Items.  Items in the Blacklist will not be auctioned by kAuction.  Useful for high-quality currency items (Emblem of Heroism, Emblem of Valor, etc.).  To add a new item to the Blacklist, enter the exact item name in the Add box and press Enter.  The current list of Blacklisted Items is found in the Items dropdown.  To remove an Item, select the name in the drop down and press Delete.',
							type = 'description',
							order = 0,
						},
						add = {
							name = 'Add',
							type = 'input',
							desc = 'Add item to blacklist.',
							get = function(info) return nil end,
							set = function(info,value) 
								tinsert(kAuction.db.profile.items.blackList, value);
								table.sort(kAuction.db.profile.items.blackList);
							end,
							order = 1,
							width = 'full',
						},
						blackList = {
							name = 'Items',
							type = 'select',
							style = 'dropdown',
							desc = 'Current list of Blacklisted Items.',
							values = function() return kAuction.db.profile.items.blackList end,
							get = function(info) return kAuction.db.profile.items.blackListSelected end,
							set = function(info,value) kAuction.db.profile.items.blackListSelected = value end,
							order = 2,
						},
						delete = {
							name = 'Delete',
							type = 'execute',
							desc = 'Delete selected blacklist item.',
							func = function()
								tremove(kAuction.db.profile.items.blackList, kAuction.db.profile.items.blackListSelected);
								table.sort(kAuction.db.profile.items.blackList);
								kAuction.db.profile.items.blackListSelected = 1;
							end,
							order = 3,
						},
					},
				},	
				itemWhiteList = {
					name = 'Item Whitelist',
					type = 'group',
					cmdHidden = true,
					order = 4,
					args = {
						description = {
							name = 'Delete an existing Whitelist entry.',
							type = 'description',
							order = 0,
						},
						addInline = {
							name = 'Add New Item',
							type = 'group',
							cmdHidden = true,
							order = 1,
							args = {
								name = {
									name = 'Name',
									type = 'input',
									desc = 'Name of item to add.',
									get = function(info) return kAuction.db.profile.items.whiteListConfig.add.name; end,
									set = function(info,value) kAuction.db.profile.items.whiteListConfig.add.name= value; end,
									order = 1,
									width = 'full',
								},
								auctionType = {
									name = 'Auction Type',
									type = 'select',
									style = 'dropdown',
									desc = 'Type of Auction to be auto-matically assigned to this item, regardless of Admin setting.',
									values = function()
										local auctionTypes = {};
										auctionTypes[0] = "None";
										auctionTypes[1] = "Random";
										auctionTypes[2] = "Loot Council";
										return auctionTypes;
									end,
									get = function(info) return kAuction.db.profile.items.whiteListConfig.add.auctionTypeSelected end,
									set = function(info,value) kAuction.db.profile.items.whiteListConfig.add.auctionTypeSelected = value end,
									order = 2,
								},
								itemSlot = {
									name = 'Item Slot',
									type = 'select',
									style = 'dropdown',
									desc = 'Equipment slot to utilize when Clients are selecting a Currently Equipped item via popout.  Good for tokens or quest that have no innate slot type.',
									values = function()
										return kAuction:Item_GetItemSlotDropdownValues();
									end,
									get = function(info) return kAuction.db.profile.items.whiteListConfig.add.itemSlotSelected end,
									set = function(info,value) kAuction.db.profile.items.whiteListConfig.add.itemSlotSelected = value end,
									order = 3,
								},
								add = {
									name = 'Add',
									type = 'execute',
									desc = 'Add item to Whitelist.',
									func = function()
										if kAuction.db.profile.items.whiteListConfig.add.name then
											local booExists = false;
											local name,currentItemSlot,auctionType;
											for iItem,vItem in pairs(kAuction.db.profile.items.whiteList) do
												if vItem.name == kAuction.db.profile.items.whiteListConfig.add.name then
													booExists = true;
												end
											end
											if booExists == false then
												currentItemSlot = kAuction:Item_GetItemSlotByDropdownIndex(kAuction.db.profile.items.whiteListConfig.add.itemSlotSelected);
												if kAuction.db.profile.items.whiteListConfig.add.auctionTypeSelected == 0 then
													auctionType = nil;
												else
													auctionType = kAuction.db.profile.items.whiteListConfig.add.auctionTypeSelected;
												end
												tinsert(kAuction.db.profile.items.whiteList, {name = kAuction.db.profile.items.whiteListConfig.add.name, 
																						  auctionType = auctionType, 
																						  currentItemSlot = currentItemSlot});
												kAuction.db.profile.items.whiteListConfig.add.auctionTypeSelected = 0;
												kAuction.db.profile.items.whiteListConfig.add.itemSlotSelected = 0;
												kAuction.db.profile.items.whiteListConfig.add.name = nil;
											end
										end
									end,
									order = 4,
								},
							},
						},
						list = {
							name = 'Items',
							type = 'select',
							style = 'dropdown',
							desc = 'Current list of Whitelist Items.',
							values = function() return kAuction:Item_GetWhitelistDropdownValues(); end,
							get = function(info) return kAuction.db.profile.items.whiteListSelected end,
							set = function(info,value) kAuction.db.profile.items.whiteListSelected = value end,
							order = 2,
							width = 'full',
						},
						delete = {
							name = 'Delete',
							type = 'execute',
							desc = 'Delete selected Whitelist item.',
							func = function()
								tremove(kAuction.db.profile.items.whiteList, kAuction.db.profile.items.whiteListSelected);
								kAuction.db.profile.items.whiteListSelected = 1;
							end,
							order = 3,
						},
					},
				},	
				zonesInline = {
					name = 'Zones',
					type = 'group',
					cmdHidden = true,
					order = 6,
					args = {
						description = {
							name = 'Use these settings to edit a list of valid Raid Zones where kAuction will track active raids.  To add a new zone, enter the name in the Add box and press Enter.  The current list of Raid Zones is found in the Zones dropdown.  To remove an Zone, select the name in the drop down and press Delete.',
							type = 'description',
							order = 0,
						},
						add = {
							name = 'Add',
							type = 'input',
							desc = 'Add Zone to list.',
							get = function(info) return nil end,
							set = function(info,value)
								tinsert(kAuction.db.profile.zones.validZones, value);
								table.sort(kAuction.db.profile.zones.validZones);
							end,
							order = 1,
							width = 'full',
						},
						councilMembers = {
							name = 'Members',
							type = 'select',
							desc = 'Current list of valid Raid Zones.',
							style = 'dropdown',
							values = function() return kAuction.db.profile.zones.validZones end,
							get = function(info) return kAuction.db.profile.zones.zoneSelected end,
							set = function(info,value) kAuction.db.profile.zones.zoneSelected = value end,
							order = 2,
						},
						delete = {
							name = 'Delete',
							type = 'execute',
							desc = 'Delete selected Zone from list.',
							func = function()
								tremove(kAuction.db.profile.zones.validZones, kAuction.db.profile.zones.zoneSelected);
								kAuction.db.profile.zones.zoneSelected = 1;
							end,
							order = 3,
						},					
					},
				},
				versionChecker = {
					name = 'Version Check',
					type = 'execute',
					desc = 'Check kAuction version of raid members.',
					func = function() kAuction:Server_VersionCheck(true) end,
				},
				startRaid = {
					name = 'Start Raid Tracker',
					type = 'execute',
					desc = 'Start kAuction raid tracking.',
					func = function() kAuction:Server_ConfirmStartRaidTracking() end,
				},
				stopRaid = {
					name = 'Stop Raid Tracker',
					type = 'execute',
					desc = 'Stop kAuction raid tracking.',
					func = function() kAuction:Server_ConfirmStopRaidTracking() end,
				},
				testAuction = {
					name = 'Test Auction',
					type = 'execute',
					desc = 'Create a test auction of a random item.',
					func = function() kAuction:Server_CreateTestAuction() end,
				},
			},
		},			
		gui = {
			name = 'Interface',
			type = 'group',
			cmdHidden = true,
			args = {
				bids = {
					name = 'Bids Frame',
					type = 'group',
					args = {
						fonts = {
							name = 'Font',
							type = 'group',
							guiInline = true,
							order = 2,
							args = {
								font = {
									type = 'select',
									dialogControl = 'LSM30_Font', --Select your widget here
									name = 'Font',
									desc = 'Font of Bids Frame text.',
									values = AceGUIWidgetLSMlists.font, -- this table needs to be a list of keys found in the sharedmedia type you want
									get = function(info)
										return kAuction.db.profile.gui.frames.bids.font -- variable that is my current selection
									end,
									set = function(info,value)
										kAuction.db.profile.gui.frames.bids.font = value; -- saves our new selection the the current one
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
								},
								fontSize = {
									name = 'Font Size',
									desc = 'Font Size of Bids Frame text.',
									type = 'range',
									min = 8,
									max = 20,
									step = 1,
									set = function(info,value)
										kAuction.db.profile.gui.frames.bids.fontSize = value;
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
									get = function(info) return kAuction.db.profile.gui.frames.bids.fontSize end,
								},
							},
						},
						details = {
							name = 'Details',
							type = 'group',
							guiInline = true,
							order = 3,
							args = {
								itemPopoutDuration = {
									name = 'Items Won Popout Check Frequency',
									desc = 'Seconds the Items Won by popout window will be displayed after mouse leaves applicable frames.',
									type = 'range',
									min = 0.5,
									max = 5,
									step = 0.1,
									set = function(info,value)
										kAuction.db.profile.gui.frames.bids.itemPopoutDuration = value
										--i = 1;
										--while kAuction.timers.IsMouseInCurrentItemsWonRowFrame[i] do
											--if kAuction:CancelTimer(kAuction.timers.IsMouseInCurrentItemsWonRowFrame[i]) then
												--kAuction.timers.IsMouseInCurrentItemsWonRowFrame[i] = nil;
											--end
											--i=i+1;
										--end
									end,
									get = function(info) return kAuction.db.profile.gui.frames.bids.itemPopoutDuration end,
									width = 'full',
								},
							},
						},
					},
				},			
				main = {
					name = 'Main Frame',
					type = 'group',
					args = {
						bars = {
							name = 'Bar Settings',
							type = 'group',
							guiInline = true,
							order = 3,
							args = {
								barTexture = {
									 type = 'select',
									 dialogControl = 'LSM30_Statusbar', --Select your widget here
									 name = 'Texture',
									 desc = 'Texture of timerbar for item auctions.',
									 values = AceGUIWidgetLSMlists.statusbar, -- this table needs to be a list of keys found in the sharedmedia type you want
									 get = function(info)
										  return kAuction.db.profile.gui.frames.main.barTexture -- variable that is my current selection
									 end,
									 set = function(info,value)
										  kAuction.db.profile.gui.frames.main.barTexture = value -- saves our new selection the the current one
										  kAuction:Gui_HookFrameRefreshUpdate();
									 end,
								},
								barBackgroundColor = {
									type = 'color',
									name = 'Background Color',
									desc = 'Color of timerbar background for item auctions.',
									hasAlpha = true,
									get = function()
										return kAuction.db.profile.gui.frames.main.barBackgroundColor.r, kAuction.db.profile.gui.frames.main.barBackgroundColor.g, kAuction.db.profile.gui.frames.main.barBackgroundColor.b, kAuction.db.profile.gui.frames.main.barBackgroundColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kAuction.db.profile.gui.frames.main.barBackgroundColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
								},
								barColor = {
									type = 'color',
									name = 'Color',
									desc = 'Color of timerbar for item auctions.',
									hasAlpha = true,
									get = function()
										return kAuction.db.profile.gui.frames.main.barColor.r, kAuction.db.profile.gui.frames.main.barColor.g, kAuction.db.profile.gui.frames.main.barColor.b, kAuction.db.profile.gui.frames.main.barColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kAuction:Debug("r: " .. r .. ", g: " .. g .. ", b: " .. b .. ", a: " .. a, 3)
										kAuction.db.profile.gui.frames.main.barColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
								},
							},
						},
						barsSelected = {
							name = 'Selection Bar Settings',
							type = 'group',
							guiInline = true,
							order = 5,
							args = {
								selectedBarTexture = {
									 type = 'select',
									 dialogControl = 'LSM30_Statusbar', --Select your widget here
									 name = 'Texture',
									 desc = 'Texture of selection bar for item auctions.',
									 values = AceGUIWidgetLSMlists.statusbar, -- this table needs to be a list of keys found in the sharedmedia type you want
									 get = function(info)
										  return kAuction.db.profile.gui.frames.main.selectedBarTexture -- variable that is my current selection
									 end,
									 set = function(info,value)
										  kAuction.db.profile.gui.frames.main.selectedBarTexture = value -- saves our new selection the the current one
										  kAuction:Gui_HookFrameRefreshUpdate();
									 end,
								},
								selectedBarBackgroundColor = {
									type = 'color',
									name = 'Background Color',
									desc = 'Color of selection bar background for item auctions.',
									hasAlpha = true,
									get = function()
										return kAuction.db.profile.gui.frames.main.selectedBarBackgroundColor.r, kAuction.db.profile.gui.frames.main.selectedBarBackgroundColor.g, kAuction.db.profile.gui.frames.main.selectedBarBackgroundColor.b, kAuction.db.profile.gui.frames.main.selectedBarBackgroundColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kAuction.db.profile.gui.frames.main.selectedBarBackgroundColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
								},
								selectedBarColor = {
									type = 'color',
									name = 'Color',
									desc = 'Color of selection bar for item auctions.',
									hasAlpha = true,
									get = function()
										return kAuction.db.profile.gui.frames.main.selectedBarColor.r, kAuction.db.profile.gui.frames.main.selectedBarColor.g, kAuction.db.profile.gui.frames.main.selectedBarColor.b, kAuction.db.profile.gui.frames.main.selectedBarColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kAuction:Debug("r: " .. r .. ", g: " .. g .. ", b: " .. b .. ", a: " .. a, 3)
										kAuction.db.profile.gui.frames.main.selectedBarColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
								},
							},
						},
						autoRemoveAuctions = {
							name = 'Auto-Remove Auctions',
							type = 'toggle',
							desc = 'Determine if Auctions should be auto-removed from the kAuction window after they expire.',
							set = function(info,value) kAuction.db.profile.gui.frames.main.autoRemoveAuctions = value end,
							get = function(info) return kAuction.db.profile.gui.frames.main.autoRemoveAuctions end,
							width = 'full',
							order = 1,
						},
						autoRemoveAuctionsDelay = {
							name = 'Auto-Remove Auction Delay',
							desc = 'If Auto-Remove Auctions is enabled, this determines the delay, in seconds, after an auction ends to remove it.',
							type = 'range',
							min = 0,
							max = 120,
							step = 1,
							set = function(info,value)
								kAuction.db.profile.gui.frames.main.autoRemoveAuctionsDelay = value;
							end,
							get = function(info) return kAuction.db.profile.gui.frames.main.autoRemoveAuctionsDelay end,
							width = 'full',
							order = 2,
						},
						dimensions = {
							name = 'Dimensions',
							type = 'group',
							guiInline = true,
							order = 4,
							args = {
								height = {
									name = 'Height',
									desc = 'Height of Main Frame.',
									type = 'range',
									min = 152,
									max = 152,
									step = 1,
									set = function(info,value)
										kAuction.db.profile.gui.frames.main.height = value
										kAuction:Gui_RefreshFrame(_G[kAuction.db.profile.gui.frames.main.name])
									end,
									get = function(info) return kAuction.db.profile.gui.frames.main.height end,
								},
								width = {
									name = 'Width',
									desc = 'Width of Main Frame.',
									type = 'range',
									min = 240,
									max = 400,
									step = 1,
									set = function(info,value)
										kAuction.db.profile.gui.frames.main.width = value
										kAuction:Gui_RefreshFrame(_G[kAuction.db.profile.gui.frames.main.name])
									end,
									get = function(info) return kAuction.db.profile.gui.frames.main.width end,
								},
							},
						},						
						fonts = {
							name = 'Font',
							type = 'group',
							guiInline = true,
							order = 6,
							args = {
								font = {
									type = 'select',
									dialogControl = 'LSM30_Font', --Select your widget here
									name = 'Font',
									desc = 'Font for auction item names.',
									values = AceGUIWidgetLSMlists.font, -- this table needs to be a list of keys found in the sharedmedia type you want
									get = function(info)
										return kAuction.db.profile.gui.frames.main.font -- variable that is my current selection
									end,
									set = function(info,value)
										kAuction.db.profile.gui.frames.main.font = value -- saves our new selection the the current one
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
								},
								fontSize = {
									name = 'Font Size',
									desc = 'Font Size of Main Frame text.',
									type = 'range',
									min = 8,
									max = 20,
									step = 1,
									set = function(info,value)
										kAuction.db.profile.gui.frames.main.fontSize = value
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
									get = function(info) return kAuction.db.profile.gui.frames.main.fontSize end,
								},
							},
						},
						scale = {
							name = 'Overall Scale',
							desc = 'Change the scale of the kAuction window.',
							type = 'range',
							min = 0.5,
							max = 3,
							step = 0.01,
							set = function(info,value)
								kAuction.db.profile.gui.frames.main.scale = value;
								kAuction:Gui_HookFrameRefreshUpdate();
							end,
							get = function(info) return kAuction.db.profile.gui.frames.main.scale end,
							width = 'full',
						},
						tabs = {
							name = 'Tab Settings',
							type = 'group',
							guiInline = true,
							order = 7,
							args = {
								highlightColor = {
									type = 'color',
									name = 'Highlight Color',
									desc = 'Color of Tab background when mouse hovers.',
									hasAlpha = true,
									get = function()
										return kAuction.db.profile.gui.frames.main.tabs.highlightColor.r, kAuction.db.profile.gui.frames.main.tabs.highlightColor.g, kAuction.db.profile.gui.frames.main.tabs.highlightColor.b, kAuction.db.profile.gui.frames.main.tabs.highlightColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kAuction.db.profile.gui.frames.main.tabs.highlightColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
								},							
								inactiveColor = {
									type = 'color',
									name = 'Inactive Color',
									desc = 'Color of Tab background when not selected or highlighted.',
									hasAlpha = true,
									get = function()
										return kAuction.db.profile.gui.frames.main.tabs.inactiveColor.r, kAuction.db.profile.gui.frames.main.tabs.inactiveColor.g, kAuction.db.profile.gui.frames.main.tabs.inactiveColor.b, kAuction.db.profile.gui.frames.main.tabs.inactiveColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kAuction.db.profile.gui.frames.main.tabs.inactiveColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
								},
								selectedColor = {
									type = 'color',
									name = 'Selected Color',
									desc = 'Color of Tab background when tab is selected.',
									hasAlpha = true,
									get = function()
										return kAuction.db.profile.gui.frames.main.tabs.selectedColor.r, kAuction.db.profile.gui.frames.main.tabs.selectedColor.g, kAuction.db.profile.gui.frames.main.tabs.selectedColor.b, kAuction.db.profile.gui.frames.main.tabs.selectedColor.a; -- variable that is my current selection
									end,
									set = function(info,r,g,b,a)
										kAuction.db.profile.gui.frames.main.tabs.selectedColor = {r = r, g = g, b = b, a = a} -- saves our new selection the the current one
										kAuction:Gui_HookFrameRefreshUpdate();
									end,
								},
							},
						},
						details = {
							name = 'Details',
							type = 'group',
							guiInline = true,
							order = 8,
							args = {
								itemPopoutDuration = {
									name = 'Current Item Selection Popout Check Frequency',
									desc = 'Seconds the Current Item Selection popout window will be displayed after mouse leaves applicable frames.',
									type = 'range',
									min = 0.5,
									max = 5,
									step = 0.1,
									set = function(info,value)
										kAuction.db.profile.gui.frames.main.itemPopoutDuration = value
										--i = 1;
										--while kAuction.timers.IsMouseInCurrentItemRowFrame[i] do
											--if kAuction:CancelTimer(kAuction.timers.IsMouseInCurrentItemRowFrame[i]) then
												--kAuction.timers.IsMouseInCurrentItemRowFrame[i] = nil;
											--end
											--i=i+1;
										--end
									end,
									get = function(info) return kAuction.db.profile.gui.frames.main.itemPopoutDuration end,
									width = 'full',
								},
							},
						},						
					},
				},						
			},
		},
		modules = {
			name = 'Modules',
			type = 'group',
			cmdHidden = true,
			args = {
				auctions = {
					name = 'The Traitor King',
					type = 'group',
					cmdHidden = true,
					order = 1,
					args = {	
						description = {
							name = 'Here you can change the options for the Traitor King Achievement Module for use in the Trial of the Crusade raid instance.',
							type = 'description',
							order = 0,
							hidden = true,
						},
						enabled = {
							name = 'Enabled',
							desc = 'Enable/Disable the Traitor King achievement assistance module.',
							type = 'toggle',
							set = function(info,value) kAuction.db.profile.modules.theTraitorKing.enabled = value end,
							get = function(info) return kAuction.db.profile.modules.theTraitorKing.enabled end,
							width = 'full',
						},
					},
				},
				aura = {
					name = 'Aura',
					type = 'group',
					cmdHidden = true,
					order = 1,
					args = {	
						description = {
							name = 'The kAuction Aura Module is primarily designed to automatically remove specific auras (buffs) from the player based on certain criteria.  These criteria can be zone, current talent spec, and also a mix and match of other auras currently active or not active on the player.',
							type = 'description',
							order = 0,
						},
						enabled = {
							name = 'Enabled',
							desc = 'Enable/Disable the Aura Module.',
							type = 'toggle',
							set = function(info,value)
								kAuction.db.profile.modules.aura.enabled = value;
								if kAuction.db.profile.modules.aura.enabled then
									kAuction:RegisterEvent("UNIT_AURA");
								else
									kAuction:UnregisterEvent("UNIT_AURA");
								end
							end,
							get = function(info) return kAuction.db.profile.modules.aura.enabled end,
							width = 'full',
						},
					},
				},
			},
		},		
		debug = {
			name = 'Debug',
			type = 'group',
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle Debug mode',
					set = function(info,value) kAuction.db.profile.debug.enabled = value end,
					get = function(info) return kAuction.db.profile.debug.enabled end,
				},
				threshold = {
					name = 'Threshold',
					desc = 'Description for Debug Threshold',
					type = 'select',
					values = {
						[1] = 'Low',
						[2] = 'Normal',
						[3] = 'High',
					},
					style = 'dropdown',
					set = function(info,value) kAuction.db.profile.debug.threshold = value end,
					get = function(info) return kAuction.db.profile.debug.threshold end,
				},
			},
		},
        ui = {
			type = 'execute',
			name = 'UI',
			desc = 'Open the User Interface',
			func = function() 
				kAuction.dialog:Open("kAuction") 
			end,
			guiHidden = true,
        },
        version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kAuction version',
			func = function() 
				kAuction:Print("Version: |cFF"..kAuction:RGBToHex(0,255,0)..kAuction.version.."|r");
			end,
			guiHidden = true,
        },
        wishlist = {
			type = 'execute',
			name = 'Wishlist',
			desc = 'Open the Wishlist Interface',
			func = function() 
				kAuction:WishlistGui_InitializeFrames();
			end,
			guiHidden = true,
        },
        aura = {
			type = 'execute',
			name = 'Aura Module',
			desc = 'Open the Aura Module Interface',
			func = function() 
				kAuction:Aura_InitializeFrames();
			end,
			guiHidden = true,
        },
        wishlistConfig = {
			name = 'Wishlist',
			type = 'group',
			cmdHidden = true,
			args = {
				framesInline = {
					name = 'Wishlist Search Settings',
					type = 'group',
					guiInline = true,
					order = 1,
					args = {
						searchReturnLimit = {
							name = 'Results Limit',
							desc = 'Maximum number of search results that will be returned for any given query.  NOTE: Setting this number too high will result in extreme client lag while searching and may even freeze your client.',
							type = 'range',
							min = 10,
							max = 500,
							step = 10,
							set = function(info,value)
								kAuction.db.profile.wishlist.config.searchReturnLimit = value
							end,
							get = function(info) return kAuction.db.profile.wishlist.config.searchReturnLimit end,
							width = 'full',
						},
						searchMinRarity = {
							name = 'Minimum Rarity',
							desc = 'Determine what rarity items must be equal to or above to be returned in search resuls.',
							type = 'select',
							values = {
								[0] = 'Poor',
								[1] = 'Common',
								[2] = 'Uncommon',
								[3] = 'Rare',
								[4] = 'Epic',
								[5] = 'Legendary',
								[6] = 'Heirloom',
							},
							style = 'dropdown',
							set = function(info,value)
								kAuction.db.profile.wishlist.config.searchMinRarity = value;
							end,
							get = function(info) return kAuction.db.profile.wishlist.config.searchMinRarity end,
							width = 'full',
						},
						searchMinItemLevel = {
							name = 'Minimum Item Level',
							desc = 'Determines the minumum item level items must be to be returned in search results.',
							type = 'range',
							min = 0,
							max = 400,
							step = 1,
							set = function(info,value)
								kAuction.db.profile.wishlist.config.searchMinItemLevel = value;
							end,
							get = function(info) return kAuction.db.profile.wishlist.config.searchMinItemLevel end,
							width = 'full',
						},
						searchThrottleLevel = {
							name = 'Search Memory Usage',
							desc = 'Determines the level of memory usage kAuction will use when building the item database.  The higher this setting, the more memory used and the slower your system will be during item database updates, but the faster the update time.  If performance is an issue, a lower setting is better, but item database updates will take much longer to complete.',
							type = 'select',	
							values = {
								[1] = 'Minimum',
								[5] = 'Very Low',
								[10] = 'Low',
								[20] = 'Normal',
								[30] = 'High',
								[50] = 'Very High',
								[100] = 'Maximum',
							},
							style = 'dropdown',
							set = function(info,value)
								kAuction.db.profile.wishlist.config.searchThrottleLevel = value
							end,
							get = function(info) return kAuction.db.profile.wishlist.config.searchThrottleLevel end,
							width = 'full',
						},
						searchThrottleEquipmentLevel = {
							name = 'Search Expansion',
							desc = 'Select the expansion(s) in which you wish to search for equipment results.  This allows you to lower the total quantity of items that must be scanned when updating the item database and limit by items released within certain expansions.',
							type = 'select',	
							values = {
								[1] = 'All Expansions',
								[2] = 'Classic',
								[3] = 'The Burning Crusade',
								[4] = 'Wrath of the Lich King',
								[5] = 'Cataclysm',
								[6] = 'Classic & The Burning Crusade',
								[7] = 'The Burning Crusade & Wrath of the Lich King',
								[8] = 'Wrath of the Lich King & Cataclysm',
							},
							style = 'dropdown',
							set = function(info,value)
								kAuction.db.profile.wishlist.config.searchThrottleEquipmentLevel = value
							end,
							get = function(info) return kAuction.db.profile.wishlist.config.searchThrottleEquipmentLevel end,
							width = 'full',
						},
					},
				},
				framesInlineGui = {
					name = 'GUI Settings',
					type = 'group',
					guiInline = true,
					order = 3,
					args = {
						fonts = {
							name = 'Font',
							type = 'group',
							guiInline = true,
							order = 2,
							args = {
								font = {
									type = 'select',
									dialogControl = 'LSM30_Font', --Select your widget here
									name = 'Font',
									desc = 'Font of Wishlist listings.',
									values = AceGUIWidgetLSMlists.font, -- this table needs to be a list of keys found in the sharedmedia type you want
									get = function(info)
										return kAuction.db.profile.wishlist.config.font -- variable that is my current selection									
									end,
									set = function(info,value)
										kAuction.db.profile.wishlist.config.font = value; -- saves our new selection the the current one
										if kAuction.gui.frames.list.main then
											kAuction:WishlistGui_RefreshMainFrame();
											if kAuction.db.profile.wishlist.config.selectedSection == 'list' then
												kAuction:WishlistGui_ShowList(nil, kAuction.gui.frames.list.selectedWishlist);									
											end
										end
									end,
								},
								fontSize = {
									name = 'Font Size',
									desc = 'Font Size of Wishlist listings.',
									type = 'range',
									min = 8,
									max = 20,
									step = 1,
									set = function(info,value)
										kAuction.db.profile.wishlist.config.fontSize = value;
										if kAuction.gui.frames.list.main then
											kAuction:WishlistGui_RefreshMainFrame();
											if kAuction.db.profile.wishlist.config.selectedSection == 'list' then
												kAuction:WishlistGui_ShowList(nil, kAuction.gui.frames.list.selectedWishlist);																		
											end
										end
									end,
									get = function(info) return kAuction.db.profile.wishlist.config.fontSize end,
								},
							},				
						},
						iconSize = {
							name = 'Icon Size',
							desc = 'Item Icon Size for Wishlist listings.',
							type = 'range',
							min = 8,
							max = 20,
							step = 1,
							set = function(info,value)
								kAuction.db.profile.wishlist.config.iconSize = value;
								if kAuction.gui.frames.list.main then
									kAuction:WishlistGui_RefreshMainFrame();
									if kAuction.db.profile.wishlist.config.selectedSection == 'list' then
										kAuction:WishlistGui_ShowList(nil, kAuction.gui.frames.list.selectedWishlist);																
									end
								end
							end,
							get = function(info) return kAuction.db.profile.wishlist.config.iconSize end,
						},								
					},
				},
			},
		},
	},
};