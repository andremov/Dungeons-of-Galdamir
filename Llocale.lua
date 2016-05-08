	-----------------------------------------------------------------------------------------
--
-- Locale.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)

function Load()
	curLang="EN"
	posLangs={"EN","ES"}
	locales={}
	
	locales["ES"]={
		-- Menu (2)
		"Jugar","Opciones",
		-- Options (6)
		"Volumen de Musica","Volumen de Efectos","Posiciones de UI","Puntajes","Sets de Baldosas","Volver",
		-- UI Positions - Names (8)
		"Contador de Oro","Vida","Mana","Energia","Puntos sin usar","Barra de Experiencia","Mision Actual",
		"Boton de Pausa",
		-- UI Positions - Menu (7)
		"Siempre Visible?", "No", "Si", "Anterior", "Reajustar", "Siguiente", "Chasquear?",
		-- Tilesets (5)
		"Predeterminado","Cuaderno", "Simple", "Secreto", "Set Actual:",
		-- Play (1)
		"Juegos Guardados",
		-- Keyboard (3)
		"Nombre de Personaje","Retroceso","Continuar",
	}
	
	locales["EN"]={
		-- Menu (2)
		"Play","Options",
		-- Options (6)
		"Music Volume","Sound Volume","UI Positions","High Scores","Tilesets","Back",
		-- UI Positions - Names (8)
		"Gold Counter","Health Display","Mana Display","Energy Display","Stat Points Notice",
		"Experience Bar","Quest Log","Pause Button",
		-- UI Positions - Menu (7)
		"Always Visible?", "No", "Yes", "Previous", "Reset", "Next", "Snapping?",
		-- Tilesets (5)
		"Default","Notebook", "Simple", "Secret", "Current Tileset:",
		-- Play (1)
		"Save Game",
		-- Keyboard (3)
		"Character Name","Backspace","Continue",
	}
end

function giveText(data)
	local extract=tonumber( string.sub(data,4,6) )
	return (locales[curLang][extract])
end

function giveLang()
	return curLang
end

function swapLang()
	local done=false
	for i=1,table.maxn(posLangs) do
		if done==false then
			if curLang~=posLangs[i] then
				done=true
				curLang=posLangs[i]
			end
		end
	end
end