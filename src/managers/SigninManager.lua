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

function SigninManager:openLogin()
    local url         = SAILS_URL .. "/" .. LANG .. "/m/login"
    self.listener     = function(event) self:loginListener(event) end
    self.closeWebView = viewManager.openWeb(url, self.listener)
end

--------------------------------------------------------------------------------

function SigninManager:openSignin()
    local url         = SAILS_URL .. "/" .. LANG .. "/m/register"

    self.listener     = function(event)
        self:loginListener(event, function()
            userManager:fetchPlayer()
        end)
    end

    self.closeWebView = viewManager.openWeb(url, self.listener)
end

--------------------------------------------------------------------------------

function SigninManager:connect(network, next)
    print('connection to : ' + network)
    local url         = SAILS_URL .. "/m/auth/" .. network

    self.listener     = function(event)
        self:loginListener(event, function()
            userManager:readPlayer()
            next()
        end)
    end

    self.closeWebView = viewManager.openWeb(url, self.listener)
end

--------------------------------------------------------------------------------

function SigninManager:loginListener( event, next )
    if event.url then
        if string.find(string.lower(event.url), "loggedin") then
            self:closeWebView()
            local params = utils.getUrlParams(event.url);

            GLOBALS.savedData.authToken  = params["auth_token"]
            utils.saveTable(GLOBALS.savedData, "savedData.json")

            next()
        end
    end
end

--------------------------------------------------------------------------------

return SigninManager
