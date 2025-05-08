local windowManager = {}

local hotkey = hs.hotkey
local window = hs.window
local screen = hs.screen
local geometry = hs.geometry

-- 基础修饰键
local modifiers = {"cmd", "ctrl"}

-- 获取可用的屏幕框架
local function getVisibleFrameForScreen(scr)
    return scr:frame()
end

-- 窗口占据左半屏
local function moveWindowToLeft()
    local win = window.focusedWindow()
    if not win then return end
    
    local scr = win:screen()
    local scrFrame = getVisibleFrameForScreen(scr)
    local newFrame = geometry.rect(scrFrame.x, scrFrame.y, scrFrame.w / 2, scrFrame.h)
    win:setFrame(newFrame)
end

-- 窗口占据右半屏
local function moveWindowToRight()
    local win = window.focusedWindow()
    if not win then return end
    
    local scr = win:screen()
    local scrFrame = getVisibleFrameForScreen(scr)
    local newFrame = geometry.rect(scrFrame.x + scrFrame.w / 2, scrFrame.y, scrFrame.w / 2, scrFrame.h)
    win:setFrame(newFrame)
end

-- 窗口全屏（屏幕尺寸100%）
local function fullScreenWindow()
    local win = window.focusedWindow()
    if not win then return end
    
    local scr = win:screen()
    local scrFrame = getVisibleFrameForScreen(scr)
    
    -- 设置为屏幕大小的100%
    local newFrame = geometry.rect(scrFrame.x, scrFrame.y, scrFrame.w, scrFrame.h)
    win:setFrame(newFrame)
end

-- 窗口居中，大小为屏幕85%
local function centerWindowScaled()
    local win = window.focusedWindow()
    if not win then return end
    
    local scr = win:screen()
    local scrFrame = getVisibleFrameForScreen(scr)
    
    local width = scrFrame.w * 0.85
    local height = scrFrame.h * 0.85
    local x = scrFrame.x + (scrFrame.w - width) / 2
    local y = scrFrame.y + (scrFrame.h - height) / 2
    
    local newFrame = geometry.rect(x, y, width, height)
    win:setFrame(newFrame)
end

-- 窗口居中，大小为屏幕60%
local function centerWindow()
    local win = window.focusedWindow()
    if not win then return end
    
    local scr = win:screen()
    local scrFrame = getVisibleFrameForScreen(scr)
    
    local width = scrFrame.w * 0.6
    local height = scrFrame.h * 0.6
    local x = scrFrame.x + (scrFrame.w - width) / 2
    local y = scrFrame.y + (scrFrame.h - height) / 2
    
    local newFrame = geometry.rect(x, y, width, height)
    win:setFrame(newFrame)
end

-- 窗口占据左上角
local function moveWindowToTopLeft()
    local win = window.focusedWindow()
    if not win then return end
    
    local scr = win:screen()
    local scrFrame = getVisibleFrameForScreen(scr)
    local newFrame = geometry.rect(scrFrame.x, scrFrame.y, scrFrame.w / 2, scrFrame.h / 2)
    win:setFrame(newFrame)
end

-- 窗口占据右上角
local function moveWindowToTopRight()
    local win = window.focusedWindow()
    if not win then return end
    
    local scr = win:screen()
    local scrFrame = getVisibleFrameForScreen(scr)
    local newFrame = geometry.rect(scrFrame.x + scrFrame.w / 2, scrFrame.y, scrFrame.w / 2, scrFrame.h / 2)
    win:setFrame(newFrame)
end

-- 窗口占据左下角
local function moveWindowToBottomLeft()
    local win = window.focusedWindow()
    if not win then return end
    
    local scr = win:screen()
    local scrFrame = getVisibleFrameForScreen(scr)
    local newFrame = geometry.rect(scrFrame.x, scrFrame.y + scrFrame.h / 2, scrFrame.w / 2, scrFrame.h / 2)
    win:setFrame(newFrame)
end

-- 窗口占据右下角
local function moveWindowToBottomRight()
    local win = window.focusedWindow()
    if not win then return end
    
    local scr = win:screen()
    local scrFrame = getVisibleFrameForScreen(scr)
    local newFrame = geometry.rect(
        scrFrame.x + scrFrame.w / 2,
        scrFrame.y + scrFrame.h / 2,
        scrFrame.w / 2,
        scrFrame.h / 2
    )
    win:setFrame(newFrame)
end

-- 初始化窗口管理功能
function windowManager.init()
    -- 基本方向键
    hotkey.bind(modifiers, "left", moveWindowToLeft)
    hotkey.bind(modifiers, "right", moveWindowToRight)
    hotkey.bind(modifiers, "up", fullScreenWindow)   -- 改为全屏窗口
    hotkey.bind(modifiers, "down", centerWindowScaled)  -- 新增85%尺寸居中窗口
    
    -- 组合方向键（映射到jkui键位）
    hotkey.bind(modifiers, "j", moveWindowToBottomLeft)  -- 左下角
    hotkey.bind(modifiers, "k", moveWindowToBottomRight) -- 右下角
    hotkey.bind(modifiers, "u", moveWindowToTopLeft)     -- 左上角
    hotkey.bind(modifiers, "i", moveWindowToTopRight)    -- 右上角
    
    return windowManager
end

return windowManager
