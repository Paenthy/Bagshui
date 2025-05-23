-- Bagshui Inventory Class Configuration
-- Exposes: Bagshui.config.Inventory

Bagshui:AddComponent(function()

-- Each key is an inventory type enum value and the value is a table of Inventory class properties.
-- See the `classObj` definition in Components\Inventory.lua for details.
-- Note that key bindings need to be defined in Bindings.xml.
---@type table<BS_INVENTORY_TYPE, table<string, any>>
Bagshui.config.Inventory = {

	[BS_INVENTORY_TYPE.BAGS] = {

		-- Backpack (16) + (4 Bag Slots * 20 slot bags)
		-- Some Vanilla implementations have larger bags available, but the
		-- Inventory class will handle that automatically.
		initialItemSlotButtons = 96,

		-- Append bags 1 through NUM_BAG_SLOTS to `containerIds` array when it is
		-- built at the end of this file.
		containerIdRange = { 1, _G.NUM_BAG_SLOTS },
		-- XML template for bag buttons.
		bagButtonTemplate = "BagshuiBagsContainerTemplate",
		-- Bag button inventory IDs are all offset by the same amount, starting
		-- with the Backpack.
		bagButtonIdOffset = _G.ContainerIDToInventoryID(0),
		-- PaperDollItemSlotButton code wants "Bag#Slot" when parsing the element's
		-- name with `strsub(<name>, 10)`.
		bagSlotNameFormat = "BgshiBagsBag%dSlot",
		-- Bag containers are BAG0SLOT - BAG3SLOT for `GetInventorySlotInfo()`.
		inventorySlotFormat = "BAG%dSLOT",
		-- Bag slots are Bag0Slot - Bag3Slot in `GetInventorySlotInfo()` but start
		-- at 1 for `GetContainerNumSlots()`.
		bagSlotNameNumberOffset = -1,

		primaryContainer = {
			-- BACKPACK_CONTAINER isn't available in 1.12 so hardcoding to 0.
			id = 0,
			name = _G.BACKPACK_TOOLTIP,
			texture = "Interface\\Buttons\\Button-Backpack-Up",
			bindingKey = "TOGGLEBACKPACK",
		},

		-- Using this in the item slot button's OnEnter increases compatibility
		-- with tooltip addons (CompareStats and anything else GFW_ based are notable examples).
		itemSlotTooltipFunction = "ContainerFrameItemButton_OnEnter",

		events = {
			-- Open/close with Mail frame.
			MAIL_SHOW = "Open",
			MAIL_CLOSED = "Close",
			-- Open/close with Bank frame.
			BANKFRAME_OPENED = "Open",
			BANKFRAME_CLOSED = "Close",
			-- Open/close with Auction frame.
			AUCTION_HOUSE_SHOW = "Open",
			AUCTION_HOUSE_CLOSED = "Close",
			-- Open/close with Trade frame (NOT TradeSkill frame)).
			TRADE_SHOW = "Open",
			TRADE_CLOSED = "Close",
		},

		apiFunctionsToHook = {
			OpenAllBags = "ToggleBag",
			OpenBackpack = "OpenBag",
			OpenBag = "OpenBag",
			CloseBackpack = "CloseBag",
			CloseBag = "CloseBag",
			ToggleBackpack = "ToggleBag",
			ToggleBag = "ToggleBag",
		},

		opensViaHooks = true,
		keyBindingPrefix = "TOGGLEBAG",

		hookSettingTranslations = {
			-- (Open|Close|Toggle)Backpack$ = Bag0.
			["Backpack$"] = "hookBag0",
			-- Letting the Backpack preference control OpenAllBags.
			-- This isn't currently made obvious in the UI, due to how hook settings are
			-- autogenerated, so we'll see if anyone complains.
			["^OpenAllBags$"] = "hookBag0",
		},

		-- Can use Bank if there isn't enough space to swap a bag.
		bagSwappingSupplementalStorage = {
			"Bank"
		},

		-- Bags get all the special toolbar buttons.

		hearthButton = true,
		clamButton = true,
		disenchantButton = true,
		pickLockButton = true,

		openSound = "igBackPackOpen",
		closeSound = "igBackPackClose",

		debug = true,
	},


	[BS_INVENTORY_TYPE.BANK] = {

		-- Bank (24) + (6 Purchasable Bag Slots * 20 slot bags) = 144
		-- Some Vanilla implementations have larger bags available, but the
		-- Inventory class will handle that automatically.
		initialItemSlotButtons = 144,

		-- Append bags 5 through 10 to containerIds array when it is built at
		-- the end of this file.
		containerIdRange = { 5, 10 },
		-- XML template for bag buttons.
		bagButtonTemplate = "BankItemButtonBagTemplate",
		-- Bank bag button IDs match their bag numbers.
		bagButtonIdOffset = 0,
		-- BankFrame code wants "Bag#" when parsing the element's name with
		-- `strsub(<name>, 10)`.
		bagSlotNameFormat = "BgshiBankBag%d",
		-- Bank containers are BAG1 - BAG6 for `GetInventorySlotInfo()`.
		inventorySlotFormat = "BAG%d",
		-- Bank bag slots are Bag1 - Bag6 in `GetInventorySlotInfo()` but start
		-- at 5 for `GetContainerNumSlots()`.
		bagSlotNameNumberOffset = -4,

		primaryContainer = {
			id = _G.BANK_CONTAINER,
			name = L.Bank,
			texture = "Interface\\ICONS\\inv_box_01",
		},

		getInventorySlotFunction = _G.BankButtonIDToInvSlotID,

		-- Bank doesn't need a tooltipFunction because it directly calls
		-- GameTooltip:SetInventoryItem() in its OnEnter script, so there's
		-- nothing else addons could be hooking.

		events = {
			BANKFRAME_CLOSED = "Close",
			BANKFRAME_OPENED = "Open",
			PLAYERBANKSLOTS_CHANGED = "UpdateBagBar",
			PLAYERBANKBAGSLOTS_CHANGED = "UpdateBagBar",
		},

		opensViaHooks = false,

		-- Can use Bags if there isn't enough space to swap a bag.
		bagSwappingSupplementalStorage = {
			"Bags"
		},

		-- Bank can't have the Clam button because `UseContainerItem()` just moves
		-- items to Bags.
		clamButton = false,

		--debug = true,
	},


	[BS_INVENTORY_TYPE.KEYRING] = {

		dockTo = BS_INVENTORY_TYPE.BAGS,

		-- Just create all 12 possible Keyring buttons.
		initialItemSlotButtons = 12,

		bagButtonTemplate = "BagshuiBagsContainerTemplate",

		primaryContainer = {
			id = _G.KEYRING_CONTAINER,
			name = _G.KEYRING,
			texture = "Interface\\ContainerFrame\\KeyRing-Bag-Icon",
			bindingKey = "TOGGLEKEYRING",
			numSlotsFunction = _G.GetKeyRingSize,
		},

		getInventorySlotFunction = _G.KeyRingButtonIDToInvSlotID,

		-- See comment in Bags config for reasoning.
		itemSlotTooltipFunction = "ContainerFrameItemButton_OnEnter",

		apiFunctionsToHook = {
			ToggleKeyRing = "ToggleKeyring",
		},

		opensViaHooks = true,

		hookSettingTranslations = {
			["KeyRing$"] = "hookBag-2",  -- ToggleKeyRing = Bag-2
		},

		openSound = "KeyRingOpen",
		closeSound = "KeyRingClose",

		--debug = true,
	}

}



-- Automatically construct full container ID lists, which are needed to build
-- hook settings (among other things, which is why we need to do it early).
for _, config in pairs(Bagshui.config.Inventory) do
	config.containerIds = {}
	config.inventorySlots = {}
	if config.primaryContainer then
		table.insert(config.containerIds, config.primaryContainer.id)
	else
		-- Toss something irrelevant into the first array slot if this inventory
		-- somehow doesn't have a primary container.
		table.insert(config.containerIds, -999)
	end
	if type(config.containerIdRange) == "table" and table.getn(config.containerIdRange) > 1 then
		for containerId = config.containerIdRange[1], config.containerIdRange[2] do
			table.insert(config.containerIds, containerId)

			-- Fill inventory slot IDs.
			if config.inventorySlotFormat then
				table.insert(config.inventorySlots, string.format(config.inventorySlotFormat, (containerId + config.bagSlotNameNumberOffset)))
			end
		end
	end
end


end)