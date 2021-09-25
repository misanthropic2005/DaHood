--[[ UNIT 01 ]]--

local Init = { }

function Init.Execute(Script)
   loadstring(game:HttpGet("https://raw.githubusercontent.com/misanthropic2005/DaHood/main/script(s)/" .. Script .. ".lua"))()
end

function Init.GetValue(Table, Type, String, Alt)
   if Type == 1 or Type > 1 then
      
      if Table["KeyBinds"] ~= nil then
         
         local Keys = Table["KeyBinds"]
         
         if Keys[String] ~= nil then
            return Enum.KeyCode[Keys[String]]
         else
            return false
         end
      else
         return false
      end
   else
      if Type == 0 then
         if Table["Booleans"] ~= nil then
            
            local Bools = Table["Booleans"]
            
            if Bools[Alt] ~= nil then
               
               local AltTable = Bools[Alt]
               
               if AltTable[String] ~= nil then
                  return AltTable[String]
               else
                  return false
               end
            else
               return false
            end
         else
            return false
         end
      else
         return false
      end
   else
      return false
   end
end
