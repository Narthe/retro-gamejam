angle = 0
cptMissile = 0
score = 0
spawnGrenade = 5
tir = false
niveauDifficulte = 0

function love.load()
	 -- you will still get a source handle if you need it
     -- stream and loop background music
	--love.graphics.setBackgroundColor(255,255,255)
	--tank position, and speed move
	corpsTankSprite = love.graphics.newImage("images/corpsTank.png")
	canonTankSprite = love.graphics.newImage("images/canonTank.png")
	missileSprite = love.graphics.newImage("images/missile.png")

	missiles = {}
	corpsTank = {}
	canonTank = {}

	canonTank.x = 390
	canonTank.y = 455
	canonTank.speed = 200

	corpsTank.x = 325    
	corpsTank.y = 450
	corpsTank.speed = 200
	init_son()
	--temps écoulé entre deux frames
	dt = love.timer.getDelta()
end

function init_son()
	Sounds = {}
	Sounds[1] = love.audio.newSource("sons/Chenilles1seconde.wav", "static")
	Sounds[2] = love.audio.newSource("sons/tircanon1sec.wav", "static")
	Sounds[3] = love.audio.newSource("sons/thememusical4sec.wav", "static")
end


function createMissile(index, angle, missilex, missiley)
	missile.sprite = missileSprite
	missile.width = missileSprite:getWidth()
	missile.height = missileSprite:getHeight()
	missile.speed = 50;
	missile.angle = angle
	missile.rotation = math.rad(missile.angle)
	missile.x = missilex 
	missile.y = missiley
	missile.index = index
	table.insert(missiles, missile)
end

local compteurMusique = 4
function love.update(dt)
	if compteurMusique > 4 then
		love.audio.rewind(Sounds[3])
		love.audio.play(Sounds[3])
		compteurMusique = 0
	end
	compteurMusique = compteurMusique + dt

	updateTank(dt)
	updateMissile(dt)
	updateBonus(dt)
	updateDifficulte(dt)
end

function updateDifficulte(dt)
	if score%1000 == 0 and niveauDifficulte < 4 then
		niveauDifficulte = niveauDifficulte + 1
		spawnGrenade = spawnGrenade / 1.5
	end
end

function updateBonus( dt )
	for i,value in ipairs(bonus) do
		if (value.y + 56) < windowHeight then
			value.y = value.y + value.speed

		else
			bonusDisparait(10)
			break				
		end
	end
end

function bonusDisparait(temps)
	for i,value in ipairs(bonus)
		if temps <= 0 then
			table.remove(bonusTab, i)
			else if CheckCollision(corpsTank.x, corpsTank.y, corpsTankSprite:getWidth(), corpsTankSprite:getHeight(), bonus.x, bonus.y)
			end
		end 
	bonusTab[i].temps = temps - 1
end

function updateTank(dt)
	--Mouvement du corps et du canon du tank sur l'axe des x
	if love.keyboard.isDown("right") and corpsTank.x < love.graphics.getWidth()-130 then
		corpsTank.x = corpsTank.x + (corpsTank.speed * dt)
		canonTank.x = canonTank.x + (canonTank.speed * dt)
		else if love.keyboard.isDown("left") and corpsTank.x > 0 then
			corpsTank.x = corpsTank.x - (corpsTank.speed * dt)
			canonTank.x = canonTank.x - (canonTank.speed * dt)
		end
	end

	--Récupère la position de la souris
	local xmouse = love.mouse.getX()
    local ymouse = love.mouse.getY()

    --Récupère coordonnées du point de Rotation de l'image, à savoir la base du canon
    local xcentre = (canonTank.x + (canonTankSprite:getWidth()/2))
    local ycentre = (canonTank.y + (canonTankSprite:getHeight()/2))

	angle = findRotation(xmouse, ymouse, xcentre, ycentre)
	if angle > 60 and angle < 180 then
		angle = 60
		else if angle > 180 and angle < 300 then
			angle = 300
		end
	end 
end

function updateMissile(dt)
	for i,value in ipairs(missiles) do
		--Si le missile se trouve tjrs dans l'écran et n'a pas de collision
		--if not impactMissileBombe(value, ) then
			if value.x < love.graphics.getWidth()+10 and value.x > -10 and value.y > -10 then
				value.x = value.x + math.cos(value.rotation-math.pi/2) + (value.speed*dt)
				value.y = value.y + math.sin(value.rotation-math.pi/2) + (value.speed*dt)
			else 
				table.remove(missiles, i)
				break
			end
		--end
	end
end
--[[
function impactMissileBombe(missile, grenade)
	if CheckCollision(missile.x, missile.y, missile.width, missile.height, grenade.x, grenade.y, grenade.width, grenade.height) then
		table.remove(missiles, missile.index)
		table.remove(grenades, grenade.index)
		score = score + 100
		return true
	end 
end
]]

function love.joystick.getAxis(joystick, axis)
	if axis == "z" then
		else if axis == "y"
		end
		else if axis == "x"
		end
	end
end 

function love.mousepressed(x, y, button)
   if button == 'l' then
		cptMissile = cptMissile + 1
		tir = true
		missile = {}
		missilex = canonTank.x 
		missiley = canonTank.y
		createMissile(cptMissile, angle, missilex, missiley)
		love.audio.rewind(Sounds[2])
		love.audio.play(Sounds[2])
   end
end

function love.keypressed(key)
    if key == 'right' or key == 'left' then
    	love.audio.rewind(Sounds[1])
    	love.audio.play(Sounds[1])
	end
end

function findRotation(x1,y1,x2,y2)
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then 
  	t = t + 360
  end
  return t
end

function findRotationWithMalus(x1,y1,x2,y2)
  local t = math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then 
  	t = t + 360
  end
  return t
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.draw()
	-- let's draw some ground
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("fill", 0, 465, 800, 150)
	
	--put white color
	love.graphics.setColor(255,255,255)
	if tir then
		drawMissile()
	end
	drawTank()
end

function drawMissile()
	for i,value in ipairs(missiles) do
		love.graphics.draw(missileSprite, value.x , value.y, value.rotation, 2, 2, missileSprite:getWidth()/2, missileSprite:getHeight()/2)
	end	
end

function drawTank()
	-- let's draw our canon of tank
	love.graphics.draw(canonTankSprite, canonTank.x, canonTank.y, math.rad(angle), 2, 2, canonTankSprite:getWidth()/2, canonTankSprite:getHeight())
	-- let's draw our body of tank
	love.graphics.draw(corpsTankSprite, corpsTank.x, corpsTank.y,0,2,2)
end
