--------------------------------------------------------------------------------

SigninManager = {}

--------------------------------------------------------------------------------

function SigninManager:new()

    local object = {
        listener     = {},
        closeWebView = nil
    }

    setmetatable(object, { __index = SigninManager })
    return object
end

--------------------------------------------------------------------------------

--- route = login or register
function SigninManager:open(route)
    local url = SAILS_URL .. "/" .. LANG .. "/m/" .. route

    self.listener = function(event)
        self:loginListener(event, function()
            userManager:fetchPlayer()
        end)
    end

    self.closeWebView = viewManager.openWeb(url, self.listener)
end

--------------------------------------------------------------------------------

function SigninManager:connect(network, success, fail)
    local url = SAILS_URL .. "/m/auth/" .. network

    self.listener = function(event)
        self:loginListener(event, function()
            userManager:readPlayer(success)
        end)
    end

    self.closeWebView = viewManager.openWeb(url, self.listener, fail)
end

--------------------------------------------------------------------------------

function SigninManager:loginListener( event, next )
    if event.url then
        if string.find(string.lower(event.url), "loggedin") then
            self:closeWebView()
            local params = utils.getUrlParams(event.url);

            GLOBALS.savedData.authToken = params["auth_token"]:gsub('#_=_', '')
            utils.saveTable(GLOBALS.savedData, "savedData.json")
            next()
        end
    end
end

--------------------------------------------------------------------------------

return SigninManager
