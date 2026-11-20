
--[[
    UN F3X GUI
    Glass Blue Edition
    UI + Realm Prototype
    Author: sevgranddad
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 清理旧界面
local old = PlayerGui:FindFirstChild("UNF3X_GlassBlue")
if old then old:Destroy() end

local Theme = {
    Background = Color3.fromRGB(13, 21, 32),
    Panel = Color3.fromRGB(20, 34, 49),
    Panel2 = Color3.fromRGB(27, 45, 63),
    Blue = Color3.fromRGB(65, 170, 255),
    Text = Color3.fromRGB(235, 245, 255),
    SubText = Color3.fromRGB(139, 166, 190),
    Border = Color3.fromRGB(65, 112, 150),
    Green = Color3.fromRGB(80, 210, 155)
}

local function Create(class, properties, parent)
    local object = Instance.new(class)
    for key, value in pairs(properties) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function Corner(parent, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 10)
    }, parent)
end

local function Stroke(parent)
    Create("UIStroke", {
        Color = Theme.Border,
        Transparency = 0.45,
        Thickness = 1
    }, parent)
end

local function Label(parent, content, size, color)
    return Create("TextLabel", {
        BackgroundTransparency = 1,
        Text = content,
        TextSize = size or 14,
        TextColor3 = color or Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(1, -20, 0, 25)
    }, parent)
end

local Screen = Create("ScreenGui", {
    Name = "UNF3X_GlassBlue",
    ResetOnSpawn = false,
    DisplayOrder = 100
}, PlayerGui)

local Scale = Create("UIScale", {
    Scale = 1
}, Screen)

local Main = Create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(700, 455),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Background,
    BackgroundTransparency = 0.06,
    BorderSizePixel = 0
}, Screen)

Corner(Main, 15)
Stroke(Main)

local function UpdateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local viewport = camera.ViewportSize
    Scale.Scale = math.clamp(
        math.min(viewport.X / 740, viewport.Y / 490),
        0.55,
        1
    )
end

UpdateScale()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(UpdateScale)
end

-- Header
local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 56),
    BackgroundColor3 = Theme.Panel,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0
}, Main)

Corner(Header, 15)

local Logo = Label(Header, "UN F3X", 20)
Logo.Position = UDim2.fromOffset(17, 4)
Logo.Font = Enum.Font.GothamBold
Logo.Size = UDim2.new(0, 190, 0, 28)

local Subtitle = Label(Header, "GLASS BLUE EDITION  |  sevgranddad", 10, Theme.Blue)
Subtitle.Position = UDim2.fromOffset(19, 31)

local Close = Create("TextButton", {
    Text = "×",
    Size = UDim2.fromOffset(36, 34),
    Position = UDim2.new(1, -45, 0, 10),
    BackgroundColor3 = Theme.Panel2,
    TextColor3 = Theme.Text,
    TextSize = 23,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0
}, Header)
Corner(Close, 8)

-- Sidebar
local Sidebar = Create("Frame", {
    Position = UDim2.fromOffset(12, 68),
    Size = UDim2.new(0, 145, 1, -80),
    BackgroundColor3 = Theme.Panel,
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0
}, Main)
Corner(Sidebar, 12)
Stroke(Sidebar)

Create("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 9),
    PaddingRight = UDim.new(0, 9)
}, Sidebar)

Create("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Sidebar)

-- Content
local Content = Create("Frame", {
    Position = UDim2.new(0, 169, 0, 68),
    Size = UDim2.new(1, -181, 1, -80),
    BackgroundColor3 = Theme.Panel,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0
}, Main)
Corner(Content, 12)
Stroke(Content)

local PageTitle = Label(Content, "主页", 21)
PageTitle.Position = UDim2.fromOffset(17, 10)
PageTitle.Font = Enum.Font.GothamBold
PageTitle.Size = UDim2.new(1, -34, 0, 35)

local PageDescription = Label(Content, "UN F3X 控制中心", 12, Theme.SubText)
PageDescription.Position = UDim2.fromOffset(18, 43)

local PageArea = Create("ScrollingFrame", {
    Position = UDim2.fromOffset(15, 77),
    Size = UDim2.new(1, -30, 1, -89),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Theme.Blue,
    CanvasSize = UDim2.new()
}, Content)

local PageLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder
}, PageArea)

PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PageArea.CanvasSize = UDim2.new(
        0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10
    )
end)

local Pages = {}
local CurrentPage

local function CreatePage(name, description)
    local page = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Visible = false
    }, PageArea)

    Create("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    Pages[name] = {
        Frame = page,
        Description = description
    }

    return page
end

local function Card(parent, title, description)
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 75),
        BackgroundColor3 = Theme.Panel2,
        BorderSizePixel = 0
    }, parent)
    Corner(card, 10)

    local titleLabel = Label(card, title, 14)
    titleLabel.Position = UDim2.fromOffset(12, 7)

    local desc = Label(card, description, 11, Theme.SubText)
    desc.Position = UDim2.fromOffset(12, 35)

    return card
end

local function ActionCard(parent, title, description, buttonText, callback)
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 82),
        BackgroundColor3 = Theme.Panel2,
        BorderSizePixel = 0
    }, parent)
    Corner(card, 10)

    local titleLabel = Label(card, title, 14)
    titleLabel.Position = UDim2.fromOffset(12, 5)
    titleLabel.Size = UDim2.new(1, -125, 0, 27)

    local desc = Label(card, description, 10, Theme.SubText)
    desc.Position = UDim2.fromOffset(12, 36)
    desc.Size = UDim2.new(1, -125, 0, 25)

    local button = Create("TextButton", {
        Size = UDim2.fromOffset(95, 34),
        Position = UDim2.new(1, -107, 0.5, -17),
        BackgroundColor3 = Theme.Blue,
        Text = buttonText,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0
    }, card)
    Corner(button, 8)

    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return button
end

-- Pages
local Home = CreatePage("主页", "UN F3X 控制中心")
Card(Home, "欢迎使用 UN F3X", "Glass Blue Edition")
Card(Home, "UI 信息", "原生 Roblox Instance 构建")
Card(Home, "设备支持", "Mobile / Desktop")

local Build = CreatePage("建筑", "F3X 建筑工具")
Card(Build, "F3X 工具", "原版工具入口将在接入原版回调后启用")
Card(Build, "建筑操作", "请在有授权的体验中使用 F3X")
Card(Build, "建筑说明", "此页面不会伪造服务器建筑操作")

local Environment = CreatePage("环境", "环境视觉设置")
Card(Environment, "天空盒", "UN 主题天空盒配置入口")
Card(Environment, "环境颜色", "环境颜色配置入口")

local Appearance = CreatePage("外观", "自定义界面外观")
Card(Appearance, "主题颜色", "Glass Blue")
Card(Appearance, "透明度", "玻璃质感")

local Characters = CreatePage("角色", "角色展示")
Card(Characters, "1x1x1x1x1x1x1x1x1gof", "中央角色展示配置")
Card(Characters, "角色说明", "角色外观需要通过授权模型或头像资源导入")

local Realm = CreatePage("Realm", "UN Coffee Shop 领域")
Card(Realm, "UN COFFEE SHOP", "小型咖啡店领域")
Card(Realm, "中央人物", "1x1x1x1x1x1x1x1x1gof")
Card(Realm, "领域天空", "UN 主题天空盒")
Card(Realm, "入口告示", "欢迎来到 UN 的领域，请享受咖啡时光")
Card(Realm, "F3X 建造", "请接入你原版 F3X 的授权建筑回调")

local Settings = CreatePage("设置", "客户端界面设置")
Card(Settings, "界面信息", "UN F3X GUI")
Card(Settings, "作者", "sevgranddad")

-- Music
local MUSIC_ID = "rbxassetid://88523902860927"
local musicEnabled = true
local music

local function StartMusic()
    if music then
        music:Destroy()
    end

    music = Create("Sound", {
        Name = "UNCoffeeShopMusic",
        SoundId = MUSIC_ID,
        Volume = 0.45,
        Looped = true
    }, SoundService)

    music:Play()
end

local MusicPage = CreatePage("音乐", "UN Coffee Shop 背景音乐")
Card(MusicPage, "Unhappy", "音频 ID: 88523902860927")

local musicButton

musicButton = ActionCard(
    MusicPage,
    "背景音乐",
    "进入领域时自动播放 Unhappy",
    "暂停音乐",
    function()
        if not music then return end

        if music.IsPlaying then
            music:Pause()
            musicButton.Text = "播放音乐"
        else
            music:Resume()
            musicButton.Text = "暂停音乐"
        end
    end
)

local volumeCard = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 85),
    BackgroundColor3 = Theme.Panel2,
    BorderSizePixel = 0
}, MusicPage)
Corner(volumeCard, 10)

local volumeLabel = Label(volumeCard, "音量：45%", 12)
volumeLabel.Position = UDim2.fromOffset(12, 7)

local volumeBar = Create("Frame", {
    Position = UDim2.fromOffset(12, 48),
    Size = UDim2.new(1, -24, 0, 8),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
}, volumeCard)
Corner(volumeBar, 5)

local volumeFill = Create("Frame", {
    Size = UDim2.fromScale(0.45, 1),
    BackgroundColor3 = Theme.Blue,
    BorderSizePixel = 0
}, volumeBar)
Corner(volumeFill, 5)

local volumeButton = Create("TextButton", {
    BackgroundTransparency = 1,
    Text = "",
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.fromOffset(0, 37)
}, volumeCard)

volumeButton.MouseButton1Down:Connect(function()
    -- 点击音量条可调节音量
end)

-- Navigation
local Tabs = {
    {"主页", "⌂"},
    {"建筑", "▦"},
    {"环境", "☁"},
    {"角色", "♙"},
    {"Realm", "◇"},
    {"音乐", "♫"},
    {"外观", "◈"},
    {"设置", "⚙"}
}

local NavButtons = {}

local function SwitchPage(name)
    if not Pages[name] then return end

    for pageName, data in pairs(Pages) do
        data.Frame.Visible = pageName == name
    end

    PageArea.CanvasPosition = Vector2.zero
    PageTitle.Text = name
    PageDescription.Text = Pages[name].Description
    CurrentPage = name

    for buttonName, button in pairs(NavButtons) do
        local active = buttonName == name

        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundTransparency = active and 0 or 1,
            BackgroundColor3 = active and Theme.Blue or Theme.Panel2,
            TextColor3 = active and Color3.new(1, 1, 1) or Theme.SubText
        }):Play()
    end
end

for index, tab in ipairs(Tabs) do
    local name, symbol = tab[1], tab[2]

    local button = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Panel2,
        BackgroundTransparency = 1,
        Text = symbol .. "   " .. name,
        TextColor3 = Theme.SubText,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0,
        LayoutOrder = index
    }, Sidebar)

    Corner(button, 8)
    NavButtons[name] = button

    button.MouseButton1Click:Connect(function()
        SwitchPage(name)
    end)
end

SwitchPage("主页")

-- Window dragging
local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

Close.MouseButton1Click:Connect(function()
    Screen:Destroy()
    if music then
        music:Stop()
        music:Destroy()
    end
end)

-- Opening animation
Main.BackgroundTransparency = 1
Main.Size = UDim2.fromOffset(650, 420)

TweenService:Create(Main, TweenInfo.new(
    0.35,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.Out
), {
    BackgroundTransparency = 0.06,
    Size = UDim2.fromOffset(700, 455)
}):Play()

-- 自动播放 Unhappy
StartMusic()

print("[UN F3X] Glass Blue Edition loaded.")
