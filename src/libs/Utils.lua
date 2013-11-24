-----------------------------------------------------------------------------------------
-- Project: Utils for uralys.libs
--
-- Date: May 8, 2013
--
-- Version: 1.5
--
-- File name	: Utils.lua
-- 
-- Author: Chris Dugne @ Uralys - www.uralys.com
--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function initGameData()

	GLOBALS.savedData = {
		requireTutorial 	= true,
		user 					= {}
	}

	utils.saveTable(GLOBALS.savedData, "savedData.json")
end


function initOptions()

	GLOBALS.options = {
		notificationBeforeDraw 	= true,
		notificationAfterDraw 	= true,
	}

	utils.saveTable(GLOBALS.options, "options.json")
end

-----------------------------------------------------------------------------------------

function onTouch(object, action)
	object:addEventListener	("touch", function(event)
		if(event.phase == "began") then
			action() 
		end
		return true
	end)
end

-----------------------------------------------------------------------------------------

function setGreen(text)
	text:setTextColor(27,92,100)
end

-----------------------------------------------------------------------------------------

function getDaysHoursMinSec(sec)
	local days = math.floor(sec/(24*60*60))
	local hours = math.floor((sec - days * 24*60*60)/(60*60))
	local min = math.floor((sec - days * 24*60*60 - hours*60*60)/60)
	local sec = math.floor((sec - days * 24*60*60 - hours*60*60 - min *60))
	
	return days, hours, min, sec
end

function getMinSec(seconds)
	local min = math.floor(seconds/60)
	local sec = seconds - min * 60

	if(sec < 10) then
		sec = "0" .. sec
	end

	return min, sec
end

function getMinSecMillis(millis)
	local min = math.floor(millis/60000)
	local sec = math.floor((millis - min * 60 * 1000)/1000)
	local ms = math.floor(millis - min * 60 * 1000 - sec * 1000)

	if(sec < 10) then
		sec = "0" .. sec
	end

	if(ms < 10) then
		ms = "00" .. ms
	elseif(ms < 100) then
		ms = "0" .. ms
	end

	return min, sec, ms
end

function getUrlParams(url)

	local index = string.find(url,"?")
	local paramsString = url:sub(index+1, string.len(url) )

	local params = {}

	fillNextParam(params, paramsString);

	return params;

end

function fillNextParam(params, paramsString)

	local indexEqual = string.find(paramsString,"=")
	local indexAnd = string.find(paramsString,"&")

	local indexEndValue
	if(indexAnd == nil) then 
		indexEndValue = string.len(paramsString) 
	else 
		indexEndValue = indexAnd - 1 
	end

	if ( indexEqual ~= nil ) then
		local varName = paramsString:sub(0, indexEqual-1)
		local value = paramsString:sub(indexEqual+1, indexEndValue)
		params[varName] = urlDecode(value)

		if (indexAnd ~= nil) then
			paramsString = paramsString:sub(indexAnd+1, string.len(paramsString) )
			fillNextParam(params, paramsString)
		end

	end

end


-----------------------------------------------------------------------------------------

function split(value, sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	value:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

-----------------------------------------------------------------------------------------

function emptyGroup( group )
	if(group ~= nil and group.numChildren ~= nil and group.numChildren > 0) then
		for i=group.numChildren,1,-1 do
			local child = group[i]
			transition.cancel(child)
			child:removeSelf()
			child = nil
		end
	end
end

function destroyFromDisplay(object)
	if(object) then
		display.remove(object)
		object = nil
	end
end


-----------------------------------------------------------------------------------------

function string.startsWith(String,Start)
	return string.sub(String,1,string.len(Start))==Start
end

function string.endsWith(String,End)
	return End=='' or string.sub(String,-string.len(End))==End
end

-----------------------------------------------------------------------------------------

function joinTables(t1, t2)

	local result = {}
	if(t1 == nil) then t1 = {} end
	if(t2 == nil) then t2 = {} end

	for k,v in pairs(t1) do
		result[k] = v 
	end 

	for k,v in pairs(t2) do
		result[k] = v 
	end 

	return result
end

-----------------------------------------------------------------------------------------

function removeFromTable(t, object)
	local index = 1
	for k,v in pairs(t) do
		if(t[k] == object) then
			break
		end

		index = index + 1 
	end 

	table.remove(t, index)
end

-----------------------------------------------------------------------------------------

function imageName( url )
	local index = string.find(url,"/")

	if(index == nil) then 
		if(not string.endsWith(url, ".png")) then
			url = url .. ".png"
		end
		return url;
	else
		local subURL = url:sub(index+1, string.len(url))
		return imageName(subURL)
	end
end

-----------------------------------------------------------------------------------------

--a tester  https://gist.github.com/874792

function tprint (tbl, indent)
	if not tbl then print("Table nil") return end
	if type(tbl) ~= "table" then
		print(tostring(tbl))
	else
		if not indent then indent = 0 end
		for k, v in pairs(tbl) do
			formatting = string.rep("  ", indent) .. k .. ": "
			if type(v) == "table" then
				print(formatting)
				tprint(v, indent+1)
			else
				print(formatting .. tostring(v))
			end
		end
	end
end

-----------------------------------------------------------------------------------------

function postWithJSON(data, url, next)
	post(url, json.encode(data), next, "json")
end

--------------------------------------------------------

function post(url, data, next, type)

	if(next == nil) then 
		next = function() end
	end

	local headers = {}

	if(type == nil) then
		headers["Content-Type"] = "application/x-www-form-urlencoded"
	elseif(type == "json") then
		headers["Content-Type"] = "application/json"
		headers["X-Auth-Token"] = GLOBALS.savedData.authToken
	end

	local params = {}
	params.headers = headers
	params.body = data

	network.request( url, "POST", next, params)
end


--------------------------------------------------------

function isEmail(str)
	return str:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")
end

--------------------------------------------------------

function urlDecode(str)
	str = string.gsub (str, "+", " ")
	str = string.gsub (str, "%%(%x%x)",
	function(h) return string.char(tonumber(h,16)) end)
	str = string.gsub (str, "\r\n", "\n")
	return str
end

function urlEncode(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
		function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str	
end

--------------------------------------------------------

function parseDate(str)
	_,_,y,m,d=string.find(str, "(%d+)-(%d+)-(%d+)")
	return tonumber(y),tonumber(m),tonumber(d)
end

function parseDateTime(str)
	local Y,M,D = parseDate(str)
	return os.time({year=Y, month=M, day=D})
end

---
-- Y-M-D to readableDate
function readableDate(date)
	return timestampToReadableDate(parseDateTime(date)*1000, false)
end

function timestampToReadableDate(date, withDay, withYear)
	
	local day		   = T (os.date("%A", date/1000))
	local numDay 		= utils.formatPositionNum(os.date("%d", date/1000))
	local month 		= T (os.date("%B", date/1000))
	local year 			= os.date("%Y", date/1000)
	
	if (LANG == "fr") then
		local y = ""
		if(withYear) then y = " " .. year end
		
   	if(withDay) then 
			return day .. " " .. numDay .. " " .. month .. y
		else
			return numDay .. " " .. month .. y
      end
	else
		local y = ""
		if(withYear) then y = ", " .. year end

   	if(withDay) then 
			return day .. ", " .. month .. " " .. numDay .. y
		else
   		return month .. " " .. numDay .. y
      end
   end
   
end

--------------------------------------------------------

function saveTable(t, filename, directory)

	if(not directory) then
		directory = system.DocumentsDirectory
	end

	local path = system.pathForFile( filename, directory)
	local file = io.open(path, "w")
	if file then
		local contents = json.encode(t)
		file:write( contents )
		io.close( file )
		return true
	else
		return false
	end
end

function saveFile(content, filename, directory)

	if(not directory) then
		directory = system.DocumentsDirectory
	end

	local path = system.pathForFile( filename, directory)
	local file = io.open(path, "w")
	if file then
		local contents = content
		file:write( contents )
		io.close( file )
		return true
	else
		return false
	end
end

function loadTable(path)
	local contents = ""
	local myTable = {}
	local file = io.open( path, "r" )
	if file then
		-- read all contents of file into a string
		local contents = file:read( "*a" )
		myTable = json.decode(contents);
		io.close( file )
		return myTable 
	end
	return nil
end

--------------------------------------------------------

function getPointsBetween(from, to, nbPoints)

	if(from.x > to.x) then
		local swap = from
		from = to
		to = swap
	end

	local x1,y1 = from.x,from.y
	local x2,y2 = to.x,to.y

	local step = math.abs(x2-x1)/nbPoints
	local points = {}

	local a = (y2-y1)/(x2-x1)

	for i=0,nbPoints do
		local x = x1 + i*step
		local y = y1 + a*(x - x1)
		table.insert(points, vector2D:new(x, y))
	end

	return points
end

--------------------------------------------------------

function loadUserData(file)
	return loadTable(system.pathForFile( file , system.DocumentsDirectory))
end

function loadFile(path)
	return loadTable(system.pathForFile( path , system.ResourceDirectory))
end

--------------------------------------------------------
--- http://developer.coronalabs.com/code/maths-library

-- returns the distance between points a and b
function distanceBetween( a, b )
	local width, height = b.x-a.x, b.y-a.y
	return (width*width + height*height)^0.5 -- math.sqrt(width*width + height*height)
	-- nothing wrong with math.sqrt, but I believe the ^.5 is faster
end

--------------------------------------------------------

function formatPositionNum(num)
	
	local suffix = ""
	num = tonumber(num)
	 
	if(LANG == "en") then
   	if(num == 1) then
   		suffix = "st"
   	elseif(num == 2) then
   		suffix = "nd"
   	elseif(num == 3) then
   		suffix = "rd"
   	else
   		suffix = "th"
		end
	end
	
	if(num < 10) then
		num = "0" .. num
	end
	
	return num .. suffix
end

--------------------------------------------------------
--

function isEuroCountry (country) 

  local isEuro = country == "AT"
      or  country == "BE"
      or  country == "CY"
      or  country == "EE"
      or  country == "FI"
      or  country == "FR"
      or  country == "DE"
      or  country == "GR"
      or  country == "IE"
      or  country == "IT"
      or  country == "LU"
      or  country == "MT"
      or  country == "NL"
      or  country == "PT"
      or  country == "SK"
      or  country == "SI"
      or  country == "ES"
      or  country == "BG"
      or  country == "HR"
      or  country == "CZ"
      or  country == "DK"
      or  country == "HU"
      or  country == "LV"
      or  country == "LT"
      or  country == "PL"
      or  country == "RO"
      or  country == "SE"
      or  country == "GB"
      or  country == "IS"
      or  country == "LI"
      or  country == "NO"
      or  country == "CH"
      or  country == "MC"
      or  country == "AL"
      or  country == "MK"
      or  country == "ME"
      or  country == "RS"
      or  country == "BA"

	return isEuro;
end


function displayPrice(price, country)

	if(not price) then
		price = 0
	end

	if(isEuroCountry(country)) then
		return price .. " €";

	else
		return "US$ " .. price;
	end

end

function countryPrice(euros, country, rateUSDtoEUR)

	if(not euros) then
		euros = 0
	end

	if(isEuroCountry(country)) then
		return euros;
	else
		return math.round(euros*rateUSDtoEUR);
	end

end

function convertAndDisplayPrice(price, country, rateUSDtoEUR)
	return displayPrice(countryPrice(price, country, rateUSDtoEUR), country)
end

--------------------------------------------------------
--
-- merci Vungle

function vardump(value, depth, key)
	local linePrefix = ""
	local spaces = ""

	if key ~= nil then
		linePrefix = "["..key.."] = "
	end

	if depth == nil then
		depth = 0
	else
		depth = depth + 1
		for i=1, depth do spaces = spaces .. "  " end
	end

	if type(value) == 'table' then
		mTable = getmetatable(value)
		if mTable == nil then
			print(spaces ..linePrefix.."(table) ")
		else
			print(spaces .."(metatable) ")
			value = mTable
		end
		for tableKey, tableValue in pairs(value) do
			vardump(tableValue, depth, tableKey)
		end
	elseif type(value)    == 'function' or
	type(value)       == 'thread' or
	type(value)       == 'userdata' or
	value             == nil
	then
		print(spaces..tostring(value))
	else
		print(spaces..linePrefix.."("..type(value)..") "..tostring(value))
	end
end
