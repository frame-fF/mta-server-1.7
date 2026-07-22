--[[
 ################################################
 # Console,Mapper,Decripter,Cracker #        
 # tgss.org #                  
 # Jogador deis dos velhos tempos v1.3.  # 
 # em momoria de tiago faça bom uso desta programação. #       
 # Não remova os créditos um dia pode ser você. #
 ################################################   
--]]

-------------------------------------------------

function SetarNivelDeBlur ()
    setPlayerBlurLevel ( source, 0 )
end
addEventHandler ( "onPlayerJoin", getRootElement(), SetarNivelDeBlur )

-------------------------------------------------

function QuandoIniciarScript ()
    setPlayerBlurLevel ( getRootElement(), 0 )
end
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), QuandoIniciarScript )

-------------------------------------------------

function QuandoReiniciarScript ()
	setTimer ( QuandoIniciarScript, 4000, 1 )
end
addEventHandler( "onResourceStart", getRootElement(), QuandoReiniciarScript )

-------------------------------------------------
