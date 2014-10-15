--------------------------------------------------------------------------------
-- Project: Time for uralys.libs
--
-- Date: March 21th, 2014
-- Version: 1.0
-- File name : Time.lua
--
-- Author: Chris Dugne @ Uralys - www.uralys.com
--
--------------------------------------------------------------------------------

module(..., package.seeall)

--------------------------------------------------------------------------------

local SERVER_TIME
local TIME_RECEIVED

--------------------------------------------------------------------------------

function setServerTime(serverTime)
    SERVER_TIME     = serverTime
    TIME_RECEIVED   = os.time() * 1000
end

--------------------------------------------------------------------------------

function elapsedTime()
    return os.time() * 1000 - TIME_RECEIVED
end

--------------------------------------------------------------------------------

function now()
    return SERVER_TIME + elapsedTime()
end
