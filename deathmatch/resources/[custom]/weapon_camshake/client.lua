function shakeCamera(weapon)
	x,y,z = getPedBonePosition(getLocalPlayer(),26)
	if weapon == 22  then 
		createExplosion(x,y,z+10,12,false,0.1,false)
	elseif weapon == 24  then
		createExplosion(x,y,z+10,12,false,0.2,false)
	elseif weapon == 25  then
		createExplosion(x,y,z+10,12,false,0.4,false)
	elseif weapon == 26  then
		createExplosion(x,y,z+10,12,false,0.5,false)
	elseif weapon == 27  then
		createExplosion(x,y,z+10,12,false,0.3,false)
	elseif weapon == 28  then
		createExplosion(x,y,z+10,12,false,0.1,false)
	elseif weapon == 29  then
		createExplosion(x,y,z+10,12,false,0.1,false)
	elseif weapon == 30  then
		createExplosion(x,y,z+10,12,false,0.1,false)
	elseif weapon == 31  then
		createExplosion(x,y,z+10,12,false,0.1,false)
	elseif weapon == 22  then
		createExplosion(x,y,z+10,12,false,0.1,false)
	elseif weapon == 28  then
		createExplosion(x,y,z+10,12,false,0.1,false)
	elseif weapon == 32  then
		createExplosion(x,y,z+10,12,false,0.1,false)
	elseif weapon == 38  then
		createExplosion(x,y,z+10,12,false,0.4,false)
    elseif weapon == 33  then
		createExplosion(x,y,z+10,12,false,0.2,false)
	end
end
addEventHandler("onClientPlayerWeaponFire",getLocalPlayer(),shakeCamera)