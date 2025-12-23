local phase2Yells = {
    "Pray for mercy!",
    "Scream your dying breath!",
    "The end is upon you!"
}

local buffsToRemove = {
    {
        name = "Flask of the Titans",
        texture = "Interface\\Icons\\INV_Potion_62",
        spellId = 17626
    },
    {
        name = "Medivh's Merlot",
        texture = "Interface\\Icons\\INV_Drink_04",
        spellId = 57106
    },
    {
        name = "Elixir of Fortitude",
        texture = "Interface\\Icons\\INV_Potion_44",
        spellId = 3593
    }
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
frame:RegisterEvent("PLAYER_LOGIN")

local function CheckBuff(buffName, buffTexture, buffSpellId)
    for _, buff in ipairs(buffsToRemove) do
        if buffSpellId and buff.spellId == buffSpellId then
            return true
        end
        if buffTexture and string.find(buffTexture:lower(), buff.texture:lower()) then
            return true
        end
        if buffName and string.find(buffName:lower(), buff.name:lower()) then
            return true
        end
    end
    return false
end

local function RemoveBuffs()
    if UnitName("player") ~= "Cirah" then
        return
    end
    
    print("KTBuff: Removing specified buffs...")
    local count = 0
    
    for i = 1, 40 do
        local buffName, _, buffTexture, _, _, _, _, _, _, buffSpellId = UnitBuff("player", i)
        if buffName and CheckBuff(buffName, buffTexture, buffSpellId) then
            CancelUnitBuff("player", i)
            print(string.format("KTBuff: Removed '%s'", buffName))
            count = count + 1
        end
    end
    
    if count > 0 then
        print(string.format("KTBuff: Removed %d buff(s)", count))
    else
        print("KTBuff: No specified buffs found")
    end
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        print("KTBuff loaded. Waiting for phase transition...")
        
    elseif event == "CHAT_MSG_MONSTER_YELL" then
        local msg = ...
        msg = string.lower(msg)
        
        for _, yell in ipairs(phase2Yells) do
            if string.find(msg, string.lower(yell)) then
                print("KTBuff: Phase 2 detected - removing buffs")
                RemoveBuffs()
                break
            end
        end
    end
end)