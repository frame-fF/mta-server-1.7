texturegrun = {
	"monsterb92body256a", "monstera92body256a", "andromeda92wing","fcr90092body128",
	"hotknifebody128b", "hotknifebody128a", "rcbaron92texpage64", "rcgoblin92texpage128", "rcraider92texpage128", 
	"rctiger92body128","rhino92texpage256", "petrotr92interior128","artict1logos","rumpo92adverts256","dash92interior128",
	"coach92interior128","combinetexpage128","hotdog92body256",
	"raindance92body128", "cargobob92body256", "andromeda92body", "at400_92_256", "nevada92body256",
	"polmavbody128a" , "sparrow92body128" , "hunterbody8bit256a" , "seasparrow92floats64" , 
	"dodo92body8bit256" , "cropdustbody256", "beagle256", "hydrabody256", "rustler92body256",'moy',
	"shamalbody256", "skimmer92body128", "stunt256", "maverick92body128", "leviathnbody8bit256",'bodys','tyloxebaniyCompleteMap','tyloxebaniycompletemap','moy',
}

textureCube = dxCreateTexture ( "env_1.dat" )
textureMat = dxCreateTexture ( "env_1.dat" )
shaderBody = {}
shaderRef = {}
shaderGlass = {}
shaderRef1 = {}


data_change = 'reflect' -- дата для салона, которая будет сохранять тип покраски, обычный или матовый
data_vinil = 'vinil' -- дата, при которой будет накладываться винил, если он есть

link_vinil = ':k-vinils/images/filename.png'
-- это путь винила ':название ресурса винила/папка, если есть/название файла.png'

renderTarget = {}

function imageVehicleVinil(vehicle)
	renderTarget[vehicle] = dxCreateRenderTarget(2048, 2048, true)
	dxSetRenderTarget(renderTarget[vehicle])
	dxDrawImage(0, 0, 2048, 2048, dxCreateTexture(string.gsub(link_vinil,'filename',getElementData(vehicle, data_vinil))))
	dxSetRenderTarget()
	local texture = getTextureFromRenderTarget(renderTarget[vehicle])
	destroyElement(renderTarget[vehicle])
	return texture
end

function getTextureFromRenderTarget(renderTarget)
	return dxCreateTexture(dxGetTexturePixels(renderTarget))
end

tex = {}

function setupVehicleReflect(veh,refl)
	if not getElementData(veh, data_change) then setElementData(veh, data_change, 'metallic') end
	if not getElementData(veh, data_change) then return end
	if not refl then refl = getElementData(veh, data_change) end
	if not shaderGlass[veh] then shaderGlass[veh] = dxCreateShader ( "shader_frent.ttfc",1,100,true) end
	if not shaderBody[veh] then shaderBody[veh] = dxCreateShader ( "shader_frent.ttfc",1,100,true) end
	if not shaderRef[veh] then shaderRef[veh] = dxCreateShader ( "shader_frent.ttfc",1,100,true) end
	if not shaderRef1[veh] then shaderRef1[veh] = dxCreateShader ( "shader_frent.ttfc",1,100,true) end


	if refl == 'metallic' then
---------------------------	
	dxSetShaderValue ( shaderGlass[veh], "sReflectionTexture", textureCube )
		if getElementData(veh, 'vinil') then
			dxSetShaderValue(shaderGlass[veh], "tex_remap", imageVehicleVinil(veh))
			dxSetShaderValue(shaderGlass[veh], "setAlphaChanel", 1)
		else
			dxSetShaderValue(shaderGlass[veh], "setAlphaChanel", 0.19)
			tex[veh] = dxCreateTexture('remap.png')
			dxSetShaderValue(shaderGlass[veh], "tex_remap", tex[veh])
		end
---------------------------
dxSetShaderValue ( shaderBody[veh], "sReflectionTexture", textureCube )
		if getElementData(veh, 'vinil') then
			dxSetShaderValue(shaderBody[veh], "tex_remap", imageVehicleVinil(veh))
			dxSetShaderValue(shaderBody[veh], "setAlphaChanel", 1)
		else
			dxSetShaderValue(shaderBody[veh], "setAlphaChanel", 0.32)
			tex[veh] = dxCreateTexture('remap.png')
			dxSetShaderValue(shaderBody[veh], "tex_remap", tex[veh])
		end
	---------------------------
dxSetShaderValue ( shaderRef[veh], "sReflectionTexture", textureCube )
		if getElementData(veh, 'vinil') then
			dxSetShaderValue(shaderRef[veh], "tex_remap", imageVehicleVinil(veh))
			dxSetShaderValue(shaderRef[veh], "setAlphaChanel", 1)
		else
			dxSetShaderValue(shaderRef[veh], "setAlphaChanel", 0.3)
			tex[veh] = dxCreateTexture('remap.png')
			dxSetShaderValue(shaderRef[veh], "tex_remap", tex[veh])
		end
	dxSetShaderValue ( shaderRef1[veh], "sReflectionTexture", textureCube )
		if getElementData(veh, 'vinil') then
			dxSetShaderValue(shaderRef1[veh], "tex_remap", imageVehicleVinil(veh))
			dxSetShaderValue(shaderRef1[veh], "setAlphaChanel", 1)
		else
			dxSetShaderValue(shaderRef1[veh], "setAlphaChanel", 0.15)
			tex[veh] = dxCreateTexture('remap.png')
			dxSetShaderValue(shaderRef1[veh], "tex_remap", tex[veh])
		end
---------------------------
		engineApplyShaderToWorldTexture ( shaderRef[veh], "*ara*", veh)
		engineApplyShaderToWorldTexture ( shaderRef[veh], "*lasti*", veh)
		engineApplyShaderToWorldTexture ( shaderRef[veh], "*hee*", veh)
		engineApplyShaderToWorldTexture ( shaderRef[veh], "*hrom*", veh)
		engineApplyShaderToWorldTexture ( shaderGlass[veh], "*teklo*", veh)
		engineApplyShaderToWorldTexture ( shaderRef1[veh], "*arbo*", veh)
                engineApplyShaderToWorldTexture ( shaderBody[veh], "*emap*", veh)
		for _,addList in ipairs(texturegrun) do
		  	engineApplyShaderToWorldTexture (shaderGlass[veh], addList, veh)
	    end
	elseif refl == 'mat' then
----------------------------
dxSetShaderValue ( shaderGlass[veh], "sReflectionTexture", textureCube )
		if getElementData(veh, 'vinil') then
			dxSetShaderValue(shaderGlass[veh], "tex_remap", imageVehicleVinil(veh))
			dxSetShaderValue(shaderGlass[veh], "setAlphaChanel", 1)
		else
			dxSetShaderValue(shaderGlass[veh], "setAlphaChanel", 0.1)
			tex[veh] = dxCreateTexture('remap.png')
			dxSetShaderValue(shaderGlass[veh], "tex_remap", tex[veh])
		end
---------------------------
dxSetShaderValue ( shaderDisk[veh], "sReflectionTexture", textureCube )
		if getElementData(veh, 'vinil') then
			dxSetShaderValue(shaderDisk[veh], "tex_remap", imageVehicleVinil(veh))
			dxSetShaderValue(shaderDisk[veh], "setAlphaChanel", 1)
		else
			dxSetShaderValue(shaderDisk[veh], "setAlphaChanel", 0.3)
			tex[veh] = dxCreateTexture('remap.png')
			dxSetShaderValue(shaderDisk[veh], "tex_remap", tex[veh])
		end
--------------------------
		for _,addList in ipairs(texturegrun) do
		  	engineApplyShaderToWorldTexture (shaderMat[veh], addList, veh)
	    end
	end
end

function handleRestore( didClearRenderTargets )
    for i,v in pairs(getElementsByType("vehicle")) do
		setupVehicleReflect(v)
	end
end
addEventHandler("onClientRestore",root,handleRestore)

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
	    for i,v in pairs(getElementsByType('vehicle')) do
	    	setupVehicleReflect(v)
		end
	end
)

function onDataChange(data)
	if getElementType(source) ~= 'vehicle' then return end
	if data == data_change or data == 'vinil' then
		setupVehicleReflect(source, getElementData(source, data_change))
	end
end
addEventHandler('onClientElementDataChange', getRootElement(), onDataChange)

addEventHandler("onClientElementStreamIn", root, function()
	if not isElement(source) then return end
	if getElementType(source) ~= "vehicle" then
		return
	end
	setupVehicleReflect(source,getElementData(source, data_change) or 'metallic')
end)


-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy