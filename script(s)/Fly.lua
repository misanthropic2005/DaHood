local in_lib = "https://raw.githubusercontent.com/misanthropic2005/DaHood/main/script(s)/InitilizationModule.lua"
local pm_lib = "https://raw.githubusercontent.com/misanthropic2005/DaHood/main/script(s)/PlayerModule.lua"
local kb_lib = "https://raw.githubusercontent.com/misanthropic2005/DaHood/main/library(s)/KeyLIB_Custom.lua"

if game:HttpGet(in_lib) then
   in_lib = loadstring(game:HttpGet(in_lib))()
else
   game:GetService("Players").LocalPlayer:Kick("Fly failed to init[alize]")
end

if game:HttpGet(pm_lib) then
   pm_lib = loadstring(game:HttpGet(pm_lib))()
else
   game:GetService("Players").LocalPlayer:Kick("Fly failed to init[alize]")
end

if game:HttpGet(kb_lib) then
   kb_lib = loadstring(game:HttpGet(kb_lib))()
else
   game:GetService("Players").LocalPlayer:Kick("Fly failed to init[alize]")
end

local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local UpdateLowerTorso = function(Weld)
   
   pm_lib.Player().CharacterAdded:Connect(function(Character)
       Weld.Part1 = Character:WaitForChild("LowerTorso")
   end)

   if pm_lib.Character() then
      
      local Character = pm_lib.Character()
      local Torso = Character:WaitForChild("LowerTorso")

      if Character:FindFirstChild("LowerTorso") then
         Weld.Part1 = Character:FindFirstChild("LowerTorso")
      end
      
   end
end

local CreateGyroPart = function()
    
   local Gyro = Instance.new("Part", workspace)
   Gyro.Anchored = false
   Gyro.Name = "Gyro"
   Gyro.Name = "Part(1)"
   Gyro.Transparency = 1
   Gyro.CFrame = pm_lib.HumanoidRootPart().CFrame * CFrame.new(0,10,0)
   Gyro.CanCollide = false
   
   local GyroWeld = Instance.new("Weld", Gyro)
   GyroWeld.Part0 = Gyro
   UpdateLowerTorso(GyroWeld)
   
   return Gyro
end

local AddFly = function(Part)
   
   workspace.ChildRemoved:Connect(function(Child)
       if Child == Part then
           
          local NewGyro = CreateGyroPart(); 
          table.insert(Parts, NewGyro);
          AddFly(NewGyro)
       end
   end)
   
  Part.ChildRemoved:Connect(function(Child)
       if Child:IsA("Weld") then
         pm_lib.Player().CharacterAdded:Wait()
          
         local GyroWeld = Instance.new("Weld", Part)
         GyroWeld.Part0 = Part
          
         UpdateLowerTorso(GyroWeld)          
      end
  end)
    
  FLYING = false
  QEfly = true
  iyflyspeed = 10
  vehicleflyspeed = 1
   
	repeat wait() until Mouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = Part
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0
	local FLYING = false

	local function FLY()
    
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
		task.spawn(function()
			repeat wait()
				
				if pm_lib.Humanoid() ~= nil and pm_lib.Humanoid() ~= false then pm_lib.Humanoid().PlatformStand = true end

				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end

			if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			
      CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()

			if pm_lib.Humanoid() ~= nil and pm_lib.Humanoid() ~= false then
			   pm_lib.Humanoid().PlatformStand = false
			end
		end)
	end
   
	flyKeyDown = Mouse.KeyDown:Connect(function(KEY)
		
        if KEY:lower() == 'w' then
			CONTROL.F = (iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(iyflyspeed)*2
		end

		pcall(function() workspace.CuerrentCamera.CameraType = Enum.CameraType.Track end)
	end)

	flyKeyUp = Mouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)

    kb_lib.ReturnBegan():Connect(function(I, G)
        if I.KeyCode == in_lib.GetValue(_G.MetaWareSettings, 1, "FlyBind") and in_lib.GetValue(_G.MetaWareSettings, 0, "FlyToggled", "Combat") then
           if FLYING then FLYING = false return end
           if not FLYING then FLYING = true FLY() return end
        end
    end)
    
    task.spawn(function()
        repeat wait() until not in_lib.GetValue(_G.MetaWareSettings, 0, "FlyToggled", "Combat")
        FLYING = false
    end)

    if in_lib.GetValue(_G.MetaWareSettings, 0, "FlyToggled", "Combat") then FLY() end
end

local Part = CreateGyroPart(); AddFly(Part); return true
