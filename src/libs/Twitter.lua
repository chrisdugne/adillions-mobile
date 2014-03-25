-- Project: Twitter sample app
--
-- File name: Twitter.lua
--
-- Author: Corona Labs
--
-- Abstract: Demonstrates how to connect to Twitter using Oauth Authenication.
--
-- Note: In order to get the Twitter sign-on working correctly, you need to
--   make sure you have the following items set in the Twitter Application page
--   1. "Callback URL" add your site URL here
--   2. "Sign in with Twitter" checked
--
-- History:
--  March 5, 2013 for Twitter API 1.1 using oAuth 1.0a
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2013 Corona Labs Inc. All Rights Reserved.

-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local oAuth = require "src.libs.oAuth"

-----------------------------------------------------------------------------------------

-- Fill in the following fields from your Twitter app account
consumer_key        = "mkJn1v9zVyKHnU7S6yLCg"
consumer_secret     = "wIj7zjxPTwc8Mt2uAyf8azKmSgPEDwYpvpxdtQwic"

-----------------------------------------------------------------------------------------

connected           = false
twitterON           = false
closeTwitterWebView = {}

-----------------------------------------------------------------------------------------

local callback = {}

-- Callbacks
function callback.twitterCancel()
    print( "Twitter Cancel" )
end

function callback.twitterSuccess( requestType, name, response )
    local results = ""

    print( "Twitter Success" )

    if "friends" == requestType then
        results = response.users[1].name .. ", count: " ..
        response.users[1].statuses_count
    end

    if "users" == requestType then
        results = response.name .. ", count: " ..
        response.statuses_count
    end

    if "tweet" == requestType then
        results = "Tweet Posted"
    end

    if(callback.next) then
        print("-----> callback")
        print("connected:")
        print(connected)
        callback.next(response)
    end 
end

function callback.twitterFailed()
    print( "Failed: Invalid Token" )
end

-----------------------------------------------------------------------------------------

function isTwitterFan( next )

    print("------------------------ isTwitterFan ")
    -- default : celui de la db, meme si non connecte
    -- triche possible : cancel fan et ne plus se connecter avec twitter.
    userManager.user.twitterFan = userManager.user.isTwitterFan

    if(not userManager.user.twitterId) then
        print("------------------------ not linked ")
    
        if(next) then
            next()
        end
        
    elseif(connected) then
        print("------------------------ connected ")

        callback.next = next

        local params = {"isFollowing", "friendships/show.json", "GET",
            {"source_id", userManager.user.twitterId}, {"target_id", TWITTER_ID } }

        tweet(callback, params)

    else

        print("------------------------ not connected : next  ")

        if(next) then
            next()
        end

    end

end

-----------------------------------------------------------------------------------------

function follow( next )
    
    print("twitter.follow")
    callback.next = next

    local params = {"follow", "friendships/create.json", "POST",
        {"user_id", TWITTER_ID}, {"follow", "true" } }

    tweet(callback, params)

end

-----------------------------------------------------------------------------------------

function tweetMessage( message, next )

    callback.next = next

    local params = {"tweet", "statuses/update.json", "POST",
        {"status", message} }

    tweet(callback, params)

end

-----------------------------------------------------------------------------------------

-- The web URL address below can be anything
-- Twitter sends the web address with the token back to your app and the code strips out the token to use to authorise it
--
webURL = "http://adillions.com/"

-- Note: Once logged on, the access_token and access_token_secret should be saved so they can
--      be used for the next session without the user having to log in again.
-- The following is returned after a successful authenications and log-in by the user
--

--a reflechir security : fermeture de l'app : ne pas store oauth tokens + secret = reconnect necessaire a la prochaine ouverture
local access_token
local access_token_secret
local user_id
local screen_name

-- Local variables used in the tweet
local postMessage
local delegate

-- Forward references
local doTweet   -- function to send the actual tweet
local proceed   -- called after connection is ok

-- Display a message if there is no app keys set
-- (App keys must be strings)
--
if not consumer_key or not consumer_secret then
    -- Handle the response from showAlert dialog boxbox
    --
    local function onComplete( event )
        if event.index == 1 then
            system.openURL( "https://dev.twitter.com//" )
        end
    end

    native.showAlert( "Error", "To develop for Twitter, you need to get an API key and application secret. This is available from Twitter's website.",
    { "Learn More", "Cancel" }, onComplete )
end

-----------------------------------------------------------------------------------------
-- Tweet
--
-- Sends the tweet or request. Authorizes if no access token
-----------------------------------------------------------------------------------------
--
function tweet(del, msg)

    print("tweet")
    postMessage = msg
    delegate = del

    -- Check to see if we are authorized to tweet
    if not access_token then
        print("tweet : must connect")
        connect(function()
            tweet(del, msg)
        end)
    else
        ----------------------------------------------------
        -- Account is already authorized, just tweet
        ----------------------------------------------------

        doTweet()

    end
end

-----------------------------------------------------------------------------------------

function reconnect()
    if(GLOBALS.savedData.twitterAccessToken) then
        print("twitter reconnect", GLOBALS.savedData.twitterAccessToken, GLOBALS.savedData.twitterAccessTokenSecret)
        access_token    = GLOBALS.savedData.twitterAccessToken
        access_token_secret  = GLOBALS.savedData.twitterAccessTokenSecret
        connected = true
    end
end

function logout()
    print("twitter logout")
    GLOBALS.savedData.twitterAccessToken    = nil
    GLOBALS.savedData.twitterAccessTokenSecret  = nil
    connected = false
end

function connect(next)

    native.setActivityIndicator(true)
    twitterON = true
    
    proceed    = next
    delegate   = callback

    ----------------------------------------------------
    -- Callback from getRequestToken
    ----------------------------------------------------
    function tweetAuth_ret( status, result )

        local twitter_request_token = result:match('oauth_token=([^&]+)')
        local twitter_request_token_secret = result:match('oauth_token_secret=([^&]+)')

        if not twitter_request_token then
            print( ">> No valid token received!") -- **debug

            -- No valid token received. Abort
            delegate.twitterFailed()
            return
        end

        -- Request the authorization (step 2)
        -- Displays a webpopup to access the Twitter site so user can sign in
        --
        print("showWebPopup")
        
        local url           = "https://api.twitter.com/oauth/authenticate?oauth_token=".. twitter_request_token
        closeTwitterWebView = viewManager.openWeb(url, twitterListener)
    
        twitterON = false
        native.setActivityIndicator(false)

    end --  end of tweetAuth_ret callback

    ----------------------------------------------------
    -- Executes first to authorize account
    ----------------------------------------------------

    if not consumer_key or not consumer_secret then
        -- Exit if no API keys set (avoids crashing app)
        delegate.twitterFailed()
        return
    end

    -- Get temporary token (step 1)  
    -- Call the routine and wait for a response callback (tweet_ret)
    local twitter_request = (oAuth.getRequestToken(consumer_key, webURL,
    "https://api.twitter.com/oauth/request_token", consumer_secret, tweetAuth_ret))

end

-----------------------------------------------------------------------------------------
-- Tweet
--
-- Sends actual tweet or request to Twitter
-----------------------------------------------------------------------------------------
--
function doTweet()

    local values = postMessage

    ----------------------------------------------------
    -- Callback from makeRequest
    ----------------------------------------------------
    function doTweetCallback( status, result )

        local response = json.decode( result )
        utils.tprint(response)

        if(response.errors) then
            
            if(response.errors[1].code == 187) then 
                -- message: Status is a duplicate.
                delegate.twitterSuccess()
            else
                twitter.logout()
    
                if(values[1] == "isFollowing") then
                    -- pas connecte lors du check isTwitterFan
                    if(callback.next) then
                        callback.next()
                    end
    
                else
                    twitter.connect(function()
                        tweet(callback, postMessage)
                    end)
    
                end
            end
    
        else
            -- Return the following: type of request, screen name, response
            delegate.twitterSuccess( values[1], screen_name, response )

        end

    end

    -- Build the parameter table for the Twitter Request
    -- values[1] = type of request (tweet, users, friends, etc.)
    -- values[2] = Twitter URL suffix
    -- values[3] = medthod: GET | POST
    -- values[4] ... values[n] = parameter pairs
    -- "SELF" is replaced by current screen_name
    --
    local params = {}

    if #values > 3 then
        for i = 4, #values do
            print( values[i][1] .. " = " .. values[i][2]  )
            params[i-3] = { key = values[i][1], value = values[i][2] }

            if params[i-3].value == "SELF" then 
                params[i-3].value = screen_name
            end
        end
    end

    oAuth.makeRequest("https://api.twitter.com/1.1/" .. values[2],
    params, consumer_key, access_token, consumer_secret, access_token_secret,
    values[3], doTweetCallback )

end


-----------------------------------------------------------------------------------------
-- Twitter Authorization Listener (callback from step 2)
-- webPopup listener
-----------------------------------------------------------------------------------------
--
function twitterListener(event)

    print("listener: ", event.url)
    local remain_open = true
    local url = event.url

    -- The URL that we are looking for contains "oauth_token" and our own URL
    -- It also has the "oauth_token_secret" and "oauth_verifier" strings
    --
    if url:find("oauth_token") and url:find(webURL) then
                    
        ----------------------------------------------------
        -- Callback from getAccessToken
        ----------------------------------------------------
        local function accessToken_ret( status, access_response )

            access_response         = responseToTable( access_response, {"=", "&"} )
            access_token            = access_response.oauth_token
            access_token_secret     = access_response.oauth_token_secret
            user_id                 = access_response.user_id
            screen_name             = access_response.screen_name

            if not access_token then
                return
            end

            ----------------------------------------------  
            -- Specific Adillions

            GLOBALS.savedData.twitterAccessToken   = access_response.oauth_token
            GLOBALS.savedData.twitterAccessTokenSecret = access_response.oauth_token_secret

            print("twitter connected ok specific adillions")
            connected = true
            closeTwitterWebView()
            userManager.requireTwitterConnectionTickets = true
            
            print("twitter : requireTwitterConnectionTickets : " .. tostring(userManager.requireTwitterConnectionTickets))
            userManager:twitterConnection(user_id, screen_name, proceed)
            
            ----------------------------------------------

            delegate.twitterSuccess()
        end -- end of callback listener

        ----------------------------------------------------
        -- Executes when Web Popup listener starts
        ----------------------------------------------------
        url = url:sub(url:find("?") + 1, url:len())

        -- Get Request Token and Verifier
        local authorize_response = responseToTable(url, {"=", "&"})
        remain_open = false

        -- Step 3 Converting Request Token to Access Token  
        oAuth.getAccessToken(authorize_response.oauth_token,
        authorize_response.oauth_verifier, twitter_request_token_secret, consumer_key, 
        consumer_secret, "https://api.twitter.com/oauth/access_token", accessToken_ret )

    elseif url:find(webURL) then

        -- Logon was canceled by user
        --
        remain_open = false
        delegate.twitterCancel()

    end

    return remain_open
end



-----------------------------------------------------------------------------------------
-- RESPONSE TO TABLE
--
-- Strips the token from the web address returned
-----------------------------------------------------------------------------------------
--
function responseToTable(str, delimeters)

    local obj = {}

    while str:find(delimeters[1]) ~= nil do
        if #delimeters > 1 then
            local key_index = 1
            local val_index = str:find(delimeters[1])
            local key = str:sub(key_index, val_index - 1)

            str = str:sub((val_index + delimeters[1]:len()))

            local end_index
            local value

            if str:find(delimeters[2]) == nil then
                end_index = str:len()
                value = str
            else
                end_index = str:find(delimeters[2])
                value = str:sub(1, (end_index - 1))
                str = str:sub((end_index + delimeters[2]:len()), str:len())
            end
            obj[key] = value
            --print(key .. ":" .. value)  -- **debug
        else

            local val_index = str:find(delimeters[1])
            str = str:sub((val_index + delimeters[1]:len()))

            local end_index
            local value

            if str:find(delimeters[1]) == nil then
                end_index = str:len()
                value = str
            else
                end_index = str:find(delimeters[1])
                value = str:sub(1, (end_index - 1))
                str = str:sub(end_index, str:len())
            end

            obj[#obj + 1] = value

        end
    end

    return obj
end

-----------------------------------------------------------------------------------------
-- printTable (**debug)
--
-- This function is useful for display json information returned from Twitter api.
-----------------------------------------------------------------------------------------
--
local function printTable( t, label, level )
    if label then print( label ) end
    level = level or 1

    if t then
        for k,v in pairs( t ) do
            local prefix = ""
            for i=1,level do
                prefix = prefix .. "\t"
            end

            print( prefix .. "[" .. tostring(k) .. "] = " .. tostring(v) )
            if type( v ) == "table" then
                print( prefix .. "{" )
                printTable( v, nil, level + 1 )
                print( prefix .. "}" )
            end
        end
    end
end