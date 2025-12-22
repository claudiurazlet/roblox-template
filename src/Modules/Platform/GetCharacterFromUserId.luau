local Players = game:GetService("Players")

return function(userId: number, spawnPosition: Vector3)
    local model = nil
    
    -- LOAD THE AVATAR'S DESCRIPTION (CLOTHERS, ACCESSRIES, PROPORTIONS, ETC.)
    local success, humanoidDescription = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(userId)
    end)
    
    if success and humanoidDescription then
        --  AUTOMATICALLY GENERATE THE COMPLETE MODEL (R15 OR R6 DEPENDING ON THE USER)
        model = Players:CreateHumanoidModelFromDescription(humanoidDescription)
        model.Name = "Char_" .. tostring(userId)
        
        -- MOVE THE MODEL TO THE DESIRED POSITION BEFORE PUTTING IT IN THE WORKSPACE
        -- PivotTo IS THE MOST MODERN AND SAFE METHOD TO MOVE MODELS
        model:PivotTo(CFrame.new(spawnPosition + Vector3.new(0, 3, 0))) 
        
        -- DEFINE THE PARENT SO THAT IT APPEARS IN THE GAME
        model.Parent = workspace
    else
        warn("Errore nel caricamento del personaggio per l'ID: " .. userId)
    end

    return model
end