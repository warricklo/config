-- XMonad configuration

import Control.Monad
import Data.Monoid
import System.Exit

import XMonad
import XMonad.Actions.CycleWS ( nextScreen, prevScreen, shiftNextScreen, shiftPrevScreen )
import XMonad.Actions.Navigation2D
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeWindows ( isFloating )
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks ( ToggleStruts(..), docks, avoidStruts )
import XMonad.Hooks.ManageHelpers ( isFullscreen, doFullFloat )
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Grid
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders ( noBorders )
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing ( Border(..), Spacing(..), spacingRaw )
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts ( ToggleLayout(..), toggleLayouts )
import XMonad.Util.Run ( safeSpawn, safeSpawnProg )
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

borderWidth = 2 :: Dimension
normalBorderColor = "#202020" :: String
focusedBorderColor = "#556FFF":: String

-- Default geometry of a floating window.
windowSize = W.RationalRect 0.2 0.2 0.6 0.6

-- Program definitions

terminal = "alacritty" :: String
browser = "firefox" :: String
terminalEditor = "nvim" :: String
visualEditor = "emacs" :: String

-- Other definitions

-- The argument to pass into the terminal emulator to set a window title.
termTitleOpt = "-t" :: String

-- Key bindings

keys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm,                               xK_Escape),       spawn "xmonad --recompile && xmonad --restart")
    , ((modm .|. shiftMask,                 xK_Escape),       io (exitWith ExitSuccess))
    , ((modm .|. controlMask,               xK_Escape),       io (exitWith ExitSuccess))
    , ((modm,                               xK_BackSpace),    kill)
    , ((modm .|. shiftMask,                 xK_c),            kill)

    -- Switching layouts.
    , ((modm,                               xK_Tab),          sendMessage NextLayout)
    , ((modm .|. shiftMask,                 xK_Tab),          sendMessage FirstLayout)
    , ((modm .|. mod1Mask,                  xK_space),        toggleFullscreen)
    , ((modm,                               xK_f),            withFocused toggleFloat)

    -- Focus and swap between monitors.
    , ((modm,                               xK_comma),        prevScreen)
    , ((modm,                               xK_period),       nextScreen)
    , ((modm .|. shiftMask,                 xK_comma),        shiftPrevScreen)
    , ((modm .|. shiftMask,                 xK_period),       shiftNextScreen)

    -- Change size of the master pane.
    , ((modm,                               xK_bracketleft),  sendMessage Shrink)
    , ((modm,                               xK_bracketright), sendMessage Expand)

    -- Change the number of windows in the master pane.
    , ((modm .|. shiftMask,                 xK_bracketleft),  sendMessage (IncMasterN $ 1))
    , ((modm .|. shiftMask,                 xK_bracketright), sendMessage (IncMasterN $ -1))

    -- Switch the layer of focus for directional navigation.
    , ((modm .|. controlMask,               xK_space),        switchLayer)

    -- Focus and swap windows using directional navigation.
    , ((modm,                               xK_Up),           windowGo U False)
    , ((modm,                               xK_Down),         windowGo D False)
    , ((modm,                               xK_Left),         windowGo L False)
    , ((modm,                               xK_Right),        windowGo R False)
    , ((modm,                               xK_k),            windowGo U False)
    , ((modm,                               xK_j),            windowGo D False)
    , ((modm,                               xK_h),            windowGo L False)
    , ((modm,                               xK_l),            windowGo R False)
    , ((modm .|. shiftMask,                 xK_Up),           windowSwap U False)
    , ((modm .|. shiftMask,                 xK_Down),         windowSwap D False)
    , ((modm .|. shiftMask,                 xK_Left),         windowSwap L False)
    , ((modm .|. shiftMask,                 xK_Right),        windowSwap R False)
    , ((modm .|. shiftMask,                 xK_k),            windowSwap U False)
    , ((modm .|. shiftMask,                 xK_j),            windowSwap D False)
    , ((modm .|. shiftMask,                 xK_h),            windowSwap L False)
    , ((modm .|. shiftMask,                 xK_l),            windowSwap R False)

    -- Binary space partition layout.
    , ((modm .|. controlMask,               xK_k),            sendMessage (ExpandTowards U))
    , ((modm .|. controlMask,               xK_j),            sendMessage (ExpandTowards D))
    , ((modm .|. controlMask,               xK_h),            sendMessage (ExpandTowards L))
    , ((modm .|. controlMask,               xK_l),            sendMessage (ExpandTowards R))
    , ((modm .|. controlMask .|. shiftMask, xK_k),            sendMessage (ShrinkFrom U))
    , ((modm .|. controlMask .|. shiftMask, xK_j),            sendMessage (ShrinkFrom D))
    , ((modm .|. controlMask .|. shiftMask, xK_h),            sendMessage (ShrinkFrom L))
    , ((modm .|. controlMask .|. shiftMask, xK_l),            sendMessage (ShrinkFrom R))
    , ((modm,                               xK_a),            sendMessage Balance)
    , ((modm .|. shiftMask,                 xK_a),            sendMessage Equalize)

    -- Run programs.
    , ((modm,                               xK_space),        safeSpawn "rofi" ["-show", "drun"])
    , ((modm .|. shiftMask,                 xK_space),        safeSpawn "rofi" ["-show", "run"])
    , ((modm,                               xK_Return),       safeSpawn Main.terminal [])
    , ((modm .|. mod1Mask,                  xK_w),            safeSpawn browser [])
    , ((modm .|. mod1Mask,                  xK_e),            safeSpawn visualEditor [])
    , ((modm .|. mod1Mask,                  xK_r),            runInTerm terminalEditor)
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
    toggleFloat win = do
        floating <- runQuery isFloating win
        windows (\s ->
            if floating
            then W.sink win s
            else (W.float win windowSize s))

mouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> centerAndFloat w >> mouseMoveWindow w >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
    ]
  where
    -- Float and center a window only if it is already tiling.
    centerAndFloat :: Window -> X ()
    centerAndFloat win = do
        floating <- runQuery isFloating win
        unless floating (windows (\s -> W.float win windowSize s))

-- 2D navigation

-- Window navigation in the Full layout doesn't work when noBorders is used.
navigation2DConfig = def
    { defaultTiledNavigation = centerNavigation
    , floatNavigation = centerNavigation
    , screenNavigation = lineNavigation
    , layoutNavigation = [("Full", centerNavigation)]
    , unmappedWindowRect = [("Full", singleWindowRect)]
    }

-- Layouts

nmaster = 1
delta = 1 / 100
ratio = 1 / 2

-- Add spacing along the edges of the screen and around windows.
layoutSpacing :: Integer -> l a -> ModifiedLayout Spacing l a
layoutSpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

grid = renamed [Replace "Grid"]
    $ layoutSpacing 8
    $ GridRatio (3 / 2)
tall = renamed [Replace "Tall"]
    $ layoutSpacing 8
    $ Tall nmaster delta (toRational (2 / (1 + sqrt(5))))  -- Use the inverse golden ratio.
bsp = renamed [Replace "BSP"]
    $ layoutSpacing 8
    $ emptyBSP
threeColumn = renamed [Replace "ThreeColumn"]
    $ layoutSpacing 8
    $ ThreeCol nmaster delta ratio
full = renamed [Replace "Full"]
    $ noBorders
    $ Full

layoutHook =
    avoidStruts
    $ toggleLayouts full
    $ grid ||| tall ||| bsp ||| threeColumn ||| Full

-- Startup

startupHook = do
    spawnOnce "feh --no-fehbg --bg-scale ${HOME}/backgrounds/background"
    spawnOnce "picom --experimental-backends --config ${HOME}/.config/picom/picom.conf"
    spawn "${HOME}/bin/polybar.sh"

-- Window rules

manageHook =
    composeAll
        [ insertPosition Below Newer
        , isFullscreen --> doFullFloat
        , appName =? "desktop_window" --> doIgnore
        , stringProperty "_NET_WM_WINDOW_TYPE" =? "_NET_WM_WINDOW_TYPE_DIALOG" --> doFloat
        , className =? "Xmessage" --> doFloat
        , className =? "Firefox" <&&> appName =? "Toolkit" --> doFloat  -- Firefox Picture-in-Picture windows.
        , className =? "Gimp" --> doFloat -- Gimp windows.
        ]

-- Log hook

-- Emit a DBus signal on log updates.
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
        D.signalBody = [D.toVariant $ UTF8.decodeString str]
    }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

-- Dynamic log with pretty printing format, outputted to DBus.
dbusLogHook :: D.Client -> PP
dbusLogHook dbus = def
    { ppOutput = dbusOutput dbus
    , ppOrder = \(_:l:_:_) -> [l]  -- Only output the layout.
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
