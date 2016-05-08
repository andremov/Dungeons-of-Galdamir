-----------------------------------------------------------------------------------------
--
-- Splashes.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local lc=require("Llocale")
local Splash
local Splashtxt
local Tip
local Tiptxt
local Tiptxt2
local S={}
local T={}

S["EN"]={
	"Now with splashes!",
	"Random maps!",
	"Now released!",
	"Finally!",
	"Working Equipment!",
	"Working Inventory!",
	"Mob Racial Diversity!",
	"Item Drop Restrictions!",
	"Hardcore!",
	"Elixirs Of Doubtful Origins!",
	"Omnipotence-free!",
	"Mithril Armor!",
	"Major Bugfixing!",
	"Magical!",
	"Dodge!",
	"Charger required!",
	"Not Impossible!",
	"Improbable!",
	"Gold Ore!",
	"Mysterious Runes!",
	"Don't Panic!",
	"Item Shops!",
	"Floor taxes!",
	"Stable Releases!",
	"Balanced!",
	"Stat Boosts!",
	"Secret Items!",
	"29 Pages of Code!",
	"20MB of Pure Gold!",
	"Over 100 Items!",
	"Rings!",
	"Sorcery!",
	"Mana!",
	"Smooth!",
	"Content Heavy!",
	"Techniques!",
	"Energy!",
	"Limited Shops!",
	"Fatigue!",
	"Quests!",
	"Now with back story!",
	"You go, gurl!",
	"Plot twists!",
	"Fog of war!",
	"Optimization!",
	"Overhauls!",
	"Weight!",
	"Now with more death!",
	"Lazy-compatible combat!",
	"Rooms!",
	"Blocked portals!",
	"Ceci n'est pas un splash!",
	"Now with more contrast!",
	"Expandable maps!",
	"Now with less files!",
}

S["ES"]={
	"Ahora en Espanol!",
	"Mapas Aleatorios!",
	"Ahora Disponible al Publico!",
	"Finalmente!",
	"Equipamento Funcional!",
	"Inventorio Funcional!",
	"Diversidad Racial Enemiga!",
	"Restricciones de Tirar Items!",
	"Elixires de Dudosa Procedencia",
	"Libre de Omnipotencia!",
	"Armadura de Mitril!",
	"Correccion de Errores Mayores!",
	"Magico!",
	"Esquiva!",
	"Requiere Cargador!",
	"No Imposible!",
	"Improbable!",
	"Oro Mineral!",
	"Runas Misteriosas!",
	"No Entres en Panico!",
	"Tiendas de Items!",
	"Impuestos por Piso!",
	"Lanzamientos Estables!",
	"Balanceado!",
	"Impulsos de Estadisticas!",
	"Items Secretos!",
	"29 Paginas de Codigo!",
	"20MB de Oro Puro!",
	"Mas de 100 Items!",
	"Anillos!",
	"Hechiceria!",
	"Mana!",
	"Suave!",
	"Pesado en Contenido!",
	"Tecnicas!",
	"Energia!",
	"Tiendas Limitadas!",
	"Fatiga!",
	"Misiones!",
	"Ahora con Historia de Fondo!",
	"Vaya, mujer!",
	"Giros de la Trama!",
	"Niebla de Guerra!",
	"Optimizacion!",
	"Reacondicionamientos!",
	"Peso!",
	"Ahora con mas muerte!",
	"Combate perezoso-compatible!",
	"Cuartos!",
	"Portals bloqueados!",
	"Ceci n'est pas un splash!",
	"Ahora con mas contraste!",
	"Mapas expandibles!",
	"Ahora con menos archivos!",
}

T["EN"]={
	{"Spend your stat points wisely!"},
	{"Dexterity increases your chance of","hitting an enemy."},
	{"Stamina increases your health."},
	{"Magic increases the damage your","magical attacks cause."},
	{"Attack increases the damage your","melee attacks  cause."},
	{"Defense reduces the damage you","receive."},
	{"Intellect increases your mana and","energy."},
	{"A mob's looks and class depend on","its highest stat."},
	{"Attacking with low energy or low mana","can reduce the damage you cause."},
	{"These tips are random."},
	{"Water slows you down, allowing mobs","to follow you faster."},
	{"Keep health potions at hand."},
	{"Sorcery hits harder than regular","attacks, but require both resources."},
	{"In the pause menu you can see","your floor's features."},
	{"Something lurks in the fog."},
	{"Avoid moving near a mob spawner."},
	{"Never forget to take the key."},
	{"The game is currently loading."},
	{"These tips are sometimes helpful."},
	{"The map's looks can be changed","in the options menu."},
	{"You can check your highest scores","in the options menu."},
	{"You can change the volume in the","options menu."},
	{"The game auto-saves every so often."},
}

T["ES"]={
	{"Gasta tus puntos de estadisticas","sabiamente!"},
	{"La destreza incrementa la probabilidad","de pegarle a un enemigo."},
	{"El aguante incrementa tu vida."},
	{"La magia incrementa el dano que tus","ataques magicos causan."},
	{"El ataque incrementa el dano que tus","ataques fisicos causan."},
	{"La defensa reduce el dano que","recibes."},
	{"El intelecto incrementa tu mana y","energia."},
	{"El aspecto y clase de un enemigo depende","de su estadistica mas alta."},
	{"Atacar con baja energia o baja mana","puede reducir el dano que causas."},
	{"Estas tips son aleatorias."},
	{"El agua te retarda, permitiendo a","enemigos a moverse mas rapido."},
	{"Manten pociones de vida a la mano."},
	{"La hechiceria causa mas dano que ataques","regulares, pero requiere ambos recursos."},
	{"En el menu de pausa puedes ver las","caractericas de tu piso actual."},
	{"Algo acecha en la niebla."},
	{"Evita moverte cerca a un creador de","enemigos."},
	{"Nunca olvides agarrar la llave."},
	{"El juego esta cargando."},
	{"Estas tips a veces son utiles."},
	{"Puedes cambiar el aspecto del mapa","en el menu de opciones."},
	{"Puedes ver tus mas altos puntajes","en el menu de opciones."},
	{"Puedes cambiar el volumen en el menu","de opciones."},
	{"El juego auto-guarda de vez en cuando."},
}

function GetSplash()
	local lang=lc.giveLang()
	local chooser=math.random(1,table.maxn(S[lang]))
	Splash=S[lang][chooser]
	Splashtxt = display.newEmbossedText((Splash),0,0,"MoolBoran", 65 )
	Splashtxt.x=display.contentCenterX
	Splashtxt.y=310
	Splashtxt:setTextColor( 255, 255, 0)
	Splashtxt:toFront()
	return Splashtxt
end

function GetTip()
	local lang=lc.giveLang()
	local chooser=math.random(1,table.maxn(T[lang]))
	Tip=T[lang][chooser]
	local TGroup=display.newGroup()
	
	Tiptxt = display.newEmbossedText(("Tip: "..Tip[1]),0,0,"MoolBoran", 50 )
	Tiptxt.x=display.contentCenterX
	Tiptxt.y=100
	Tiptxt:setTextColor( 200, 200, 200)
	Tiptxt:toFront()
	TGroup:insert( Tiptxt )
	if (Tip[2]) then
		Tiptxt2 = display.newEmbossedText((Tip[2]),0,0,"MoolBoran", 50 )
		Tiptxt2.x=display.contentCenterX
		Tiptxt2.y=Tiptxt.y+60
		Tiptxt2:setTextColor( 200, 200, 200)
		Tiptxt2:toFront()
		TGroup:insert( Tiptxt2 )
	end
	return TGroup
end
