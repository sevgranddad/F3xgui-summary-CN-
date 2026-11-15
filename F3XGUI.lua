
--==================================================
-- F3XGUI HUB
-- ScriptBlox 中文脚本中心
-- Author: sevgranddad
--==================================================

local HttpService = game:GetService("HttpService")

--==============================
-- 1. 加载 WindUI
--==============================

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--==============================
-- 2. 创建主窗口
--==============================

local Window = WindUI:CreateWindow({
    Title = "F3XGUI HUB",
    Icon = "code",
    Author = "sevgranddad",
    Folder = "F3XGUI",
    Size = UDim2.fromOffset(650, 480)
})

--==============================
-- 3. 创建脚本中心
--==============================

local ScriptTab = Window:Tab({
    Title = "脚本中心",
    Icon = "search"
})

local SearchSection = ScriptTab:Section({
    Title = "ScriptBlox 中文搜索"
})

local ResultSection = ScriptTab:Section({
    Title = "搜索结果"
})

--==============================
-- 4. 基础设置
--==============================

local API = "https://scriptblox.com/api/script/search"
local SearchKeyword = "f3x"
local SearchPage = 1

local function Notify(title, content)
    WindUI:Notify({
        Title = title,
        Content = content,
        Duration = 3
    })
end

local function SafeText(value, fallback)
    if value == nil or tostring(value) == "" then
        return fallback or "未知"
    end

    return tostring(value)
end

--==============================
-- 5. 获取脚本信息
--==============================

local function GetScriptInfo(data)
    local owner = data.owner
    local gameData = data.game

    return {
        Name = SafeText(data.title, "未命名脚本"),

        Author = type(owner) == "table"
            and SafeText(owner.username, "未知作者")
            or "未知作者",

        Game = type(gameData) == "table"
            and SafeText(gameData.name, "通用")
            or "通用",

        Views = SafeText(data.views, "0"),

        Image = data.image
            or data.thumbnail
            or data.gameThumbnail,

        Source = data.script,

        Verified = data.verified == true,
        Patched = data.isPatched == true
    }
end

--==============================
-- 6. 源码查看器
--==============================

local function ViewSource(info)

    if type(info.Source) ~= "string"
        or info.Source == "" then

        Notify("源码不可用", "没有获取到源码")
        return
    end

    local SourceWindow = WindUI:CreateWindow({
        Title = "F3XGUI HUB - 源码查看器",
        Icon = "code",
        Author = "sevgranddad",
        Size = UDim2.fromOffset(700, 480)
    })

    local SourceTab = SourceWindow:Tab({
        Title = "脚本源码",
        Icon = "file-code"
    })

    SourceTab:Code({
        Title = info.Name,
        Code = info.Source
    })

    SourceTab:Button({
        Title = "复制源码",
        Icon = "copy",

        Callback = function()
            if setclipboard then
                setclipboard(info.Source)
                Notify("复制成功", "源码已复制")
            else
                Notify("复制失败", "当前环境不支持复制")
            end
        end
    })
end

--==============================
-- 7. 双重确认系统
--==============================

local function FirstConfirm(info)

    WindUI:Dialog({
        Title = "脚本详情",
        Content =
            "脚本名称：" .. info.Name
            .. "\n作者：" .. info.Author
            .. "\n适用游戏：" .. info.Game
            .. "\n浏览次数：" .. info.Views
            .. "\n\n是否继续？",

        Buttons = {
            {
                Title = "继续",

                Callback = function()

                    WindUI:Dialog({
                        Title = "第三方脚本安全提醒",

                        Content =
                            "该脚本来自 ScriptBlox。"
                            .. "\n第三方代码可能存在风险。"
                            .. "\n请先查看和检查源码。",

                        Buttons = {
                            {
                                Title = "查看源码",

                                Callback = function()
                                    ViewSource(info)
                                end
                            },

                            {
                                Title = "取消",

                                Callback = function()
                                    Notify(
                                        "已取消",
                                        "没有执行任何第三方代码"
                                    )
                                end
                            }
                        }
                    })
                end
            },

            {
                Title = "取消",

                Callback = function()
                    Notify("已取消", "返回脚本列表")
                end
            }
        }
    })
end

--==============================
-- 8. 搜索功能
--==============================

local function SearchScripts()

    if SearchKeyword == "" then
        Notify("搜索提示", "请输入关键词")
        return
    end

    Notify("正在搜索", "正在连接 ScriptBlox...")

    local url = API
        .. "?q=" .. HttpService:UrlEncode(SearchKeyword)
        .. "&page=" .. tostring(SearchPage)

    local success, response = pcall(function()
        return game:HttpGet(url, true)
    end)

    if not success then
        Notify("搜索失败", "无法连接 ScriptBlox")
        return
    end

    local decodeSuccess, decoded = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if not decodeSuccess or type(decoded) ~= "table" then
        Notify("搜索失败", "服务器数据解析失败")
        return
    end

    local scripts = decoded.result
        and decoded.result.scripts

    if type(scripts) ~= "table" or #scripts == 0 then
        Notify("没有结果", "没有找到相关脚本")
        return
    end

    -- 显示搜索结果
    for _, data in ipairs(scripts) do

        local info = GetScriptInfo(data)

        ResultSection:Paragraph({
            Title = "📜 " .. info.Name,

            Desc =
                "作者：" .. info.Author
                .. "\n游戏：" .. info.Game
                .. "\n浏览次数：" .. info.Views
                .. "\n验证状态："
                .. (info.Verified and "已验证" or "未验证")
                .. "\n状态："
                .. (info.Patched and "可能已失效" or "未标记失效")
        })

        ResultSection:Button({
            Title = "查看源码 / 安全确认",
            Icon = "shield-check",

            Callback = function()
                FirstConfirm(info)
            end
        })
    end

    Notify(
        "搜索完成",
        "已获取 " .. tostring(#scripts) .. " 条结果"
    )
end

--==============================
-- 9. 搜索输入框
--==============================

SearchSection:Input({
    Title = "搜索关键词",
    Placeholder = "例如：F3X",

    Callback = function(value)
        SearchKeyword = value
    end
})

SearchSection:Button({
    Title = "搜索脚本",
    Icon = "search",

    Callback = function()
        SearchPage = 1
        SearchScripts()
    end
})

SearchSection:Button({
    Title = "下一页",
    Icon = "chevron-right",

    Callback = function()
        SearchPage = SearchPage + 1
        SearchScripts()
    end
})

--==============================
-- 10. 启动提示
--==============================

Notify(
    "F3XGUI HUB",
    "中文脚本中心已加载"
)
