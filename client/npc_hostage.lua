ESX = exports["es_extended"]:getSharedObject()
Citizen.CreateThread(function()
	while true do
		local w = 1000

		if IsPedArmed(PlayerPedId(), 7) and (IsPedInMeleeCombat(PlayerPedId()) or IsPlayerFreeAiming(PlayerId())) then
			local founded, pedTarget = GetEntityPlayerIsFreeAimingAt(PlayerId())

			if not founded then
				founded, pedTarget = GetPlayerTargetEntity(PlayerId())
			end
			
			if founded and IsEntityAPed(pedTarget) and GetPedType(pedTarget) ~= 28 and not IsPedAPlayer(pedTarget) and not IsEntityPositionFrozen(pedTarget) and not GetPedConfigFlag(pedTarget, 79) and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(pedTarget)) < 10 and GetEntityHealth(pedTarget) > 0 then
				w = 5
				ESX.ShowHelpNotification("E Someter")

				if IsControlJustPressed(0, 38) then
					DoSurrender(pedTarget)
				end
			end
		end

		Citizen.Wait(w)
	end
end)

local surrendered = {}

function DoSurrender(entity)
	if not IsEntityPlayingAnim(entity, "random@arrests@busted", "idle_a", 3) and not surrendered[entity] then
		math.randomseed(GetGameTimer())

		if math.random(0, 100) < 20 then
			TriggerServerEvent("SendAlert:police", {
				coords = GetEntityCoords(PlayerPedId()),
				title = "Intento de secuestro",
				description = "Una persona armada está intentado secuestrar a alguien, ayuda por favor!!"
			})

			TaskReactAndFleePed(entity, PlayerPedId())

			ESX.ShowNotification("El civil ha ignorado tu amenaza")
			return
		end

		SetBlockingOfNonTemporaryEvents(entity, true)
		
		RequestAnimDict("random@arrests")
		RequestAnimDict("random@arrests@busted")

		while not HasAnimDictLoaded("random@arrests@busted") or not HasAnimDictLoaded("random@arrests") do
			Citizen.Wait(0)
		end
		
		TaskPlayAnim(entity, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
		Citizen.Wait(4000)
		TaskPlayAnim(entity, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
		Citizen.Wait(500)
		TaskPlayAnim(entity, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
		Citizen.Wait(1000)
		TaskPlayAnim(entity, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)

		SetEntityAsMissionEntity(entity, true, true)
		surrendered[entity] = true
	else
		NetworkRequestControlOfEntity(entity)
		local attempt = 0

		while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(entity)
			attempt = attempt + 1
			print(attempt)
		end

		surrendered[entity] = true
		local menu = openMenu({
			{
				isMenuHeader = true,
				header = "Opciones de rehén"
			},
			{
				header = "Liberar rehén",
				txt = "Deja al rehén libre",
				icon = "fas fa-user-check",
				params = {
					handler = function()
						surrendered[entity] = false
						if IsEntityPlayingAnim(entity, "random@arrests@busted", "idle_a", 3) then
							TaskPlayAnim(entity, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
							Citizen.Wait(3000)
							TaskPlayAnim(entity, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0)
							Citizen.Wait(2000)
						end
						ClearPedTasks(entity)
						TaskReactAndFleePed(entity, PlayerPedId())
					end
				}
			},
			{
				header = "Sigueme",
				txt = "Ordena al rehén que te siga",
				icon = "fas fa-person-walking",
				params = {
					handler = function()
						surrendered[entity] = "follow"
						TaskFollowToOffsetOfEntity(entity, PlayerPedId(), 0.5, -1.0, 0.0, 5.0, -1, 1.0, true)
						Citizen.CreateThread(function()
							while surrendered[entity] == "follow" do
								Citizen.Wait(1000)
								if IsPedInAnyVehicle(PlayerPedId()) and not IsPedInAnyVehicle(entity) then
									local veh = GetVehiclePedIsIn(PlayerPedId(), false)

									for i = 0, GetVehicleMaxNumberOfPassengers(veh) - 1 do
										print(i)
										if IsVehicleSeatFree(veh, i) then
											TaskEnterVehicle(entity, veh, 10000, i, 2.0, 1, 0)
											break
										end
									end
								elseif not IsPedInAnyVehicle(PlayerPedId()) and IsPedInAnyVehicle(entity) then
									TaskLeaveVehicle(entity, GetVehiclePedIsIn(entity, false), 0)
									TaskFollowToOffsetOfEntity(entity, PlayerPedId(), 0.5, -1.0, 0.0, 5.0, -1, 1.0, true)
								end
							end
						end)
					end
				}
			},
			{
				header = "Arrodillate",
				txt = "Ordena al rehén que se arrodille",
				icon = "fas fa-person-praying",
				params = {
					handler = function()
						surrendered[entity] = "kneel"
						TaskPlayAnim(entity, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
						Citizen.Wait(4000)
						TaskPlayAnim(entity, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
						Citizen.Wait(500)
						TaskPlayAnim(entity, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
						Citizen.Wait(1000)
						TaskPlayAnim(entity, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)				
					end
				}
			},
            {
                header = "Amenzar",
                txt = "Amenaza al rehén con un arma en el cuello",
                icon = "fas fa-user-shield",
                params = {
                    handler = function()
						if surrendered[entity] == "th" then
							return
						end

						surrendered[entity] = "th"
                        RequestAnimDict("anim@gangops@hostage@")
						while not HasAnimDictLoaded("anim@gangops@hostage@") do
							Citizen.Wait(0)
						end
						TaskPlayAnim(PlayerPedId(), "anim@gangops@hostage@", "perp_idle", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
						TaskPlayAnim(entity, "anim@gangops@hostage@", "victim_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
						AttachEntityToEntity(entity, PlayerPedId(), 0, -0.24, 0.11, 0.0, 0.5, 0.5, 0.0	, false, false, false, false, 2, false)

						exports["BigSea_utils"]:ControlsNotify({
							["enter"] = "Matar",
							["borrar"] = "Volver a arrodillar"
						})

						Citizen.CreateThread(function()
							while surrendered[entity] == "th" do
								Citizen.Wait(0)
								if IsControlJustPressed(0, 191) then
									ClearPedTasks(PlayerPedId())
									DetachEntity(entity, true, false)
									SetEntityHealth(entity, 0)
									surrendered[entity] = false
								end
								if IsControlJustPressed(0, 177) then
									ClearPedTasks(PlayerPedId())
									DetachEntity(entity, true, false)
									ClearPedTasks(entity)
									surrendered[entity] = "kneel"
									TaskPlayAnim(entity, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
									Citizen.Wait(4000)
									TaskPlayAnim(entity, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
									Citizen.Wait(500)
									TaskPlayAnim(entity, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
									Citizen.Wait(1000)
									TaskPlayAnim(entity, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)				
								end
							end
							exports["BigSea_utils"]:ControlsNotify()
						end)
					end
				}
			}
		})
	end
end