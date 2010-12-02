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
				--TIER 7, 10-man
				{name = "Chestguard of the Lost Conqueror", currentItemSlot = 5},
				{name = "Chestguard of the Lost Protector", currentItemSlot = 5},
				{name = "Chestguard of the Lost Vanquisher", currentItemSlot = 5},		
				{name = "Gloves of the Lost Conqueror", currentItemSlot = 10},
				{name = "Gloves of the Lost Protector", currentItemSlot = 10},
				{name = "Gloves of the Lost Vanquisher", currentItemSlot = 10},			
				{name = "Helm of the Lost Conqueror", currentItemSlot = 1},
				{name = "Helm of the Lost Protector", currentItemSlot = 1},
				{name = "Helm of the Lost Vanquisher", currentItemSlot = 1},
				{name = "Leggings of the Lost Conqueror", currentItemSlot = 7},
				{name = "Leggings of the Lost Protector", currentItemSlot = 7},
				{name = "Leggings of the Lost Vanquisher", currentItemSlot = 7},
				{name = "Spaulders of the Lost Conqueror", currentItemSlot = 3},
				{name = "Spaulders of the Lost Protector", currentItemSlot = 3},
				{name = "Spaulders of the Lost Vanquisher", currentItemSlot = 3},
				--TIER 7, 25-man
				{name = "Breastplate of the Lost Conqueror", currentItemSlot = 5},
				{name = "Breastplate of the Lost Protector", currentItemSlot = 5},
				{name = "Breastplate of the Lost Vanquisher", currentItemSlot = 5},	
				{name = "Gauntlets of the Lost Conqueror", currentItemSlot = 10},
				{name = "Gauntlets of the Lost Protector", currentItemSlot = 10},
				{name = "Gauntlets of the Lost Vanquisher", currentItemSlot = 10},	
				{name = "Crown of the Lost Conqueror", currentItemSlot = 1},
				{name = "Crown of the Lost Protector", currentItemSlot = 1},
				{name = "Crown of the Lost Vanquisher", currentItemSlot = 1},
				{name = "Legplates of the Lost Conqueror", currentItemSlot = 7},
				{name = "Legplates of the Lost Protector", currentItemSlot = 7},
				{name = "Legplates of the Lost Vanquisher", currentItemSlot = 7},
				{name = "Mantle of the Lost Conqueror", currentItemSlot = 3},
				{name = "Mantle of the Lost Protector", currentItemSlot = 3},
				{name = "Mantle of the Lost Vanquisher", currentItemSlot = 3},
				--TIER 8, 10-man
				{name = "Chestguard of the Wayward Conqueror", currentItemSlot = 5},
				{name = "Chestguard of the Wayward Protector", currentItemSlot = 5},
				{name = "Chestguard of the Wayward Vanquisher", currentItemSlot = 5},		
				{name = "Gloves of the Wayward Conqueror", currentItemSlot = 10},
				{name = "Gloves of the Wayward Protector", currentItemSlot = 10},
				{name = "Gloves of the Wayward Vanquisher", currentItemSlot = 10},			
				{name = "Helm of the Wayward Conqueror", currentItemSlot = 1},
				{name = "Helm of the Wayward Protector", currentItemSlot = 1},
				{name = "Helm of the Wayward Vanquisher", currentItemSlot = 1},
				{name = "Leggings of the Wayward Conqueror", currentItemSlot = 7},
				{name = "Leggings of the Wayward Protector", currentItemSlot = 7},
				{name = "Leggings of the Wayward Vanquisher", currentItemSlot = 7},
				{name = "Spaulders of the Wayward Conqueror", currentItemSlot = 3},
				{name = "Spaulders of the Wayward Protector", currentItemSlot = 3},
				{name = "Spaulders of the Wayward Vanquisher", currentItemSlot = 3},
				--TIER 8, 25-man
				{name = "Breastplate of the Wayward Conqueror", currentItemSlot = 5},
				{name = "Breastplate of the Wayward Protector", currentItemSlot = 5},
				{name = "Breastplate of the Wayward Vanquisher", currentItemSlot = 5},	
				{name = "Gauntlets of the Wayward Conqueror", currentItemSlot = 10},
				{name = "Gauntlets of the Wayward Protector", currentItemSlot = 10},
				{name = "Gauntlets of the Wayward Vanquisher", currentItemSlot = 10},	
				{name = "Crown of the Wayward Conqueror", currentItemSlot = 1},
				{name = "Crown of the Wayward Protector", currentItemSlot = 1},
				{name = "Crown of the Wayward Vanquisher", currentItemSlot = 1},
				{name = "Legplates of the Wayward Conqueror", currentItemSlot = 7},
				{name = "Legplates of the Wayward Protector", currentItemSlot = 7},
				{name = "Legplates of the Wayward Vanquisher", currentItemSlot = 7},
				{name = "Mantle of the Wayward Conqueror", currentItemSlot = 3},
				{name = "Mantle of the Wayward Protector", currentItemSlot = 3},
				{name = "Mantle of the Wayward Vanquisher", currentItemSlot = 3},				
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
		weights = {
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Rogue",
				["id"] = 1785517274,
				["defaultClass"] = "Rogue",
				["gems"] = {
					["meta"] = {
						["id"] = 41398,
						["name"] = "Relentless Earthsiege Diamond",
						["itemLinkId"] = 3628,
					},
					["yellow"] = {
						["id"] = 40147,
						["name"] = "Deadly Ametrine",
						["itemLinkId"] = 3554,
					},
					["blue"] = {
						["id"] = 40130,
						["name"] = "Shifting Dreadstone",
						["itemLinkId"] = 3537,
					},
					["red"] = {
						["id"] = 40112,
						["name"] = "Delicate Cardinal Ruby",
						["itemLinkId"] = 3519,
					},
				},
				["stats"] = {
					{
						["id"] = "AGI",
						["uid"] = 407384209,
						["value"] = 100,
					}, -- [1]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 1815337064,
						["value"] = 100,
					}, -- [2]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 360393463,
						["value"] = 82,
					}, -- [3]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1071021997,
						["value"] = 82,
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 762534631,
						["value"] = 83,
					}, -- [5]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 622021159,
						["value"] = 55,
					}, -- [6]
					{
						["id"] = "STR",
						["uid"] = 1656735104,
						["value"] = 50,
					}, -- [7]
					{
						["id"] = "AP",
						["uid"] = 1290181070,
						["value"] = 46,
					}, -- [8]
					{
						["id"] = "STA",
						["uid"] = 1197248186,
						["value"] = 1,
					}, -- [9]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 932146975,
						["value"] = -100,
					}, -- [10]
				},
			}, -- [2]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Blood DPS",
				["id"] = 797269771,
				["defaultClass"] = "Death Knight",
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40162,
						["name"] = "Accurate Ametrine",
						["itemLinkId"] = 3570,
					},
					["blue"] = {
						["id"] = 40129,
						["name"] = "Sovereign Dreadstone",
						["itemLinkId"] = 3536,
					},
					["red"] = {
						["id"] = 40111,
						["name"] = "Bold Cardinal Ruby",
						["itemLinkId"] = 3518,
					},
				},
				["stats"] = {
					{
						["id"] = "DPS",
						["uid"] = 169153579,
						["value"] = 361,
					}, -- [1]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 744642757,
						["value"] = 100,
					}, -- [2]
					{
						["id"] = "STR",
						["uid"] = 282730933,
						["value"] = 97,
					}, -- [3]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 368847865,
						["value"] = 64,
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 656428609,
						["value"] = 44,
					}, -- [5]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 1810159562,
						["value"] = 40,
					}, -- [6]
					{
						["id"] = "AP",
						["uid"] = 143790373,
						["value"] = 38,
					}, -- [7]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 864642835,
						["value"] = 22,
					}, -- [8]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1517794544,
						["value"] = -100,
					}, -- [9]
				},
			}, -- [3]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Frost DPS",
				["id"] = 593249977,
				["defaultClass"] = "Death Knight",
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40162,
						["name"] = "Accurate Ametrine",
						["itemLinkId"] = 3570,
					},
					["blue"] = {
						["id"] = 40129,
						["name"] = "Sovereign Dreadstone",
						["itemLinkId"] = 3536,
					},
					["red"] = {
						["id"] = 40111,
						["name"] = "Bold Cardinal Ruby",
						["itemLinkId"] = 3518,
					},
				},
				["stats"] = {
					{
						["id"] = "DPS",
						["uid"] = 1912595456,
						["value"] = 417,
					}, -- [1]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1197641414,
						["value"] = 100,
					}, -- [2]
					{
						["id"] = "STR",
						["uid"] = 313927021,
						["value"] = 99,
					}, -- [3]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 854877673,
						["value"] = 52,
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 624904831,
						["value"] = 50,
					}, -- [5]
					{
						["id"] = "AP",
						["uid"] = 10617157,
						["value"] = 42,
					}, -- [6]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 653413861,
						["value"] = 32,
					}, -- [7]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 1084129598,
						["value"] = 21,
					}, -- [8]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1519367456,
						["value"] = -100,
					}, -- [9]
				},
			}, -- [4]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Unholy DPS",
				["id"] = 184620547,
				["defaultClass"] = "Death Knight",
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40162,
						["name"] = "Accurate Ametrine",
						["itemLinkId"] = 3570,
					},
					["blue"] = {
						["id"] = 40129,
						["name"] = "Sovereign Dreadstone",
						["itemLinkId"] = 3536,
					},
					["red"] = {
						["id"] = 40111,
						["name"] = "Bold Cardinal Ruby",
						["itemLinkId"] = 3518,
					},
				},
				["stats"] = {
					{
						["id"] = "DPS",
						["uid"] = 508574881,
						["value"] = 305,
					}, -- [1]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1022720491,
						["value"] = 100,
					}, -- [2]
					{
						["id"] = "STR",
						["uid"] = 1038318535,
						["value"] = 100,
					}, -- [3]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 1269077834,
						["value"] = 56,
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 552419803,
						["value"] = 46,
					}, -- [5]
					{
						["id"] = "AP",
						["uid"] = 237706327,
						["value"] = 41,
					}, -- [6]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 377171191,
						["value"] = 26,
					}, -- [7]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 759716497,
						["value"] = 22,
					}, -- [8]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 886925755,
						["value"] = -100,
					}, -- [9]
				},
			}, -- [5]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Frost Tank",
				["id"] = 927362701,
				["defaultClass"] = "Death Knight",
				["gems"] = {
					["meta"] = {
						["id"] = 41380,
						["name"] = "Austere Earthsiege Diamond",
						["itemLinkId"] = 3637,
					},
					["yellow"] = {
						["id"] = 40167,
						["name"] = "Enduring Eye of Zul",
						["itemLinkId"] = 3575,
					},
					["blue"] = {
						["id"] = 40119,
						["name"] = "Solid Majestic Zircon",
						["itemLinkId"] = 3532,
					},
					["red"] = {
						["id"] = 40139,
						["name"] = "Defender's Dreadstone",
						["itemLinkId"] = 3541,
					},
				},
				["stats"] = {
					{
						["id"] = "DPS",
						["uid"] = 1550170316,
						["value"] = 432,
					}, -- [1]
					{
						["id"] = "PARRY_RATING",
						["uid"] = 1887887630,
						["value"] = 103,
					}, -- [2]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1670170394,
						["value"] = 100,
					}, -- [3]
					{
						["id"] = "STR",
						["uid"] = 1033796413,
						["value"] = 99,
					}, -- [4]
					{
						["id"] = "DEFENSE_RATING",
						["uid"] = 1003386781,
						["value"] = 88,
					}, -- [5]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 1714408544,
						["value"] = 71,
					}, -- [6]
					{
						["id"] = "DODGE_RATING",
						["uid"] = 1108444196,
						["value"] = 63,
					}, -- [7]
					{
						["id"] = "AGI",
						["uid"] = 1060732531,
						["value"] = 63,
					}, -- [8]
					{
						["id"] = "STA",
						["uid"] = 445658401,
						["value"] = 63,
					}, -- [9]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 2025320816,
						["value"] = 50,
					}, -- [10]
					{
						["id"] = "AP",
						["uid"] = 1405200260,
						["value"] = 42,
					}, -- [11]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 88935067,
						["value"] = 32,
					}, -- [12]
					{
						["id"] = "ARMOR",
						["uid"] = 707482711,
						["value"] = 5,
					}, -- [13]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1237619594,
						["value"] = -100,
					}, -- [14]
				},
			}, -- [6]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Balance",
				["id"] = 919301527,
				["defaultClass"] = "Druid",
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40155,
						["name"] = "Reckless Ametrine",
						["itemLinkId"] = 3563,
					},
					["blue"] = {
						["id"] = 40133,
						["name"] = "Purified Dreadstone",
						["itemLinkId"] = 3545,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1126598222,
						["value"] = 100,
					}, -- [1]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 1229230730,
						["value"] = 46,
					}, -- [2]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1892934056,
						["value"] = 46,
					}, -- [3]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 297870211,
						["value"] = 43,
					}, -- [4]
					{
						["id"] = "INT",
						["uid"] = 702305209,
						["value"] = 26,
					}, -- [5]
					{
						["id"] = "MANA_REG",
						["uid"] = 1656014186,
						["value"] = 15,
					}, -- [6]
					{
						["id"] = "SPI",
						["uid"] = 428028679,
						["value"] = 8,
					}, -- [7]
					{
						["id"] = "AP",
						["uid"] = 462501667,
						["value"] = -100,
					}, -- [8]
				},
			}, -- [7]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Feral DPS",
				["id"] = 2133392978,
				["defaultClass"] = "Druid",
				["gems"] = {
					["meta"] = {
						["id"] = 41398,
						["name"] = "Relentless Earthsiege Diamond",
						["itemLinkId"] = 3628,
					},
					["yellow"] = {
						["id"] = 40147,
						["name"] = "Deadly Ametrine",
						["itemLinkId"] = 3554,
					},
					["blue"] = {
						["id"] = 40140,
						["name"] = "Puissant Dreadstone",
						["itemLinkId"] = 3543,
					},
					["red"] = {
						["id"] = 40112,
						["name"] = "Delicate Cardinal Ruby",
						["itemLinkId"] = 3519,
					},
				},
				["stats"] = {
					{
						["id"] = "STR",
						["uid"] = 62326639,
						["value"] = 100,
					}, -- [1]
					{
						["id"] = "AGI",
						["uid"] = 108989695,
						["value"] = 85,
					}, -- [2]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 470890531,
						["value"] = 58,
					}, -- [3]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1639564148,
						["value"] = 58,
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 2014179356,
						["value"] = 52,
					}, -- [5]
					{
						["id"] = "FERAL_AP",
						["uid"] = 2115173414,
						["value"] = 43,
					}, -- [6]
					{
						["id"] = "AP",
						["uid"] = 480328003,
						["value"] = 43,
					}, -- [7]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 1171229600,
						["value"] = 42,
					}, -- [8]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 1042512967,
						["value"] = 40,
					}, -- [9]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1973349182,
						["value"] = -100,
					}, -- [10]
				},
			}, -- [8]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Tanking",
				["id"] = 1154058644,
				["defaultClass"] = "Druid",
				["gems"] = {
					["meta"] = {
						["id"] = 41380,
						["name"] = "Austere Earthsiege Diamond",
						["itemLinkId"] = 3637,
					},
					["yellow"] = {
						["id"] = 40130,
						["name"] = "Shifting Dreadstone",
						["itemLinkId"] = 3537,
					},
					["blue"] = {
						["id"] = 40119,
						["name"] = "Solid Majestic Zircon",
						["itemLinkId"] = 3532,
					},
					["red"] = {
						["id"] = 40112,
						["name"] = "Delicate Cardinal Ruby",
						["itemLinkId"] = 3519,
					},
				},
				["stats"] = {
					{
						["id"] = "AGI",
						["uid"] = 2073622322,
						["value"] = 100,
					}, -- [1]
					{
						["id"] = "DEFENSE_RATING",
						["uid"] = 1179225236,
						["value"] = 72,
					}, -- [2]
					{
						["id"] = "DODGE_RATING",
						["uid"] = 49087963,
						["value"] = 70,
					}, -- [3]
					{
						["id"] = "STA",
						["uid"] = 230234995,
						["value"] = 65,
					}, -- [4]
					{
						["id"] = "ARMOR",
						["uid"] = 1196330654,
						["value"] = 25,
					}, -- [5]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 1698351734,
						["value"] = 16,
					}, -- [6]
					{
						["id"] = "STR",
						["uid"] = 1691339168,
						["value"] = 10,
					}, -- [7]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1441311698,
						["value"] = 6,
					}, -- [8]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 1094025836,
						["value"] = 5,
					}, -- [9]
					{
						["id"] = "FERAL_AP",
						["uid"] = 1372038032,
						["value"] = 4,
					}, -- [10]
					{
						["id"] = "AP",
						["uid"] = 1437838184,
						["value"] = 4,
					}, -- [11]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 931884823,
						["value"] = 3,
					}, -- [12]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1141737500,
						["value"] = -100,
					}, -- [13]
				},
			}, -- [9]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Restoration",
				["defaultClass"] = "Druid",
				["id"] = 1110410336,
				["gems"] = {
					["meta"] = {
						["id"] = 41401,
						["name"] = "Insightful Earthsiege Diamond",
						["itemLinkId"] = 3627,
					},
					["yellow"] = {
						["id"] = 40151,
						["name"] = "Luminous Ametrine",
						["itemLinkId"] = 3558,
					},
					["blue"] = {
						["id"] = 40133,
						["name"] = "Purified Dreadstone",
						["itemLinkId"] = 3545,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "MANA_REG",
						["uid"] = 994670227,
						["value"] = 100,
					}, -- [1]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1799214716,
						["value"] = 53,
					}, -- [2]
					{
						["id"] = "SPI",
						["uid"] = 1957095758,
						["value"] = 48,
					}, -- [3]
					{
						["id"] = "INT",
						["uid"] = 1200197396,
						["value"] = 28,
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 1034189641,
						["value"] = 14,
					}, -- [5]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 927755929,
						["value"] = 12,
					}, -- [6]
					{
						["id"] = "AP",
						["uid"] = 2005135112,
						["value"] = -100,
					}, -- [7]
				},
			}, -- [10]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Beast Mastery",
				["defaultClass"] = "Hunter",
				["id"] = 1609416668,
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40128,
						["name"] = "Quick King's Amber",
						["itemLinkId"] = 3531,
					},
					["blue"] = {
						["id"] = 40130,
						["name"] = "Shifting Dreadstone",
						["itemLinkId"] = 3537,
					},
					["red"] = {
						["id"] = 40112,
						["name"] = "Delicate Cardinal Ruby",
						["itemLinkId"] = 3519,
					},
				},
				["stats"] = {
					{
						["id"] = "DPS",
						["uid"] = 2079389666,
						["value"] = 134,
					}, -- [1]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 2103114422,
						["value"] = 100,
					}, -- [2]
					{
						["id"] = "INT",
						["uid"] = 1241879564,
						["value"] = 94,
					}, -- [3]
					{
						["id"] = "AGI",
						["uid"] = 992179783,
						["value"] = 59,
					}, -- [4]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 1574419376,
						["value"] = 54,
					}, -- [5]
					{
						["id"] = "MANA_REG",
						["uid"] = 2073556784,
						["value"] = 48,
					}, -- [6]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 854877673,
						["value"] = 43,
					}, -- [7]
					{
						["id"] = "AP",
						["uid"] = 871589863,
						["value"] = 39,
					}, -- [8]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 225712873,
						["value"] = 37,
					}, -- [9]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 616581505,
						["value"] = -100,
					}, -- [10]
				},
			}, -- [11]	
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Marksmanship",
				["defaultClass"] = "Hunter",
				["id"] = 1609416669,
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40128,
						["name"] = "Quick King's Amber",
						["itemLinkId"] = 3531,
					},
					["blue"] = {
						["id"] = 40130,
						["name"] = "Shifting Dreadstone",
						["itemLinkId"] = 3537,
					},
					["red"] = {
						["id"] = 40112,
						["name"] = "Delicate Cardinal Ruby",
						["itemLinkId"] = 3519,
					},
				},
				["stats"] = {
					{
						["id"] = "DPS",
						["uid"] = 2079389666,
						["value"] = 151,
					}, -- [1]
					{
						["id"] = "INT",
						["uid"] = 1241879564,
						["value"] = 100,
					}, -- [3]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 2103114422,
						["value"] = 90,
					}, -- [2]
					{
						["id"] = "MANA_REG",
						["uid"] = 2073556784,
						["value"] = 70,
					}, -- [6]					
					{
						["id"] = "AGI",
						["uid"] = 992179783,
						["value"] = 63,
					}, -- [4]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 1574419376,
						["value"] = 62,
					}, -- [5]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 854877673,
						["value"] = 59,
					}, -- [7]
					{
						["id"] = "AP",
						["uid"] = 871589863,
						["value"] = 38,
					}, -- [8]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 225712873,
						["value"] = 43,
					}, -- [9]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 616581505,
						["value"] = -100,
					}, -- [10]
				},
			}, -- [12]	
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Survival",
				["id"] = 2130640382,
				["defaultClass"] = "Hunter",
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40128,
						["name"] = "Quick King's Amber",
						["itemLinkId"] = 3531,
					},
					["blue"] = {
						["id"] = 40130,
						["name"] = "Shifting Dreadstone",
						["itemLinkId"] = 3537,
					},
					["red"] = {
						["id"] = 40112,
						["name"] = "Delicate Cardinal Ruby",
						["itemLinkId"] = 3519,
					},
				},
				["stats"] = {
					{
						["id"] = "DPS",
						["uid"] = 1986194630,
						["value"] = "147",
					}, -- [1]
					{
						["id"] = "INT",
						["uid"] = 492845761,
						["value"] = "100",
					}, -- [2]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1725091238,
						["value"] = "93",
					}, -- [3]
					{
						["id"] = "AGI",
						["uid"] = 1241355260,
						["value"] = "83",
					}, -- [4]
					{
						["id"] = "MANA_REG",
						["uid"] = 1727253992,
						["value"] = "72",
					}, -- [5]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 399650725,
						["value"] = "70",
					}, -- [6]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 423768709,
						["value"] = "66",
					}, -- [7]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 1121420720,
						["value"] = "58",
					}, -- [8]
					{
						["id"] = "AP",
						["uid"] = 237968479,
						["value"] = "35",
					}, -- [9]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 784752013,
						["value"] = "-100",
					}, -- [10]
				},
			}, -- [12]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Arcane",
				["id"] = 1191218690,
				["defaultClass"] = "Mage",
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40155,
						["name"] = "Reckless Ametrine",
						["itemLinkId"] = 3563,
					},
					["blue"] = {
						["id"] = 40132,
						["name"] = "Glowing Dreadstone",
						["itemLinkId"] = 3538,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1697368664,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 2129264084,
						["value"] = "49",
					}, -- [2]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1444457522,
						["value"] = "44",
					}, -- [3]
					{
						["id"] = "INT",
						["uid"] = 2128149938,
						["value"] = "39",
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 1980558362,
						["value"] = "34",
					}, -- [5]
					{
						["id"] = "SPI",
						["uid"] = 1411557446,
						["value"] = "14",
					}, -- [6]
					{
						["id"] = "MANA_REG",
						["uid"] = 490617469,
						["value"] = "9",
					}, -- [7]
					{
						["id"] = "AP",
						["uid"] = 1470213956,
						["value"] = "-100",
					}, -- [8]
				},
			}, -- [13]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Fire",
				["id"] = 570835981,
				["defaultClass"] = "Mage",
				["gems"] = {
					["meta"] = {
						["id"] = 41380,
						["name"] = "Austere Earthsiege Diamond",
						["itemLinkId"] = 3637,
					},
					["blue"] = {
						["id"] = 40132,
						["name"] = "Glowing Dreadstone",
						["itemLinkId"] = 3538,
					},
					["yellow"] = {
						["id"] = 40152,
						["name"] = "Potent Ametrine",
						["itemLinkId"] = 3559,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1832114792,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 1599061664,
						["value"] = "55",
					}, -- [2]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1488761210,
						["value"] = "49",
					}, -- [3]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 2078209982,
						["value"] = "47",
					}, -- [4]
					{
						["id"] = "INT",
						["uid"] = 626084515,
						["value"] = "35",
					}, -- [5]
					{
						["id"] = "MANA_REG",
						["uid"] = 450770365,
						["value"] = "15",
					}, -- [6]
					{
						["id"] = "AP",
						["uid"] = 742152313,
						["value"] = "-100",
					}, -- [7]
				},
			}, -- [14]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Frost",
				["defaultClass"] = "Mage",
				["id"] = 2077030298,
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40152,
						["name"] = "Potent Ametrine",
						["itemLinkId"] = 3559,
					},
					["blue"] = {
						["id"] = 40132,
						["name"] = "Glowing Dreadstone",
						["itemLinkId"] = 3538,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1921246472,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1860754898,
						["value"] = "50",
					}, -- [2]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 1180798148,
						["value"] = "46",
					}, -- [3]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 556417621,
						["value"] = "33",
					}, -- [4]
					{
						["id"] = "INT",
						["uid"] = 703681507,
						["value"] = "21",
					}, -- [5]
					{
						["id"] = "MANA_REG",
						["uid"] = 1285003568,
						["value"] = "13",
					}, -- [6]
					{
						["id"] = "AP",
						["uid"] = 1873207118,
						["value"] = "-100",
					}, -- [7]
				},
			}, -- [15]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Holy",
				["id"] = 562643731,
				["defaultClass"] = "Paladin",
				["gems"] = {
					["meta"] = {
						["id"] = 41401,
						["name"] = "Insightful Earthsiege Diamond",
						["itemLinkId"] = 3627,
					},
					["yellow"] = {
						["id"] = 40123,
						["name"] = "Brilliant King's Amber",
						["itemLinkId"] = 3526,
					},
					["blue"] = {
						["id"] = 40175,
						["name"] = "Dazzling Eye of Zul",
						["itemLinkId"] = 3583,
					},
					["red"] = {
						["id"] = 40151,
						["name"] = "Luminous Ametrine",
						["itemLinkId"] = 3558,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 619399639,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1122076100,
						["value"] = "55",
					}, -- [2]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 1786893572,
						["value"] = "36",
					}, -- [3]
					{
						["id"] = "INT",
						["uid"] = 1499902670,
						["value"] = "29",
					}, -- [4]
					{
						["id"] = "MANA_REG",
						["uid"] = 943157359,
						["value"] = "15",
					}, -- [5]
					{
						["id"] = "AP",
						["uid"] = 1977215924,
						["value"] = "-100",
					}, -- [6]
				},
			}, -- [16]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Protection",
				["defaultClass"] = "Paladin",
				["id"] = 107678935,
				["gems"] = {
					["meta"] = {
						["id"] = 41380,
						["name"] = "Austere Earthsiege Diamond",
						["itemLinkId"] = 3637,
					},
					["yellow"] = {
						["id"] = 40167,
						["name"] = "Enduring Eye of Zul",
						["itemLinkId"] = 3575,
					},
					["blue"] = {
						["id"] = 40119,
						["name"] = "Solid Majestic Zircon",
						["itemLinkId"] = 3532,
					},
					["red"] = {
						["id"] = 40139,
						["name"] = "Defender's Dreadstone",
						["itemLinkId"] = 3541,
					},
				},
				["stats"] = {
					{
						["id"] = "DEFENSE_RATING",
						["uid"] = 690115141,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "STR",
						["uid"] = 867460969,
						["value"] = "96",
					}, -- [2]
					{
						["id"] = "AGI",
						["uid"] = 1419880772,
						["value"] = "88",
					}, -- [3]
					{
						["id"] = "BLOCK_RATING",
						["uid"] = 599738239,
						["value"] = "80",
					}, -- [4]
					{
						["id"] = "DODGE_RATING",
						["uid"] = 393621229,
						["value"] = "79",
					}, -- [5]
					{
						["id"] = "STA",
						["uid"] = 62850943,
						["value"] = "76",
					}, -- [6]
					{
						["id"] = "PARRY_RATING",
						["uid"] = 923037193,
						["value"] = "76",
					}, -- [7]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 1682098310,
						["value"] = "53",
					}, -- [8]
					{
						["id"] = "BLOCK_VALUE",
						["uid"] = 214374799,
						["value"] = "52",
					}, -- [9]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 155128447,
						["value"] = "50",
					}, -- [10]
					{
						["id"] = "AP",
						["uid"] = 1378788446,
						["value"] = "25",
					}, -- [11]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 976188511,
						["value"] = "23",
					}, -- [12]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1705495376,
						["value"] = "20",
					}, -- [13]
					{
						["id"] = "ARMOR",
						["uid"] = 503593993,
						["value"] = "9",
					}, -- [14]
				},
			}, -- [17]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Retribution",
				["defaultClass"] = "Paladin",
				["id"] = 872966161,
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40142,
						["name"] = "Inscribed Ametrine",
						["itemLinkId"] = 3549,
					},
					["blue"] = {
						["id"] = 40129,
						["name"] = "Sovereign Dreadstone",
						["itemLinkId"] = 3536,
					},
					["red"] = {
						["id"] = 40111,
						["name"] = "Bold Cardinal Ruby",
						["itemLinkId"] = 3518,
					},
				},
				["stats"] = {
					{
						["id"] = "STR",
						["uid"] = 748837189,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 2059728266,
						["value"] = "70",
					}, -- [2]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 1350279416,
						["value"] = "67",
					}, -- [3]
					{
						["id"] = "AGI",
						["uid"] = 1717619906,
						["value"] = "67",
					}, -- [4]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1006139377,
						["value"] = "59",
					}, -- [5]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 1493348870,
						["value"] = "44",
					}, -- [6]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 764828461,
						["value"] = "38",
					}, -- [7]
					{
						["id"] = "AP",
						["uid"] = 2144403362,
						["value"] = "38",
					}, -- [8]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1592442326,
						["value"] = "12",
					}, -- [9]
				},
			}, -- [18]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Discipline",
				["defaultClass"] = "Priest",
				["id"] = 41354479,
				["gems"] = {
					["meta"] = {
						["id"] = 41401,
						["name"] = "Insightful Earthsiege Diamond",
						["itemLinkId"] = 3627,
					},
					["blue"] = {
						["id"] = 40133,
						["name"] = "Purified Dreadstone",
						["itemLinkId"] = 3545,
					},
					["yellow"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_DMG",
						["uid"] = 895183543,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 1382655188,
						["value"] = "95",
					}, -- [2]
					{
						["id"] = "INT",
						["uid"] = 1223594462,
						["value"] = "59",
					}, -- [3]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 1854856478,
						["value"] = "47",
					}, -- [4]
					{
						["id"] = "MANA_REG",
						["uid"] = 437793841,
						["value"] = "36",
					}, -- [5]
					{
						["id"] = "SPI",
						["uid"] = 1644479498,
						["value"] = "36",
					}, -- [6]
					{
						["id"] = "AP",
						["uid"] = 1829427734,
						["value"] = "-100",
					}, -- [7]
				},
			}, -- [19]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Holy",
				["defaultClass"] = "Priest",
				["id"] = 1610989580,
				["gems"] = {
					["meta"] = {
						["id"] = 41401,
						["name"] = "Insightful Earthsiege Diamond",
						["itemLinkId"] = 3627,
					},
					["blue"] = {
						["id"] = 40133,
						["name"] = "Purified Dreadstone",
						["itemLinkId"] = 3545,
					},
					["yellow"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1435544354,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "MANA_REG",
						["uid"] = 1730006588,
						["value"] = "93",
					}, -- [2]
					{
						["id"] = "INT",
						["uid"] = 1364304548,
						["value"] = "88",
					}, -- [3]
					{
						["id"] = "SPI",
						["uid"] = 1261606502,
						["value"] = "85",
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 502741999,
						["value"] = "63",
					}, -- [5]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 147657115,
						["value"] = "51",
					}, -- [6]
					{
						["id"] = "AP",
						["uid"] = 230234995,
						["value"] = "-100",
					}, -- [7]
				},
			}, -- [20]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Shadow",
				["defaultClass"] = "Priest",
				["id"] = 695292643,
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40152,
						["name"] = "Potent Ametrine",
						["itemLinkId"] = 3559,
					},
					["blue"] = {
						["id"] = 40133,
						["name"] = "Purified Dreadstone",
						["itemLinkId"] = 3545,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 901213039,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 991065637,
						["value"] = "61",
					}, -- [2]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 1519498532,
						["value"] = "50",
					}, -- [3]
					{
						["id"] = "INT",
						["uid"] = 531578719,
						["value"] = "43",
					}, -- [4]
					{
						["id"] = "MANA_REG",
						["uid"] = 1470279494,
						["value"] = "27",
					}, -- [5]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 1745866784,
						["value"] = "25",
					}, -- [6]
					{
						["id"] = "SPI",
						["uid"] = 1312201838,
						["value"] = "6",
					}, -- [7]
					{
						["id"] = "AP",
						["uid"] = 1884217502,
						["value"] = "-100",
					}, -- [8]
				},
			}, -- [21]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Elemental",
				["defaultClass"] = "Shaman",
				["id"] = 345778489,
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40152,
						["name"] = "Potent Ametrine",
						["itemLinkId"] = 3559,
					},
					["blue"] = {
						["id"] = 40166,
						["name"] = "Vivid Eye of Zul",
						["itemLinkId"] = 3574,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1478864972,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 1443277838,
						["value"] = "65",
					}, -- [2]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 798252841,
						["value"] = "40",
					}, -- [3]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 101714977,
						["value"] = "35",
					}, -- [4]
					{
						["id"] = "INT",
						["uid"] = 1268553530,
						["value"] = "10",
					}, -- [5]
					{
						["id"] = "AP",
						["uid"] = 42927391,
						["value"] = "-100",
					}, -- [6]
				},
			}, -- [22]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Enhancement",
				["defaultClass"] = "Shaman",
				["id"] = 1374987242,
				["gems"] = {
					["meta"] = {
						["id"] = 41398,
						["name"] = "Relentless Earthsiege Diamond",
						["itemLinkId"] = 3628,
					},
					["yellow"] = {
						["id"] = 40162,
						["name"] = "Accurate Ametrine",
						["itemLinkId"] = 3570,
					},
					["blue"] = {
						["id"] = 40166,
						["name"] = "Vivid Eye of Zul",
						["itemLinkId"] = 3574,
					},
					["red"] = {
						["id"] = 40162,
						["name"] = "Accurate Ametrine",
						["itemLinkId"] = 3570,
					},
				},
				["stats"] = {
					{
						["id"] = "DPS",
						["uid"] = 685396405,
						["value"] = "192",
					}, -- [1]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 224795341,
						["value"] = "100",
					}, -- [2]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 802381735,
						["value"] = "84",
					}, -- [3]
					{
						["id"] = "INT",
						["uid"] = 427766527,
						["value"] = "55",
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 1940121416,
						["value"] = "55",
					}, -- [5]
					{
						["id"] = "AGI",
						["uid"] = 850486627,
						["value"] = "55",
					}, -- [6]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 57345751,
						["value"] = "42",
					}, -- [7]
					{
						["id"] = "STR",
						["uid"] = 1425779192,
						["value"] = "36",
					}, -- [8]
					{
						["id"] = "AP",
						["uid"] = 1996156406,
						["value"] = "33",
					}, -- [9]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 265691053,
						["value"] = "30",
					}, -- [10]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 1591459256,
						["value"] = "26",
					}, -- [11]
				},
			}, -- [23]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Restoration",
				["defaultClass"] = "Shaman",
				["id"] = 2020077776,
				["gems"] = {
					["meta"] = {
						["id"] = 41401,
						["name"] = "Insightful Earthsiege Diamond",
						["itemLinkId"] = 3627,
					},
					["yellow"] = {
						["id"] = 40155,
						["name"] = "Reckless Ametrine",
						["itemLinkId"] = 3563,
					},
					["blue"] = {
						["id"] = 40179,
						["name"] = "Energized Eye of Zul",
						["itemLinkId"] = 3587,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "MANA_REG",
						["uid"] = 771578875,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "INT",
						["uid"] = 1359847964,
						["value"] = "87",
					}, -- [2]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 2024796512,
						["value"] = "76",
					}, -- [3]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 792223345,
						["value"] = "57",
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 865756981,
						["value"] = "34",
					}, -- [5]
					{
						["id"] = "AP",
						["uid"] = 211753279,
						["value"] = "-100",
					}, -- [6]
				},
			}, -- [24]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Affliction",
				["defaultClass"] = "Warlock",
				["id"] = 1203670910,
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40153,
						["name"] = "Veiled Ametrine",
						["itemLinkId"] = 3560,
					},
					["blue"] = {
						["id"] = 40133,
						["name"] = "Purified Dreadstone",
						["itemLinkId"] = 3545,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_DMG",
						["uid"] = 874407997,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPI",
						["uid"] = 1384490252,
						["value"] = "74",
					}, -- [2]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 70649965,
						["value"] = "32",
					}, -- [3]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 1723649402,
						["value"] = "25",
					}, -- [4]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 7209181,
						["value"] = "24",
					}, -- [5]
					{
						["id"] = "MANA_REG",
						["uid"] = 841901149,
						["value"] = "22",
					}, -- [6]
					{
						["id"] = "INT",
						["uid"] = 1926751664,
						["value"] = "14",
					}, -- [7]
					{
						["id"] = "AP",
						["uid"] = 190518967,
						["value"] = "-100",
					}, -- [8]
				},
			}, -- [25]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Demonology",
				["defaultClass"] = "Warlock",
				["id"] = 1087472036,
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40153,
						["name"] = "Veiled Ametrine",
						["itemLinkId"] = 3560,
					},
					["blue"] = {
						["id"] = 40133,
						["name"] = "Purified Dreadstone",
						["itemLinkId"] = 3545,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_DMG",
						["uid"] = 114036121,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPI",
						["uid"] = 1716964526,
						["value"] = "96",
					}, -- [2]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1625801168,
						["value"] = "49",
					}, -- [3]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 609175711,
						["value"] = "37",
					}, -- [4]
					{
						["id"] = "MANA_REG",
						["uid"] = 140775625,
						["value"] = "33",
					}, -- [5]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 1908859790,
						["value"] = "21",
					}, -- [6]
					{
						["id"] = "INT",
						["uid"] = 1923212612,
						["value"] = "12",
					}, -- [7]
					{
						["id"] = "AP",
						["uid"] = 466171795,
						["value"] = "-100",
					}, -- [8]
				},
			}, -- [26]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Destruction",
				["defaultClass"] = "Warlock",
				["id"] = 979072183,
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40153,
						["name"] = "Veiled Ametrine",
						["itemLinkId"] = 3560,
					},
					["blue"] = {
						["id"] = 40133,
						["name"] = "Purified Dreadstone",
						["itemLinkId"] = 3545,
					},
					["red"] = {
						["id"] = 40113,
						["name"] = "Runed Cardinal Ruby",
						["itemLinkId"] = 3520,
					},
				},
				["stats"] = {
					{
						["id"] = "SPELL_DMG",
						["uid"] = 342042823,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "SPI",
						["uid"] = 1893654974,
						["value"] = "56",
					}, -- [2]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1205964740,
						["value"] = "50",
					}, -- [3]
					{
						["id"] = "MANA_REG",
						["uid"] = 1372955564,
						["value"] = "48",
					}, -- [4]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 1736167160,
						["value"] = "48",
					}, -- [5]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 1700907716,
						["value"] = "47",
					}, -- [6]
					{
						["id"] = "INT",
						["uid"] = 774921313,
						["value"] = "45",
					}, -- [7]
					{
						["id"] = "AP",
						["uid"] = 1854594326,
						["value"] = "-100",
					}, -- [8]
				},
			}, -- [27]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Fury",
				["defaultClass"] = "Warrior",
				["id"] = 1795937816,
				["gems"] = {
					["meta"] = {
						["id"] = 41285,
						["name"] = "Chaotic Skyflare Diamond",
						["itemLinkId"] = 3621,
					},
					["yellow"] = {
						["id"] = 40162,
						["name"] = "Accurate Ametrine",
						["itemLinkId"] = 3570,
					},
					["blue"] = {
						["id"] = 40129,
						["name"] = "Sovereign Dreadstone",
						["itemLinkId"] = 3536,
					},
					["red"] = {
						["id"] = 40111,
						["name"] = "Bold Cardinal Ruby",
						["itemLinkId"] = 3518,
					},
				},
				["stats"] = {
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 197072767,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "AP",
						["uid"] = 1176669254,
						["value"] = "34",
					}, -- [2]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 1192594988,
						["value"] = "33",
					}, -- [3]
					{
						["id"] = "STR",
						["uid"] = 598886245,
						["value"] = "22",
					}, -- [4]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1405921178,
						["value"] = "18",
					}, -- [5]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 2069690042,
						["value"] = "18",
					}, -- [6]
					{
						["id"] = "AGI",
						["uid"] = 475084963,
						["value"] = "12",
					}, -- [7]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 148378033,
						["value"] = "3",
					}, -- [8]
					{
						["id"] = "ARMOR",
						["uid"] = 1958209904,
						["value"] = "1",
					}, -- [9]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 2112945122,
						["value"] = "-100",
					}, -- [10]
				},
			}, -- [28]
			{
				["enabled"] = true,
				["comparison"] = true,
				["name"] = "Protection",
				["defaultClass"] = "Warrior",
				["id"] = 102829123,
				["gems"] = {
					["meta"] = {
						["id"] = 41380,
						["name"] = "Austere Earthsiege Diamond",
						["itemLinkId"] = 3637,
					},
					["yellow"] = {
						["id"] = 40167,
						["name"] = "Enduring Eye of Zul",
						["itemLinkId"] = 3575,
					},
					["blue"] = {
						["id"] = 40119,
						["name"] = "Solid Majestic Zircon",
						["itemLinkId"] = 3532,
					},
					["red"] = {
						["id"] = 40139,
						["name"] = "Defender's Dreadstone",
						["itemLinkId"] = 3541,
					},
				},
				["stats"] = {
					{
						["id"] = "STA",
						["uid"] = 1496691308,
						["value"] = "100",
					}, -- [1]
					{
						["id"] = "DEFENSE_RATING",
						["uid"] = 1113359546,
						["value"] = "66",
					}, -- [2]
					{
						["id"] = "DODGE_RATING",
						["uid"] = 643058857,
						["value"] = "59",
					}, -- [3]
					{
						["id"] = "EXPERTISE_RATING",
						["uid"] = 2080831502,
						["value"] = "58",
					}, -- [4]
					{
						["id"] = "AGI",
						["uid"] = 1426369034,
						["value"] = "53",
					}, -- [5]
					{
						["id"] = "PARRY_RATING",
						["uid"] = 359475931,
						["value"] = "50",
					}, -- [6]
					{
						["id"] = "BLOCK_VALUE",
						["uid"] = 971011009,
						["value"] = "22",
					}, -- [7]
					{
						["id"] = "STR",
						["uid"] = 1009154125,
						["value"] = "17",
					}, -- [8]
					{
						["id"] = "SPELL_HIT_RATING",
						["uid"] = 1095467672,
						["value"] = "7",
					}, -- [9]
					{
						["id"] = "ARMOR",
						["uid"] = 1039498219,
						["value"] = "7",
					}, -- [10]
					{
						["id"] = "SPELL_CRIT_RATING",
						["uid"] = 333391807,
						["value"] = "5",
					}, -- [11]
					{
						["id"] = "ARMOR_PENETRATION_RATING",
						["uid"] = 883779931,
						["value"] = "5",
					}, -- [12]
					{
						["id"] = "AP",
						["uid"] = 731666233,
						["value"] = "3",
					}, -- [13]
					{
						["id"] = "SPELL_HASTE_RATING",
						["uid"] = 1608957902,
						["value"] = "3",
					}, -- [14]
					{
						["id"] = "SPELL_DMG",
						["uid"] = 804937717,
						["value"] = "-100",
					}, -- [15]
				},
			}, -- [29]	
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
				weightSortKey = 'stat',
				weightSortOrderNormal = true,
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
			name = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec fermentum vestibulum odio. Donec elit felis, condimentum auctor, sagittis non, adipiscing sit amet, massa. Praesent tortor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla vulputate mi at purus ultrices viverra. Integer felis turpis, accumsan non, vestibulum vitae, euismod id, ligula. Aliquam erat volutpat. Fusce gravida fermentum justo. Sed eu lectus. Morbi pharetra quam vitae ligula. Suspendisse eget nibh. In hac habitasse platea dictumst. Aliquam erat volutpat. Fusce nisl dui, euismod cursus, sagittis in, mollis a, felis. Vivamus arcu odio, molestie id, venenatis ut, elementum vel, ante.',
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
				framesInlineWeightScale = {
					name = 'Weight Scale Settings',
					type = 'group',
					guiInline = true,
					order = 2,
					args = {
						gemMinRarity = {
							name = 'Gem Minimum Rarity',
							desc = 'Determine what rarity gems must be equal to or above to be visible in the gem selection dropdowns for Weight Scales.',
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
								kAuction.db.profile.wishlist.config.gemMinRarity = value;
							end,
							get = function(info) return kAuction.db.profile.wishlist.config.gemMinRarity end,
							width = 'full',
						},
						gemMinItemLevel = {
							name = 'Gem Minimum Item Level',
							desc = 'Determines the minumum item level gems must be to be visible in the gem selection dropdowns for Weight Scales.',
							type = 'range',
							min = 0,
							max = 400,
							step = 1,
							set = function(info,value)
								kAuction.db.profile.wishlist.config.gemMinItemLevel = value;
							end,
							get = function(info) return kAuction.db.profile.wishlist.config.gemMinItemLevel end,
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