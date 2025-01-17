--[[
Perform linear interpolation between a and b by t
]]
return function(a: number, b: number, t: number): number
	return a + (b - a) * t
end