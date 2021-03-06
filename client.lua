-- this script puts certain large weapons on a player's chest 
-- Add weapons to the 'compatable_weapon_hashes' table below to make them show up on a player's back (can use GetHachestshKey(...) if you don't know the hash) --
local SETTINGS = {
    back_bone = 	11816, 
    x = -0.35, 
    y = 0.18,
    z = -0.05,
    x_rotation = 360.0,
    y_rotation = -40.0,
    z_rotation = 1.0,
    compatable_weapon_hashes = {
      
      -- assault rifles:
       ["w_ar_carbinerifle"] = GetHashKey("WEAPON_CARBINERIFLE"),
      ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_Mk2"),
      ["w_ar_assaultrifle"] = -1074790547,
      ["w_ar_specialcarbine"] = -1063057011,
      ["w_ar_bullpuprifle"] = 2132975508,
      ["w_ar_advancedrifle"] = -1357824103,
      -- sub machine guns:
      
      ["w_sb_assaultsmg"] = -270015777,
      ["w_sb_smg"] = 736523883,
      ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMGMk2"),
      ["w_sb_gusenberg"] = 1627465347,
      -- sniper rifles:
      ["w_sr_sniperrifle"] = 100416529,
      -- shotguns:
      ["w_sg_assaultshotgun"] = -494615257,
      ["w_sg_bullpupshotgun"] = -1654528753,
      ["w_sg_pumpshotgun"] = 487013001,
      ["w_ar_musket"] = -1466123874,
      ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
   
    }
}


local SETTINGS2 = {

    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {
      
      -- assault rifles:
       ["w_ar_carbinerifle"] = GetHashKey("WEAPON_CARBINERIFLE"),
      ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_Mk2"),
      ["w_ar_assaultrifle"] = -1074790547,
      ["w_ar_specialcarbine"] = -1063057011,
      ["w_ar_bullpuprifle"] = 2132975508,
      ["w_ar_advancedrifle"] = -1357824103,
      -- sub machine guns:
      
      ["w_sb_assaultsmg"] = -270015777,
      ["w_sb_smg"] = 736523883,
      ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMGMk2"),
      ["w_sb_gusenberg"] = 1627465347,
      -- sniper rifles:
      ["w_sr_sniperrifle"] = 100416529,
      -- shotguns:
      ["w_sg_assaultshotgun"] = -494615257,
      ["w_sg_bullpupshotgun"] = -1654528753,
      ["w_sg_pumpshotgun"] = 487013001,
      ["w_ar_musket"] = -1466123874,
      ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
   
    }
}

local attached_weapons = {}
arsling = false
RegisterCommand(Config.Connect, function(source, args, rawCommand)
	arsling = true
	
end, false)

RegisterCommand(Config.Release, function(source, args, rawCommand)
	arsling = false
	
end, false)

Citizen.CreateThread(function()
  while true do
      local me = GetPlayerPed(-1)
      ---------------------------------------
      -- attach if player has large weapon --
      ---------------------------------------
      for wep_name, wep_hash in pairs(SETTINGS2.compatable_weapon_hashes) do
      for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
          if HasPedGotWeapon(me, wep_hash, false) then
			if arsling and not attached_weapons[wep_name]then 
        if Config.positionchest then
				 AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation)
        elseif not Config.positionchest then
          AttachWeapon(wep_name, wep_hash, SETTINGS2.back_bone, SETTINGS2.x, SETTINGS2.y, SETTINGS2.z, SETTINGS2.x_rotation, SETTINGS2.y_rotation, SETTINGS2.z_rotation) 
              
             end
			 
          end
      end
    end


      --------------------------------------------
      -- remove from back if equipped / dropped --
      --------------------------------------------
      for name, attached_object in pairs(attached_weapons) do
          -- equipped? delete it from back:
          if arsling == false or GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
          end
		 
		  
      end
  Wait(0)
  end
end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

 
	AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end
	 