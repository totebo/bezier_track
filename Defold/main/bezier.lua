-- Nabbed and converted from:
-- https://github.com/nshafer/Bezier

local M = {}

local AUTO_STEP_SCALE = 0.1

function point_distance(p1, p2)
	local dx = p2.x - p1.x
	local dy = p2.y - p1.y
	return math.sqrt(dx*dx + dy*dy)
end

-- Estimate number of steps based on the distance between each point/control
-- Inspired by http://antigrain.com/research/adaptive_bezier/
local function estimate_steps(p1, p2, p3, p4)
	local distance = 0
	if p1 and p2 then
		distance = distance + point_distance(p1, p2)
	end
	if p2 and p3 then
		distance = distance + point_distance(p2, p3)
	end
	if p3 and p4 then
		distance = distance + point_distance(p3, p4)
	end

	return math.max(1, math.floor(distance * AUTO_STEP_SCALE))
end

local function bezier3(p1,p2,p3,mu)
	
	local mum1,mum12,mu2
	local p = vmath.vector3()
	mu2 = mu * mu
	mum1 = 1 - mu
	mum12 = mum1 * mum1
	p.x = p1.x * mum12 + 2 * p2.x * mum1 * mu + p3.x * mu2
	p.y = p1.y * mum12 + 2 * p2.y * mum1 * mu + p3.y * mu2

	return p
	
end

function bezier4(p1,p2,p3,p4,mu)

	--print("bezier4()", p1, p2, p3, p4, mu)
	
	local mum1,mum13,mu3;
	local p = vmath.vector3()

	mum1 = 1 - mu
	mum13 = mum1 * mum1 * mum1
	mu3 = mu * mu * mu

	p.x = mum13*p1.x + 3*mu*mum1*mum1*p2.x + 3*mu*mu*mum1*p3.x + mu3*p4.x
	p.y = mum13*p1.y + 3*mu*mum1*mum1*p2.y + 3*mu*mu*mum1*p3.y + mu3*p4.y

	return p
	
end

function M.create_quadratic_curve(p1, p2, p3, steps)
	
	local points = {}

	local steps = steps or estimate_steps(p1, p2, p3)
	for i = 0, steps do
		table.insert(points, bezier3(p1, p2, p3, i/steps))
	end
	
	return points
	
end

function M.create_cubic_curve(p1, p2, p3, p4, steps)

	--print("create_cubic_curve()", p1, p2, p3, p4, steps)

	local points = {}

	local steps = steps or estimate_steps(p1, p2, p3, p4)
	for i = 0, steps do
		table.insert(points, bezier4(p1, p2, p3, p4, i/steps))
	end

	return points
	
end

return M

