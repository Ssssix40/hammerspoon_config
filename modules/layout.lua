local layout = {}

local hotkey = hs.hotkey
local window = hs.window
local screen = hs.screen
local json = hs.json
local fs = hs.fs

-- 更改布局文件存储位置到layouts文件夹
local layoutDir = hs.configdir .. "/layouts"
local layoutFile = layoutDir .. "/window_layouts.json"
local layouts = {}
local registeredHotkeys = {}

-- 确保布局目录存在
local function ensureLayoutDirExists()
    local attrs = fs.attributes(layoutDir)
    if not attrs or attrs.mode ~= "directory" then
        fs.mkdir(layoutDir)
    end
end

-- 加载已保存的布局
local function loadLayouts()
    ensureLayoutDirExists()
    local f = io.open(layoutFile, "r")
    if f then
        local content = f:read("*a")
        f:close()
        if content and #content > 0 then
            layouts = json.decode(content) or {}
        end
    end
end

-- 保存布局到文件（格式化JSON）
local function saveLayouts()
    ensureLayoutDirExists()
    local encoded = json.encode(layouts, true) -- 第二个参数true表示格式化
    if not encoded then
        hs.alert.show("布局保存失败: JSON编码错误")
        return
    end
    local f = io.open(layoutFile, "w+")
    if f then
        f:write(encoded)
        f:close()
    else
        hs.alert.show("布局保存失败: 无法写入文件")
    end
end

-- 获取当前所有窗口布局
local function captureCurrentLayout()
    -- window.orderedWindows() 返回最顶层到最底层
    local wins = hs.fnutils.filter(window.orderedWindows(), function(win)
        return win:isStandard() and win:screen()
    end)
    local layout = {}
    local total = #wins
    -- 反向赋予z，z=1为最底层，z=total为最顶层
    for i, win in ipairs(wins) do
        local f = win:frame()
        table.insert(layout, {
            app = win:application():bundleID(),
            title = win:title(),
            frame = {x = f.x, y = f.y, w = f.w, h = f.h},
            screen = win:screen():id(),
            z = total - i + 1
        })
    end
    return layout
end

-- 恢复指定布局
local function restoreLayout(layout)
    -- 首先创建一个副本以避免修改原始数据
    local layoutCopy = hs.fnutils.copy(layout)
    
    -- 第一步：先恢复所有窗口的位置和大小，不要考虑层级
    for _, info in ipairs(layoutCopy) do
        local app = hs.application.get(info.app)
        if app then
            for _, win in ipairs(app:allWindows()) do
                if win:isStandard() and win:title() == info.title then
                    local scr = screen.find(info.screen)
                    if scr then
                        win:moveToScreen(scr)
                    end
                    win:setFrame(hs.geometry.rect(info.frame))
                    break
                end
            end
        end
    end
    
    -- 第二步：等待所有窗口位置恢复完成
    hs.timer.usleep(200000) -- 200ms延迟
    
    -- 第三步：按照从底到顶的顺序（z从小到大）依次聚焦窗口
    table.sort(layoutCopy, function(a, b) return a.z < b.z end)
    
    for _, info in ipairs(layoutCopy) do
        local app = hs.application.get(info.app)
        if app then
            hs.timer.usleep(150000) -- 150ms延迟，确保前一个操作完成
            for _, win in ipairs(app:allWindows()) do
                if win:isStandard() and win:title() == info.title then
                    win:focus()
                    break
                end
            end
        end
    end
end

-- 绑定恢复布局的快捷键
local function bindRestoreHotkeys()
    -- 先解除所有已绑定的热键
    for _, hk in ipairs(registeredHotkeys) do
        hk:delete()
    end
    registeredHotkeys = {}

    -- 重新绑定保存快捷键
    table.insert(registeredHotkeys, hotkey.bind({'cmd', 'ctrl', 'shift'}, 'n', function()
        local layout = captureCurrentLayout()
        table.insert(layouts, layout)
        saveLayouts()
        hs.alert.show("保存布局 #" .. tostring(#layouts))
        bindRestoreHotkeys()
    end))

    -- 绑定恢复快捷键（只绑定1-9数字键，去掉ctrl）
    for i = 1, math.min(#layouts, 9) do
        local key = tostring(i)
        table.insert(registeredHotkeys, hotkey.bind({'cmd', 'shift'}, key, function()
            restoreLayout(layouts[i])
            hs.alert.show("恢复布局 #" .. key)
        end))
    end
end

-- 初始化布局功能
function layout.init()
    -- 尝试从旧位置迁移布局数据
    local oldLayoutFile = hs.configdir .. "/window_layouts.json"
    if fs.attributes(oldLayoutFile) then
        local f = io.open(oldLayoutFile, "r")
        if f then
            local content = f:read("*a")
            f:close()
            if content and #content > 0 then
                ensureLayoutDirExists()
                local newFile = io.open(layoutFile, "w+")
                if newFile then
                    newFile:write(content)
                    newFile:close()
                    -- 移动成功后可以删除旧文件
                    os.remove(oldLayoutFile)
                end
            end
        end
    end
    
    loadLayouts()
    bindRestoreHotkeys()
    return layout
end

return layout
