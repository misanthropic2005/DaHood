local in_lib = "https://raw.githubusercontent.com/misanthropic2005/DaHood/main/script(s)/InitilizationModule.lua" --- init
local pm_lib = "https://raw.githubusercontent.com/misanthropic2005/DaHood/main/script(s)/PlayerModule.lua" -- player
local kb_lib = "https://raw.githubusercontent.com/misanthropic2005/DaHood/main/library(s)/KeyLIB_Custom.lua" -- bind

if game:HttpGet(in_lib) then
    in_lib = loadstring(game:HttpGet(in_lib))()
else
    game:GetService("Players").LocalPlayer:Kick("Noclip failed to init[alize]")
end

if game:HttpGet(pm_lib) then
    pm_lib = loadstring(game:HttpGet(pm_lib))()
else
    game:GetService("Players").LocalPlayer:Kick("Noclip failed to init[alize]")
end

if game:HttpGet(kb_lib) then
    kb_lib = loadstring(game:HttpGet(kb_lib))()
else
    game:GetService("Players").LocalPlayer:Kick("Noclip failed to init[alize]")
end

kb_lib.ReturnBegan:Connect(function(I, G)
    print(I.KeyCode, not in_lib.GetValue(_G.MetaWareSettings, 0, "NoclipToggled", "Combat"))
    if I.KeyCode == in_lib.GetValue(_G.MetaWareSettings, 1, "NoclipBind") and not G then
       in_lib.GetValue(_G.MetaWareSettings, 0, "NoclipToggled", "Combat") = not in_lib.GetValue(_G.MetaWareSettings, 0, "NoclipToggled", "Combat")
    end
end)

game:GetService("RunService").RenderStepped:Connect(function(...)
    if in_lib.GetValue(_G.MetaWareSettings, 0, "NoclipToggled", "Combat") then
       if pm_lib.Character() then       
          for z, x in pairs(pm_lib.Character():GetChildren()) do
             if x:IsA("BasePart") then x.CanCollide = false end
          end
       end
    end
end)
