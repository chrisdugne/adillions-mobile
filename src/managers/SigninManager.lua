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

-- 1.4- Login
-- function SigninManager:openLogin()
--     local url           = API_URL .. "mlogin2?lang=" .. LANG
--     self.listener       = function(event) self:loginViewListener(event) end
--     self.closeWebView   = viewManager.openWeb(url, self.listener)
-- end

-- 1.5+ Login
function SigninManager:openLogin()
    local url           = NODE_URL .. "/" .. LANG .. "/m/login"
    self.listener       = function(event) self:loginViewListener(event) end
    self.closeWebView   = viewManager.openWeb(url, self.listener)
end

------------------------------------------

function SigninManager:loginViewListener( event )

    if event.url then

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
    local url           = API_URL .. "msignin3?lang=" .. LANG
    self.listener       = function(event) self:signinViewListener(event) end
    self.closeWebView   = viewManager.openWeb(url, self.listener)
end

------------------------------------------

function SigninManager:signinViewListener( event )

    if event.url then

        print("---   signin listener")
        print(event.url)

        -- idem login
        if string.find(string.lower(event.url), API_URL .. "loggedin") then
            self:closeWebView()
            local params = utils.getUrlParams(event.url);

            GLOBALS.savedData.authToken  = params.authToken
            GLOBALS.savedData.user.email  = params.email
            utils.saveTable(GLOBALS.savedData, "savedData.json")

            userManager:fetchPlayer()

        elseif event.url == API_URL .. "backToMobile" then
            self:closeWebView()
            print("signin : backToMobile : outside")
            router.openOutside()

        elseif event.url == API_URL .. "connectWithFB" then
            self:closeWebView()
            facebook.login()
        end

    end
end

--------------------------------------------------------------------------------

function SigninManager:openSigninFB()

    print("signinFB")

    -- not facebook.data.birthday permission
    if(not facebook.data.birthday) then
        facebook.data.birthday = "-"
    end
    -- not facebook.data.email permission
    if(not facebook.data.email) then
        facebook.data.email = "-"
    end

    local url = API_URL .. "msigninFB2"
    url = url .. "?last_name="     .. utils.urlEncode(facebook.data.last_name)
    url = url .. "&first_name="    .. utils.urlEncode(facebook.data.first_name)
    url = url .. "&picture_url="   .. utils.urlEncode(facebook.data.picture.data.url)
    url = url .. "&birth_date="    .. facebook.data.birthday
    url = url .. "&email="         .. facebook.data.email
    url = url .. "&facebookName="  .. utils.urlEncode(facebook.data.name)
    url = url .. "&facebookId="    .. facebook.data.id
    url = url .. "&lang="          .. LANG

    self.listener       = function(event) self:signinFBViewListener(event) end
    self.closeWebView   = viewManager.openWeb(url, self.listener)
end

------------------------------------------

function SigninManager:signinFBViewListener( event )

    if event.url then

        if event.url == API_URL .. "backToMobile" then
            self:closeWebView()
            router.openOutside()

        elseif event.url == API_URL .. "requireLogout" then  -- changeAccount
            self:closeWebView()
            print("signinFB : requireLogout")
            userManager:logout()

        elseif string.find(event.url, "signedIn") then
            print("signinFB : success : requireFacebookConnectionTickets")
            self:closeWebView()
            local playerRealNames = utils.getUrlParams(event.url);

            GLOBALS.savedData.authToken = playerRealNames.authToken
            utils.saveTable(GLOBALS.savedData, "savedData.json")

            userManager.requireFacebookConnectionTickets = true

            userManager:fetchPlayer()
        end
    end
end

--------------------------------------------------------------------------------

return SigninManager
