-- KTBuff Addon for WoW 1.12
print("KTBuff: Initializing...")

local frame = CreateFrame("Frame")

local buffList = {
    [17626] = "Flask of the Titans",      
    [57106] = "Medivh's Merlot",          
    [3593] = "Elixir of Fortitude"        
}

local phase2Yells = {
    "Pray for mercy!",
    "Scream your dying breath!",
    "The end is upon you!"
}

frame:SetScript("OnEvent",  function ()
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
                        for i = 32, 0, -1 do
							local buffIndex = GetPlayerBuff(i, "HELPFUL")
							local spellId = GetPlayerBuffID(buffIndex)
                            if spellId and buffList[spellId] then
                                CancelPlayerBuff(buffIndex)
                                print("KTBuff: Removed " .. buffList[spellId])
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