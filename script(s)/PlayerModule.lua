local PM = { }
local Players = game:GetService("Players")

local Player = function()
   return Players.LocalPlayer
end

local Character = function()
   if Player().Character then
      return Player().Character
   else
      return false
   end
end

local Humanoid = function()
   
   local Char = Character()
   
   if Char ~= false then
      if Char:FindFirstChild("Humanoid") then
         return Char.Humanoid
      else
         return false
      end
   else
      return false
   end
end

local HumanoidRootPart = function()
   
   local Char = Character()
   
   if Char ~= false then
      if Char:FindFirstChild("HumanoidRootPart") then
         return Char.HumanoidRootPart
      else
         return false
      end
   else
      return false
   end
end

PM.Player = function()
   return Player()
end

PM.Character = function()
   if Player().Character then
      return Character()
   else
      return false
   end
end

PM.Humanoid = function()
   
   local Char = Character()
   
   if Char ~= false then
      if Char:FindFirstChild("Humanoid") then
         return Humanoid()
      else
         return false
      end
   else
      return false
   end
end

PM.HumanoidRootPart = function()
   
   local Char = Character()
   
   if Char ~= false then
      if Char:FindFirstChild("HumanoidRootPart") then
         return HumanoidRootPart()
      else
         return false
      end
   else
      return false
   end
end

return PM
