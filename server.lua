local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_giftbox_check_menu")

local vRPgb3 = Proxy.getInterface("스크립트 이름", 'vRPgb3')

function comma_value(amount)
    local formatted = amount
    while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
      if (k == 0) then
        break
      end
    end
    return formatted
end

local function ch_giftbox_check(player,choice)
    local user_id = vRP.getUserId({player})
    local rb3 = vRPgb3.getgiftbox3({user_id})
    vRPclient.notify(player,{"".. GetPlayerName(player) .."(".. user_id ..")님의 50프로박스는 ~g~" .. comma_value(rb3) .."개 ~w~입니다."})
end

vRP.registerMenuBuilder({"main", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
        choices["[🎁]랜덤박스"] = {function(player,choice)
            vRP.buildMenu({"*랜덤박스", {player = player}, function(menu)
                menu.name = "*랜덤박스"
                menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
                menu.onclose = function(player) vRP.openMainMenu({player}) end
                if vRP.hasPermission({user_id, "user.paycheck"}) then
                    menu["50프로박스 개수 확인"] = {ch_giftbox_check,""}
                end
                vRP.openMenu({player,menu})
            end})
        end, ""}
		add(choices)
	end
end})