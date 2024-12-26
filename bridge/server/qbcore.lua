local Config = require("shared.sh_config")
local Locales = require("shared.sh_locales")

if Config.Framework ~= "qbcore" then return end

local QBCore = exports["qb-core"]:GetCoreObject()

local function PayFine(source)
	local Player = QBCore.Functions.GetPlayer(source)
	if not Player then return false end

	local amount = Config.PriceForDeath
	local moneyAvailable = Player.Functions.GetMoney("cash")
	local bankAvailable = Player.Functions.GetMoney("bank")

	if moneyAvailable >= amount then
		Player.Functions.RemoveMoney("cash", amount)
		ServerNotify(source, Locales.Notify.PaidFine:format(amount), "info")
		return true
	elseif bankAvailable >= amount then
		Player.Functions.RemoveMoney("bank", amount)
		ServerNotify(source, Locales.Notify.PaidFine:format(amount), "info")
		return true
	else
		ServerNotify(source, Locales.Notify.NoMoney, "error")
		return false
	end
end

lib.callback.register("cloud-deathscreen:server:PayFine", PayFine)
