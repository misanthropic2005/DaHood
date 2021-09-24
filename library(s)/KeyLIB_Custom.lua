local KeyLIB = { }

function KeyLIB.ReturnBegan()
   return game:GetService("UserInputService").InputBegan
end

function KeyLIB.ReturnEnded()
   return game:GetService("UserInputService").InputEnded
end

function KeyLIB.GetKey(String)
   if Enum.KeyCode[String:upper()] ~= nil then
      return Enum.KeyCode[String:upper()]
   end
end

return KeyLIB
