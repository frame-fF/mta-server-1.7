function ReplaceTexture()
local txd = engineLoadTXD ('gta_tree_boak.txd')
engineImportTXD (txd, 615)
engineImportTXD (txd, 705)
engineImportTXD (txd, 706)
engineImportTXD (txd, 700)
local dff = engineLoadDFF ('veg_tree3.dff',615)
engineReplaceModel (dff, 615)

local dff = engineLoadDFF ('sm_veg_tree7vbig.dff',705)
engineReplaceModel (dff, 705) 



local dff = engineLoadDFF ('sm_bushvbig.dff',706)
engineReplaceModel (dff, 706) 

local col = engineLoadCOL ('01.col')
engineReplaceCOL (col, 706)

local txd = engineLoadTXD ('gta_proc_bush.txd')
engineImportTXD (txd, 762)
local dff = engineLoadDFF ('new_bushtest.dff',762)
engineReplaceModel (dff, 762) 

local dff = engineLoadDFF ('sm_veg_tree6.dff',700)
engineReplaceModel (dff, 700) 

local col = engineLoadCOL ('15.col')
engineReplaceCOL (col, 616)
local txd = engineLoadTXD ('15.txd')
engineImportTXD (txd, 616)
local dff = engineLoadDFF ('15.dff',616)
engineReplaceModel (dff, 616) 

local col = engineLoadCOL ('39.col')
engineReplaceCOL (col, 3509)
local txd = engineLoadTXD ('39.txd')
engineImportTXD (txd, 3509)
local dff = engineLoadDFF ('39.dff',3509)
engineReplaceModel (dff, 3509) 
engineSetModelLODDistance(3509,300)
engineSetModelLODDistance(615,300)
engineSetModelLODDistance(705,300)
engineSetModelLODDistance(706,300)
engineSetModelLODDistance(700,300)
engineSetModelLODDistance(762,300)

engineSetModelLODDistance(17550,300)
engineSetModelLODDistance(1463,300)
engineSetModelLODDistance(3403,300)
end
addEventHandler( 'onClientResourceStart', getResourceRootElement(getThisResource()), ReplaceTexture)


--- Sitemiz : https://sparrow-mta.blogspot.com/

--- Facebook : https://facebook.com/sparrowgta/
--- İnstagram : https://instagram.com/sparrowmta/
--- YouTube : https://www.youtube.com/@TurkishSparroW/

--- Discord : https://discord.gg/DzgEcvy