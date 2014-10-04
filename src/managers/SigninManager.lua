--------------------------------------------------------------------------------

SigninManager = {}

--------------------------------------------------------------------------------

function SigninManager:new()

    local object = {
        listener         = {},
        closeWebView     = nil
    }

    setmetatable(object, { __index = SigninManager })
    return object
end

--------------------------------------------------------------------------------

function SigninManager:openLogin()
    local url           = NODE_URL .. "/" .. LANG .. "/m/login"
    self.listener       = function(event) self:loginViewListener(event) end
    self.closeWebView   = viewManager.openWeb(url, self.listener)
end

------------------------------------------

function SigninManager:loginViewListener( event )

    if event.url then
        print(event.url)
        if string.find(string.lower(event.url), "loggedin") then
            self:closeWebView()
            local params = utils.getUrlParams(event.url);

            GLOBALS.savedData.authToken  = params["auth_token"]
            utils.saveTable(GLOBALS.savedData, "savedData.json")

            userManager:fetchPlayer()

        elseif event.url == API_URL .. "backToMobile" then
            self:closeWebView()

        elseif event.url == API_URL .. "connectWithFB" then
            self:closeWebView()
            facebook.login()
        end

    end
end

--------------------------------------------------------------------------------

function SigninManager:openSignin()
    local url           = NODE_URL .. "/" .. LANG .. "/m/register"
    self.listener       = function(event) self:signinViewListener(event) end
    self.closeWebView   = viewManager.openWeb(url, self.listener)
end

------------------------------------------

function SigninManager:signinViewListener( event )

    if event.url then

        print("---   signin listener")
        print(event.url)

        if string.find(string.lower(event.url), "loggedin") then
            self:closeWebView()
            local params = utils.getUrlParams(event.url);

            GLOBALS.savedData.authToken  = params.auth_token
            utils.saveTable(GLOBALS.savedData, "savedData.json")

            userManager:fetchPlayer()

        elseif event.url == API_URL .. "backToMobile" then
            self:closeWebView()
            print("signin : backToMobile from url")
            router.openOutside()

        end

    end
end

--------------------------------------------------------------------------------

return SigninManager
