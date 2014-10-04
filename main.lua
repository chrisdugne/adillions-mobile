--------------------------------------------------------------------------------
--
-- main.lua
--
--------------------------------------------------------------------------------
--- Corona's libraries
json                = require "json"
storyboard          = require "storyboard"
widget              = require "widget"
ads                 = require "ads"

---- Additional libs
xml                 = require "src.libs.Xml"
utils               = require "src.libs.Utils"
time                = require "src.libs.Time"
vungle              = require "src.libs.Vungle"
analytics           = require "src.libs.google.Analytics"

--------------------------------------------------------------------------------
---- App Tools
router              = require "src.tools.Router"
viewManager         = require "src.tools.ViewManager"

AppManager          = require "src.managers.AppManager"
GameManager         = require "src.managers.GameManager"
UserManager         = require "src.managers.UserManager"
LotteryManager      = require "src.managers.LotteryManager"
VideoManager        = require "src.managers.VideoManager"
ShareManager        = require "src.managers.ShareManager"
BannerManager       = require "src.managers.BannerManager"
SigninManager       = require "src.managers.SigninManager"

--------------------------------------------------------------------------------
---- Server access Managers

appManager     = AppManager:new()
gameManager    = GameManager:new()
userManager    = UserManager:new()
lotteryManager = LotteryManager:new()
videoManager   = VideoManager:new()
shareManager   = ShareManager:new()
bannerManager  = BannerManager:new()
signinManager  = SigninManager:new()

--------------------------------------------------------------------------------

appManager.start()
