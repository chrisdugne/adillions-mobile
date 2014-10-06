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
    self.listener     = function(event) self:loginListener(event) end
    self.closeWebView = viewManager.openWeb(url, self.listener)
end

------------------------------------------

function SigninManager:loginListener( event )

    if event.url then
        if string.find(string.lower(event.url), "loggedin") then
            self:closeWebView()
            local params = utils.getUrlParams(event.url);

            GLOBALS.savedData.authToken  = params["auth_token"]
            utils.saveTable(GLOBALS.savedData, "savedData.json")

            userManager:fetchPlayer()
        end
    end
end

--------------------------------------------------------------------------------

return SigninManager
