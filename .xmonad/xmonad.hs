-- XMonad configuration

import Control.Monad
import Data.Monoid
import System.Exit

import Graphics.X11.ExtraTypes.XF86

import XMonad hiding ( (|||) )
import XMonad.Actions.CycleWS ( nextScreen, prevScreen, shiftNextScreen, shiftPrevScreen )
import XMonad.Actions.Navigation2D
import XMonad.Actions.Promote
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeWindows ( isFloating )
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks ( ToggleStruts(..), docks, avoidStruts )
import XMonad.Hooks.ManageHelpers ( isFullscreen, doFullFloat )
import XMonad.Layout.Grid
import XMonad.Layout.LayoutCombinators ( (|||), JumpToLayout(..) )
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders ( noBorders )
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts ( ToggleLayout(..), toggleLayouts )
import XMonad.Util.Run ( safeSpawn )
import XMonad.Util.SpawnOnce

import qualified Codec.Binary.UTF8.String as UTF8
import qualified Data.Map as M
import qualified DBus as D
import qualified DBus.Client as D

import qualified XMonad.StackSet as W

-- Basic configuration

modMask = mod4Mask :: KeyMask

workspaces = map show [1 .. 10] :: [String]

focusFollowsMouse = False :: Bool
clickJustFocuses = False :: Bool

borderWidth = 1 :: Dimension
normalBorderColor = "#202020" :: String
focusedBorderColor = "#556FFF":: String

-- Default geometry of a floating window.
windowSize = W.RationalRect 0.2 0.2 0.6 0.6

-- Program definitions

terminal = "alacritty" :: String
browser = "firefox" :: String
terminalEditor = "nvim" :: String
visualEditor = "emacs" :: String
terminalFileManager = "nnn" :: String
fileManager = "pcmanfm" :: String
terminalMusicPlayer = "ncmpcpp" :: String
musicPlayer = "spotify" :: String

-- Other definitions

-- The argument to pass into the terminal emulator to set a window title.
termTitleOpt = "-t" :: String

-- File path for screenshots.
screenshotPath = "$(xdg-user-dir PICTURES)/screenshots/$(date -I\"seconds\").png" :: String


-- 2D navigation

-- Window navigation in the Full layout doesn't work when noBorders is used.
navigation2DConfig = def
    { defaultTiledNavigation = centerNavigation
    , floatNavigation = centerNavigation
    , screenNavigation = lineNavigation
    , layoutNavigation = [("Full", centerNavigation)]
    , unmappedWindowRect = [("Full", singleWindowRect)]
    }

-- Key bindings

keys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, xK_Escape), spawn "xmonad --recompile && xmonad --restart")
    , ((modm .|. shiftMask, xK_Escape), io $ exitWith ExitSuccess)
    , ((modm .|. controlMask, xK_Escape), io $ exitWith ExitSuccess)
    , ((modm, xK_BackSpace), kill)
    , ((modm .|. shiftMask, xK_c), kill)

    -- Switching layouts.
    , ((modm, xK_Tab), sendMessage NextLayout)
    , ((modm, xK_m), toggleFullscreen)
    , ((modm, xK_n), withFocused toggleFloat)
    , ((modm, xK_t), sendMessage $ JumpToLayout "Tall")
    , ((modm, xK_g), sendMessage $ JumpToLayout "Grid")
    , ((modm, xK_f), sendMessage $ JumpToLayout "Full")

    -- Focus and swap between monitors.
    , ((modm, xK_comma), prevScreen)
    , ((modm, xK_period), nextScreen)
    , ((modm .|. shiftMask, xK_comma), shiftPrevScreen)
    , ((modm .|. shiftMask, xK_period), shiftNextScreen)

    -- Change size of the master pane.
    , ((modm, xK_bracketleft), sendMessage Shrink)
    , ((modm, xK_bracketright), sendMessage Expand)

    -- Change the number of windows in the master pane.
    , ((modm .|. shiftMask, xK_bracketleft), sendMessage $ IncMasterN 1)
    , ((modm .|. shiftMask, xK_bracketright), sendMessage $ IncMasterN (-1))

    -- Change the size of the window and screen spacing.
    , ((modm, xK_minus), decWindowSpacing 4 >> decScreenSpacing 4)
    , ((modm, xK_equal), incWindowSpacing 4 >> incScreenSpacing 4)

    -- Promote window to the master pane. If the window is in the master pane,
    -- swap it with the next window in the stack.
    , ((modm, xK_p), promote)

    -- Switch the layer of focus for directional navigation.
    , ((modm .|. controlMask, xK_space), switchLayer)

    -- Focus and swap windows using directional navigation.
    , ((modm, xK_Up), windowGo U False)
    , ((modm, xK_Down), windowGo D False)
    , ((modm, xK_Left), windowGo L False)
    , ((modm, xK_Right), windowGo R False)
    , ((modm, xK_k), windowGo U False)
    , ((modm, xK_j), windowGo D False)
    , ((modm, xK_h), windowGo L False)
    , ((modm, xK_l), windowGo R False)
    , ((modm .|. shiftMask, xK_Up), windowSwap U False)
    , ((modm .|. shiftMask, xK_Down), windowSwap D False)
    , ((modm .|. shiftMask, xK_Left), windowSwap L False)
    , ((modm .|. shiftMask, xK_Right), windowSwap R False)
    , ((modm .|. shiftMask, xK_k), windowSwap U False)
    , ((modm .|. shiftMask, xK_j), windowSwap D False)
    , ((modm .|. shiftMask, xK_h), windowSwap L False)
    , ((modm .|. shiftMask, xK_l), windowSwap R False)

    -- Run programs.
    , ((modm, xK_space), safeSpawn "rofi" ["-show", "drun"])
    , ((modm .|. shiftMask, xK_space), safeSpawn "rofi" ["-show", "run"])
    , ((modm, xK_Return), safeSpawn Main.terminal [])
    , ((modm .|. mod1Mask, xK_b), safeSpawn browser [])
    , ((modm .|. mod1Mask, xK_e), safeSpawn visualEditor [])
    , ((modm .|. mod1Mask, xK_f), safeSpawn fileManager [])
    , ((modm .|. mod1Mask, xK_s), safeSpawn musicPlayer [])
    , ((modm .|. mod1Mask, xK_r), runInTerm terminalEditor)
    , ((modm .|. mod1Mask, xK_n), runInTerm terminalFileManager)
    , ((modm .|. mod1Mask, xK_p), runInTerm terminalMusicPlayer)

    -- Screenshot entire desktop and save image file.
    , ((0, xK_Print),
        spawn ("maim " ++ screenshotPath))
    -- Select region, screenshot, and save image file.
    , ((modm, xK_Print),
        spawn ("maim -s -b 2 -c 0.9,0.9,0.9 " ++ screenshotPath))
    -- Select region, screenshot, save image file, and copy to clipboard.
    , ((shiftMask, xK_Print),
        spawn ("maim -s -b 2 -c 0.9,0.9,0.9 | tee " ++ screenshotPath ++ " | xclip -selection clipboard -t image/png"))

    -- Multimedia keys.
    , ((0, xF86XK_AudioMute),
        spawn "amixer set Master toggle")
    , ((0, xF86XK_AudioLowerVolume),
        spawn "amixer set Master unmute 1%-")
    , ((0, xF86XK_AudioRaiseVolume),
        spawn "amixer set Master unmute 1%+")
    , ((shiftMask, xF86XK_AudioLowerVolume),
        spawn "amixer set Master unmute 10%-")
    , ((shiftMask, xF86XK_AudioRaiseVolume),
        spawn "amixer set Master unmute 10%+")
    , ((0, xF86XK_AudioPlay),
        spawn "mpc toggle")
    , ((0, xF86XK_AudioStop),
        spawn "mpc stop")
    , ((0, xF86XK_AudioPrev),
        spawn "mpc seek -10")
    , ((0, xF86XK_AudioNext),
        spawn "mpc seek +10")
    , ((shiftMask, xF86XK_AudioPrev),
        spawn "mpc prev")
    , ((shiftMask, xF86XK_AudioNext),
        spawn "mpc next")
    ]
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]
  where
    -- Run the given command in the configured terminal emulator.
    -- Reimplementation of XMonad.Util.Run.safeRunInTerm because the function
    -- appears to not work when passing arguments into the terminal emulator.
    runInTerm :: String -> X ()
    runInTerm command = safeSpawn Main.terminal [termTitleOpt, command, "-e", command]

    -- Toggle struts and toggle the Full layout.
    toggleFullscreen :: X ()
    toggleFullscreen = sendMessage ToggleStruts >> sendMessage (Toggle "Full")

    -- Toggle floating for the given window.
    toggleFloat :: Window -> X ()
    toggleFloat w = do
        floating <- runQuery isFloating w
        windows (\s ->
            if floating
                then W.sink w s
                else (W.float w windowSize s))

mouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> centerAndFloat w >> mouseMoveWindow w >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
    ]
  where
    -- Float and center a window only if it is already tiling.
    centerAndFloat :: Window -> X ()
    centerAndFloat w = do
        floating <- runQuery isFloating w
        unless floating (windows (\s -> W.float w windowSize s))

-- Layouts

layoutHook =
    avoidStruts
    $ toggleLayouts full
    $ tall ||| grid ||| Full
  where
    -- Add spacing along the edges of the screen and around windows.
    layoutSpacing :: Integer -> l a -> ModifiedLayout Spacing l a
    layoutSpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

    tall = renamed [Replace "Tall"]
        $ layoutSpacing 8
        $ Tall 1 (1/100) (toRational (2/(1+sqrt(5))))  -- Use the inverse golden ratio.
    grid = renamed [Replace "Grid"]
        $ layoutSpacing 8
        $ GridRatio (3/2)
    full = renamed [Replace "Full"]
        $ noBorders
        $ Full

-- Startup

startupHook = do
    spawnOnce "feh --no-fehbg --bg-scale $HOME/backgrounds/background"
    spawnOnce "picom --experimental-backends --config $HOME/.config/picom/picom.conf"
    spawn "sh $HOME/bin/polybar"  -- For some reason the script will not run unless it is sourced.

-- Window rules

manageHook = composeAll
    [ insertPosition Below Newer
    , isFullscreen --> doFullFloat
    , appName =? "desktop_window" --> doIgnore
    , stringProperty "_NET_WM_WINDOW_TYPE" =? "_NET_WM_WINDOW_TYPE_DIALOG" --> doFloat
    , className =? "Xmessage" --> doFloat
    , className =? "Firefox" <&&> appName =? "Toolkit" --> doFloat  -- Firefox Picture-in-Picture windows.
    , className =? "Gimp" --> doFloat -- Gimp windows.
    ]

-- Log hook

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
    let
        objectPath = D.objectPath_ "/org/xmonad/Log"
        interfaceName = D.interfaceName_ "org.xmonad.Log"
        memberName = D.memberName_ "Update"
        signal = D.signal objectPath interfaceName memberName
        body = [D.toVariant $ UTF8.decodeString str]
    in
        D.emit dbus $ signal { D.signalBody = body }

-- Dynamic log with pretty printing format, outputted to DBus.
dbusLogHook :: D.Client -> PP
dbusLogHook dbus = def
    { ppOrder = \(_:l:_:_) -> [l]  -- Only output the layout.
    , ppOutput = dbusOutput dbus
    }

-- Main

main :: IO ()
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name.
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    xmonad $ ewmh $ docks $ withNavigation2DConfig navigation2DConfig $ def
        { XMonad.modMask = Main.modMask
        , XMonad.workspaces = Main.workspaces
        , XMonad.focusFollowsMouse = Main.focusFollowsMouse
        , XMonad.clickJustFocuses = Main.clickJustFocuses
        , XMonad.borderWidth = Main.borderWidth
        , XMonad.normalBorderColor = Main.normalBorderColor
        , XMonad.focusedBorderColor = Main.focusedBorderColor

        , XMonad.terminal = Main.terminal

        , XMonad.keys = Main.keys
        , XMonad.mouseBindings = Main.mouseBindings

        , XMonad.layoutHook = Main.layoutHook
        , XMonad.startupHook = Main.startupHook
        , XMonad.manageHook = Main.manageHook
        , logHook = dynamicLogWithPP (dbusLogHook dbus)
        , handleEventHook = fullscreenEventHook <+> ewmhDesktopsEventHook
        }
