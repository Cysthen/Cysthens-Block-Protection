local BP_PlayerName = nil;
local BP_default = 0;

function BP_OnLoad()
    this:RegisterEvent("PLAYER_AURAS_CHANGED");
    this:RegisterEvent("VARIABLES_LOADED");
DEFAULT_CHAT_FRAME:AddMessage("Blessing of Protection Blocker loaded.");
    SLASH_BP1 = "/BP";
    SlashCmdList["BP"] = function(msg)
		BP_SlashCommand(msg);
	end
end

function BP_Init()
    BP_PlayerName = UnitName("player").." of "..GetCVar("realmName");

    if (BP_CONFIG == nil) then
	BP_CONFIG = {};
    end

    if (BP_CONFIG[BP_PlayerName] == nill) then
	BP_CONFIG[BP_PlayerName] = BP_default;
    end
end

function BP_OnEvent()

  if (event == "PLAYER_AURAS_CHANGED") then 
    BP_Kill();
  elseif (event == "VARIABLES_LOADED") then
    BP_Init();
  end

end

function BP_SlashCommand(msg)
    local BP_Status = "Off";
    if(msg == "on") then
      BP_on();
    elseif (msg == "off") then
      BP_off()
    else
      if ( DEFAULT_CHAT_FRAME ) then
	if (BP_CONFIG[BP_PlayerName] == 1) then
		BP_Status = "On";
	end
        DEFAULT_CHAT_FRAME:AddMessage("BlockProtection status: "..BP_Status);
        DEFAULT_CHAT_FRAME:AddMessage("Use: /BP on|off");
      end
    end
end

function BP_on()
    BP_CONFIG[BP_PlayerName] = 1;
    if ( DEFAULT_CHAT_FRAME ) then
      DEFAULT_CHAT_FRAME:AddMessage("Blessing of Protection will be removed.");
    end
end

function BP_off()
    BP_CONFIG[BP_PlayerName] = 0;
    if ( DEFAULT_CHAT_FRAME ) then
      DEFAULT_CHAT_FRAME:AddMessage("Blessing of Protection will not be removed.");
    end
end

function BP_Kill() 
    if (BP_CONFIG[BP_PlayerName] == 0) then
	return false;
    end

    local i = 0;
    while not (GetPlayerBuff(i,"HELPFUL") == -1) do
	local buffIndex, untilCancelled = GetPlayerBuff(i,"HELPFUL")
	local texture = GetPlayerBuffTexture(buffIndex);
	if ((string.find(texture,"Spell_Holy_Restoration"))) then
	    CancelPlayerBuff(i);
		DEFAULT_CHAT_FRAME:AddMessage("Removed BoP.");		
	    return true;
	end
    i = i + 1;
    end
end