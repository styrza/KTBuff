-- KTBuff Addon
print("KTBuff: Initializing...")

local frame = CreateFrame("Frame")

local buffList = {
    ["Flask of the Titans"] = true,
    ["Medivh's Merlot"] = true,
    ["Elixir of Fortitude"] = true
}

local phase2Yells = {
    "Pray for mercy!",
    "Scream your dying breath!",
    "The end is upon you!"
}

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_LOGIN" then
        print("KTBuff loaded. Waiting for phase transition...")
        
    elseif event == "CHAT_MSG_MONSTER_YELL" then
        if arg1 then
            local msg = string.lower(arg1)
            
            for _, yell in ipairs(phase2Yells) do
                if string.find(msg, string.lower(yell)) then
                    
                    if UnitName("player") == "Cirah" then
                        print("KTBuff: Phase 2 detected - removing buffs")
                        
                        local removed = 0
                        for i = 1, 40 do
                            local buffName = UnitBuff("player", i)
                            if buffName and buffList[buffName] then
                                CancelUnitBuff("player", i)
                                print("KTBuff: Removed " .. buffName)
                                removed = removed + 1
                            end
                        end
                        
                        if removed > 0 then
                            print("KTBuff: Removed " .. removed .. " buff(s)")
                        else
                            print("KTBuff: No buffs found to remove")
                        end
                    end
                    
                    break
                end
            end
        end
    end
end)

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("CHAT_MSG_MONSTER_YELL")

print("KTBuff: Setup complete")