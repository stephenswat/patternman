local _, _ = ...

local frame = CreateFrame("FRAME", "patternManFrame");

PATTERNMAN_itemList = {};
PATTERNMAN_autoClose = false;

SLASH_PATTERNMAN1 = '/pm'

frame:RegisterEvent("MERCHANT_SHOW");

local function showHelp()
  print('Welcome to PatternMan.')
  print('/pm help - displays this help page.')
  print('/pm list - displays your current shopping list.')
  print('/pm add [item] - adds the item to your shopping list.')
  print('/pm remove [item] - removes the item from your shopping list.')
  print('/pm clear - removes all items from your shopping list.')
  print('/pm autoclose - automatically closes merchant window.')
end

local function addToList(itemName)
  PATTERNMAN_itemList[itemName] = true;
end

local function removeFromList(itemName)
  PATTERNMAN_itemList[itemName] = nil;
end

local function toggleAutoClose()
  PATTERNMAN_autoClose = not PATTERNMAN_autoClose;

  if (PATTERNMAN_autoClose) then
    print("Automatic closing is now enabled")
  else
    print("Automatic closing is now disabled")
  end
end

local function printItemList()
  ret = ""
  for key, _ in pairs(PATTERNMAN_itemList) do
    if (string.len(ret) == 0) then
      ret = key;
    else
      ret = ret .. ", " .. key;
    end
  end
  print("Shopping list: ", ret);
end

function SlashCmdList.PATTERNMAN(msg, editbox)
  if msg == nil or msg == '' then
    ShowHelp();
  else
    local command = msg:match("%S+")

    if (command == 'add' or command == 'remove') then
      itemLink = msg:match("|c.-|r")

      if itemLink == nil then
        print('Invalid item link!');
        return
      end

      itemName, _, _, _, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
    end

    if(command == 'help') then
      showHelp();
    elseif(command == 'add') then
      addToList(itemName);
      print('Added', itemName, 'to your shopping list.')
    elseif(command == 'remove') then
      removeFromList(itemName);
      print('Removed', itemName, 'from your shopping list.')
    elseif(command == 'clear') then
      PATTERNMAN_itemList = {}
    elseif(command == 'list') then
      printItemList();
    elseif(command == 'autoclose') then
      toggleAutoClose();
    else
      print("Please enter a valid command.")
    end
  end
end

local function merchantShowHandler()
  for i = 1, GetMerchantNumItems() do
    local name, _, _, _, _, _, _ = GetMerchantItemInfo(i);

    if (PATTERNMAN_itemList[name]) then
      BuyMerchantItem(i, 1)
    end
  end

  if (PATTERNMAN_autoClose) then
    CloseMerchant();
  end
end

frame:SetScript("OnEvent", merchantShowHandler);
