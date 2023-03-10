-- author: Rynsky & Chinpi
-- desc:   Shiawase na Kazoku
-- script: lua
function topo()
end

Tela = {
 INICIO = "Inicio",
	JOGO = "Jogo"
}

Constantes = {
	SPRITE_GERGELIM = 340,
	SPRITE_PORTA = 352,
	ID_SFX_GERGELIM = 0,
	ID_SFX_PORTA = 1,
	SPRITE_ESQUELETINHO = 452,
	ESQUELETINHO = "ESQUELETINHO",
	CHINPI = "CHINPI"
}

larguraTela = 240
alturaTela = 138

function temColisaoComMapa(ponto)
    local blocoX = ponto.x / 8
	   local blocoY = ponto.y / 8
    local blocoId = mget(blocoX, blocoY)
	   --mget: pega o ID do bloco em dos pontos em questao.
				--poderia ser assim: 
	   --blocoId = mget(ponto.x / 8, ponto.y / 8)
		if blocoId >= 160 then
		  return true
		end
		  return false
		 
end

function tentaMoverPara(personagem, delta)
			--...tenta mover para: "pontos". E nao cima/baixo.
			local novaPosicao = {
    x = personagem.x + delta.deltaX, 
				y = personagem.y + delta.deltaY			
			
		}
			
			if verificaColisaoComObjetos(personagem, novaPosicao) then
			 return
			end
			
			local superiorEsquerdo = {
      x = personagem.x - 8 + delta.deltaX,
      y = personagem.y - 8 + delta.deltaY
   }
   local superiorDireito = {
      x = personagem.x + 7 + delta.deltaX,
      y = personagem.y - 8 + delta.deltaY
   }
   local inferiorDireito = {
      x = personagem.x + 7 + delta.deltaX,
      y = personagem.y + 7 + delta.deltaY	
      
   }
   local inferiorEsquerdo = {
      x = personagem.x - 8 + delta.deltaX,
      y = personagem.y + 7 + delta.deltaY
   }

   if not (temColisaoComMapa(inferiorDireito) or
      temColisaoComMapa(inferiorEsquerdo) or
      temColisaoComMapa(superiorDireito) or    
      temColisaoComMapa(superiorEsquerdo)) then
   
						--movimento
						personagem.y = personagem.y + delta.deltaY * personagem.speed
      personagem.x = personagem.x + delta.deltaX * personagem.speed
						
						--animacao
						personagem.quadroAnimacao = personagem.quadroAnimacao + 0.1
						if personagem.quadroAnimacao >= 3 then
						  personagem.quadroAnimacao = 1
						end
			end
end

function atualizaInimigo(esqueletinho)

  local delta = {
			deltaY = 0,
			deltaX = 0		
		}
		
  if chinpi.y > esqueletinho.y then
				delta.deltaY = 1
				esqueletinho.direcao = 2
		elseif chinpi.y < esqueletinho.y then
		 	delta.deltaY = -1
				esqueletinho.direcao = 1
		end
		tentaMoverPara(esqueletinho, delta)
		delta = {
			deltaY = 0,
			deltaX = 0		
		}
		if chinpi.x > esqueletinho.x then
		 	delta.deltaX = 1
				esqueletinho.direcao = 4
		elseif chinpi.x < esqueletinho.x then
		 	delta.deltaX = -1
				esqueletinho.direcao = 3
		end
	 tentaMoverPara(esqueletinho, delta)
		
		local AnimacaoEsqueletinho = {
		 {448, 450},
			{452, 454},
			{456, 458},
			{460, 462}
		}
  
		local quadros = AnimacaoEsqueletinho[esqueletinho.direcao]
		local quadro = math.floor(esqueletinho.quadroAnimacao)
	 esqueletinho.sprite = quadros[quadro]

end

function atualizaOJogo()
  
		
	local	Direcao = {
	   {deltaX = 0, deltaY =  -1}, --cima btn0
				{deltaX = 0, deltaY = 1},  --baixo btn1
				{deltaX = -1, deltaY = 0}, --esquerda btn2
				{deltaX = 1, deltaY = 0},   --direita btn3
				{-1, -1}, --cima esquerda
				{-1, 1},  --baixo esquerda
				{1, -1},  --cima direita
				{1, 1}   --baixo direita
		}
		
		local AnimacoesChinpi = { 
       --quadros: linha, combinacao das animacoes;
							--quadro: um dos pares da animacao/sprite.
							{256, 258}, --cima
							{260, 262}, --baixo
							{264, 266}, --esquerda
					 	{268, 270}, --direita
			  		{288, 290}, --cima direita
							{292, 294}, --cima esquerda
							{296, 298}, --baixo direita
							{300, 302}  --baixo esquerda
    }
	
	for tecla = 0,3 do
			 if btn(tecla) then
				  local quadros = AnimacoesChinpi[tecla + 1]
						local quadro = math.floor(chinpi.quadroAnimacao)
						chinpi.spriteParado1 = quadros[quadro] --aqui muda o
																																													--sprite.
						tentaMoverPara(chinpi, Direcao[tecla + 1])
				end
		end
		
		verificaColisaoComObjetos(chinpi, {x = chinpi.x, y = chinpi.y})
		
			
			--pensar numa solucao para as diagonais D:
			--cima direita
			if btn(0) and btn(3) then 
			chinpi.spriteParado1 = AnimacoesChinpi[5][math.floor(chinpi.quadroAnimacao)]
			end
			
 		--cima esquerda	
			if btn(0) and btn(2) then 
		 chinpi.spriteParado1 = AnimacoesChinpi[6][math.floor(chinpi.quadroAnimacao)]
			end
			
	 	--baixo direita 
			if btn(1) and btn(3) then 
			chinpi.spriteParado1 = AnimacoesChinpi[7][math.floor(chinpi.quadroAnimacao)]
			end
			
	 	--baixo esquerda	
			if btn(1) and btn(2) then 
		 chinpi.spriteParado1 = AnimacoesChinpi[8][math.floor(chinpi.quadroAnimacao)]
			end
		
 		for indice, objeto in pairs(objetos) do
			  if objeto.tipo == Constantes.ESQUELETINHO then
					  atualizaInimigo(objeto)
					end
			end
  
end



function desenhaMapa()
  
 map(0, --posicao x no mapa
					0, --posicao y no mapa
					larguraTela,
					alturaTela,
					0, --em qual ponto colocar x
					0) --em qual ponto colocar y
					
end

function desenhaSprites()

			spr(rynsky.sprite, 
						rynsky.x - 8, 
						rynsky.y - 8,
						0, -- cor de fundo
						1, -- escala
						0, -- espelhar
						0, -- rotacionar
						2, -- blocos para direita
						2) -- blocos para baixo
  
			spr(chinpi.spriteParado1, 
	  	chinpi.x - 8, 
		 	chinpi.y - 8, 
				0, 
		 	1, 
				0, 
				0, 
				2, 
				2)
			
	

	
		 --	spr(kokoro.sprite, 
		 --   kokoro.x - 8, 
			--			kokoro.y - 8, 
			--			0, 
			--			1, 
			--			0, 
			--			0, 
			--			1, 
			--		1)



end

function desenhaObjetos()
  for indice,objeto in pairs(objetos) do
    spr(objeto.sprite,
				    objeto.x - 8,
								objeto.y - 8,
								objeto.corDeFundo,
								1,
								0,
								0,
								2,
								2)
		end
end

function desenhaOJogo()

  cls()
		desenhaMapa()
		desenhaSprites()
		desenhaObjetos() 

end

function fazAColisaoDoChinpiComOGergelim(indice)
		chinpi.chaves = chinpi.chaves + 1
  table.remove(objetos, indice)
		sfx(Constantes.ID_SFX_GERGELIM,
						36, -- 12 notas por oitava | 3rd oitava x 12 notas
						32, -- quantos pixels de som serao tocados ( 0 - 32 )
	     0,  -- canal de som
						8,  -- volume ( 0 - 15 )
						1  -- velocidade de reproducao
						)
		return false
end

function temColisao(objetoA, objetoB)
  local esquerdaDeB = objetoB.x - 8
		local direitaDeB = objetoB.x + 7
		local baixoDeB = objetoB.y + 7
		local cimaDeB = objetoB.y - 8
		
		local direitaDeA = objetoA.x + 7 
		local esquerdaDeA = objetoA.x - 8 
		local baixoDeA = objetoA.y + 7
		local cimaDeA = objetoA.y - 8
		
		if esquerdaDeB > direitaDeA or
		   direitaDeB < esquerdaDeA or
					baixoDeA < cimaDeB or
					cimaDeA > baixoDeB then
				return false
  end
		return true
end

function fazColisaoDoChinpiComAPorta(indice)
		 if chinpi.chaves > 0  then
				chinpi.chaves = chinpi.chaves - 1
				table.remove(objetos, indice)
				sfx(Constantes.ID_SFX_PORTA,
						36, -- 12 notas por oitava | 3rd oitava x 12 notas
						32, -- quantos pixels de som serao tocados ( 0 - 32 )
	     0,  -- canal de som
						8,  -- volume ( 0 - 15 )
						0  -- velocidade de reproducao
						)
				return false 
			end
		return true
end

function fazColisaoDoChinpiComOEsqueletinho(indice)
  inicializa()
  return true 
end

function verificaColisaoComObjetos(personagem, novaPosicao)

  		
		for indice, objeto in pairs(objetos) do
		  if temColisao(novaPosicao, objeto) then
				   local funcaoDeColisao = objeto.colisoes[personagem.tipo]
							return funcaoDeColisao(indice)
	  	end
	 end
  return false
end

function desenhaAIntro()
	cls()
		spr(390,
		    100,
		    50,
						0,
						1,
						0,
						0,
						6,
						2)
		print("Dango Daikazoku~", 78, 122, 15)
end

function atualizaAIntro()
  
		if btn(4) then
		  sfx(2,
				    72,
								32,
								0,
								8,
								0
				)  
				
			 tela = Tela.JOGO
		end
		
end

function TIC()
  
		if tela == Tela.INICIO then
		  atualizaAIntro()
		  desenhaAIntro()
	 end
		
		if tela == Tela.JOGO then
		  atualizaOJogo()
		  desenhaOJogo()
		end
		
end

function fazColisaoDoEsqueletinhoComAPorta(indice)
 return true
end

function fazColisaoDoChinpiComORynsky(indice)
  spr(324,
		    100,
		    50,
						0,
						1,
						0,
						0,
						1,
						1)
  return true 
end				

function criaPorta(coluna, linha)
		local porta = {
				sprite = Constantes.SPRITE_PORTA,
				x = coluna * 8 + 8,
				y = linha * 8 + 8,
				corDeFundo = 0,
				colisoes = {
				 ESQUELETINHO = fazColisaoDoEsqueletinhoComAPorta,
				 CHINPI =	fazColisaoDoChinpiComAPorta
				} 
		}
		return porta
end

function deixaPassar(indice)
  return false
end 	

function criaGergelim(coluna, linha)
  local gergelim = {
		  sprite = Constantes.SPRITE_GERGELIM,
				x = coluna * 8 + 8,
				y = linha * 8 + 8,
				corDeFundo = 0,
				colisoes = {
				 ESQUELETINHO = deixaPassar,
				 CHINPI = fazAColisaoDoChinpiComOGergelim
					}
		}
		return gergelim
end

function criaEsqueletinho(coluna, linha)
  local esqueletinho = {
		tipo = Constantes.ESQUELETINHO,
		sprite = Constantes.SPRITE_ESQUELETINHO,
		x = coluna * 8 + 8,
		y = linha * 8 + 8,
		corDeFundo = 0,
		colisoes = {
		  ESQUELETINHO = deixaPassar,
				CHINPI = fazColisaoDoChinpiComOEsqueletinho,
				},
		quadroAnimacao = 1,
		speed = 1
		}
		return esqueletinho
end

function inicializa()
  
		objetos = {}
		
		local gergelim = criaGergelim(10, 8)
  table.insert(objetos, gergelim)
		
		local porta = criaPorta(17, 7)
		table.insert(objetos, porta)
  
		local esqueletinho = criaEsqueletinho(26, 13)
		table.insert(objetos, esqueletinho)

  chinpi = {
  spriteParado1 = 327,
 	quadroAnimacao = 1,
 	speed = 2,
 	x = 122,
 	y = 60,
 	chaves = 0,
		tipo = Constantes.CHINPI
  }

  rynsky = {
  sprite = 320,
 	x = 170,
 	y = 115
  }

  --kokoro = {
  --sprite = 324,
 	--x = 116,
 	--y = 56
  --} 

  tela = Tela.INICIO
		
end
