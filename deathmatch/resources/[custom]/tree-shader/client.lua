local palmShadow = dxCreateTexture( "palm.png" )



local position ={ -- пальмы

}

local position2 ={ -- большое дерево 



}
-- function shadowTag()
 -- for k,v in ipairs(position) do 
 -- dxDrawMaterialLine3D(v[1],v[2],v[3], v[1]-1,v[2]+1,v[3], palmShadow, 1,tocolor(255, 255, 255, 255), v[1],v[2],v[3])
-- end
-- end
-- addEventHandler(" onClientRender ",getRootElement(),shadowTag)
local position3 ={

}

local redcircle = dxCreateTexture("palm.png")
size = 10

addEventHandler("onClientRender", root, function()
for k,v in ipairs(position) do 
    dxDrawMaterialLine3D(v[1]-size-9, v[2], v[3]-0.95, v[1]+size-9, v[2], v[3]-0.95, redcircle, size*2,tocolor(255, 255, 255, 255), v[1]-9, v[2], 1000)
	end
end)

local redcircle2 = dxCreateTexture("derevo.png")
size2 = 20

addEventHandler("onClientRender", root, function()
for k,v in ipairs(position2) do 
    dxDrawMaterialLine3D(v[1]-size2-2, v[2], v[3]-0.95, v[1]+size2-2, v[2], v[3]-0.95, redcircle2, size2*2,tocolor(255, 255, 255, 255), v[1]-2, v[2], 1000)
	end
end)

local redcircle3 = dxCreateTexture("derevo.png")
size3 = 10

addEventHandler("onClientRender", root, function()
for k,v in ipairs(position3) do 
    dxDrawMaterialLine3D(v[1]-size3-2, v[2], v[3]-0.95, v[1]+size3-2, v[2], v[3]-0.95, redcircle3, size3*2,tocolor(255, 255, 255, 255), v[1]-2, v[2], 1000)
	end
end)

--- Sitemiz : https://sparrow-mta.blogspot.com/

--- Facebook : https://facebook.com/sparrowgta/
--- İnstagram : https://instagram.com/sparrowmta/
--- YouTube : https://www.youtube.com/@TurkishSparroW/

--- Discord : https://discord.gg/DzgEcvy