
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Config = {
    Name = "F3x HUB",
    Version = "1.0.0",
    Author = "sevgranddad",

    Background = Color3.fromRGB(13, 13, 21),
    Sidebar = Color3.fromRGB(18, 18, 29),
    Card = Color3.fromRGB(25, 24, 39),

    Purple = Color3.fromRGB(153, 95, 255),
    PurpleLight = Color3.fromRGB(190, 145, 255),

    White = Color3.fromRGB(245, 243, 255),
    Gray = Color3.fromRGB(130, 128, 151),
    Border = Color3.fromRGB(48, 43, 68),
}

local function Create(class, props, parent)
    local obj = Instance.new(class)

    for k, v in pairs(props or {}) do
        obj[k] = v
    end

    obj.Parent = parent
    return obj
end

local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, parent)
end

local function Stroke(parent, color, transparency)
    return Create("UIStroke", {
        Color = color or Config.Border,
        Transparency = transparency or 0,
        Thickness = 1
    }, parent)
end

local function Gradient(parent, c1, c2, rotation)
    return Create("UIGradient", {
        Color = ColorSequence.new(c1, c2),
        Rotation = rotation or 0
    }, parent)
end

local function Tween(obj, time, properties)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    t:Play()
    return t
end

--========================================
-- SCREEN
--========================================

local Screen = Create("ScreenGui", {
    Name = "GUI Dashboard",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

--========================================
-- MAIN WINDOW
--========================================

local Main = Create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(780, 490),
    Position = UDim2.new(0.5, -390, 0.5, -245),
    BackgroundColor3 = Config.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, Screen)

Corner(Main, 15)
Stroke(Main, Config.Border, 0.15)

--========================================
-- TOP BAR
--========================================

local Top = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = Color3.fromRGB(21, 20, 33),
    BorderSizePixel = 0
}, Main)

Corner(Top, 15)

local TopCover = Create("Frame", {
    Position = UDim2.new(0, 0, 1, -15),
    Size = UDim2.new(1, 0, 0, 15),
    BackgroundColor3 = Color3.fromRGB(21, 20, 33),
    BorderSizePixel = 0
}, Top)

local Logo = Create("Frame", {
    Position = UDim2.fromOffset(17, 10),
    Size = UDim2.fromOffset(32, 32),
    BackgroundColor3 = Config.Purple,
    BorderSizePixel = 0
}, Top)

Corner(Logo, 9)
Gradient(Logo, Config.PurpleLight, Config.Purple, 45)

Create("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "P",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 19
}, Logo)

Create("TextLabel", {
    Position = UDim2.fromOffset(58, 0),
    Size = UDim2.fromOffset(170, 52),
    BackgroundTransparency = 1,
    Text = Config.Name,
    TextColor3 = Config.White,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left
}, Top)

-- Status

local Status = Create("Frame", {
    Position = UDim2.new(1, -190, 0.5, -12),
    Size = UDim2.fromOffset(105, 25),
    BackgroundColor3 = Color3.fromRGB(32, 30, 46),
    BorderSizePixel = 0
}, Top)

Corner(Status, 7)

Create("Frame", {
    Position = UDim2.fromOffset(10, 9),
    Size = UDim2.fromOffset(7, 7),
    BackgroundColor3 = Color3.fromRGB(100, 230, 150),
    BorderSizePixel = 0
}, Status)

Create("TextLabel", {
    Position = UDim2.fromOffset(24, 0),
    Size = UDim2.new(1, -25, 1, 0),
    BackgroundTransparency = 1,
    Text = "UI LOADED",
    TextColor3 = Config.Gray,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
}, Status)

-- Window buttons

local Minimize = Create("TextButton", {
    Position = UDim2.new(1, -75, 0.5, -14),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = Color3.fromRGB(39, 36, 55),
    Text = "—",
    TextColor3 = Config.White,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, Top)

Corner(Minimize, 7)

local Close = Create("TextButton", {
    Position = UDim2.new(1, -39, 0.5, -14),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = Color3.fromRGB(130, 52, 76),
    Text = "×",
    TextColor3 = Config.White,
    TextSize = 19,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, Top)

Corner(Close, 7)

--========================================
-- SIDEBAR
--========================================

local Sidebar = Create("Frame", {
    Position = UDim2.fromOffset(0, 52),
    Size = UDim2.new(0, 190, 1, -52),
    BackgroundColor3 = Config.Sidebar,
    BorderSizePixel = 0
}, Main)

Create("TextLabel", {
    Position = UDim2.fromOffset(20, 22),
    Size = UDim2.new(1, -35, 0, 20),
    BackgroundTransparency = 1,
    Text = "MAIN MENU",
    TextColor3 = Config.Gray,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Sidebar)

local Nav = Create("Frame", {
    Position = UDim2.fromOffset(12, 55),
    Size = UDim2.new(1, -24, 0, 220),
    BackgroundTransparency = 1
}, Sidebar)

Create("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Nav)

-- Sidebar footer

local Footer = Create("Frame", {
    Position = UDim2.new(0, 12, 1, -65),
    Size = UDim2.new(1, -24, 0, 48),
    BackgroundColor3 = Config.Card,
    BorderSizePixel = 0
}, Sidebar)

Corner(Footer, 9)

Create("TextLabel", {
    Position = UDim2.fromOffset(12, 5),
    Size = UDim2.new(1, -20, 0, 17),
    BackgroundTransparency = 1,
    Text = "DEVELOPER",
    TextColor3 = Config.Gray,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
}, Footer)

Create("TextLabel", {
    Position = UDim2.fromOffset(12, 22),
    Size = UDim2.new(1, -20, 0, 17),
    BackgroundTransparency = 1,
    Text = Config.Author,
    TextColor3 = Config.White,
    Font = Enum.Font.GothamMedium,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left
}, Footer)

--========================================
-- CONTENT
--========================================

local Content = Create("Frame", {
    Position = UDim2.fromOffset(190, 52),
    Size = UDim2.new(1, -190, 1, -52),
    BackgroundTransparency = 1
}, Main)

local Header = Create("Frame", {
    Position = UDim2.fromOffset(25, 20),
    Size = UDim2.new(1, -50, 0, 65),
    BackgroundTransparency = 1
}, Content)

local PageTitle = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundTransparency = 1,
    Text = "Dashboard",
    TextColor3 = Config.White,
    Font = Enum.Font.GothamBold,
    TextSize = 23,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

local PageSubtitle = Create("TextLabel", {
    Position = UDim2.fromOffset(1, 36),
    Size = UDim2.new(1, 0, 0, 22),
    BackgroundTransparency = 1,
    Text = "Welcome back to your workspace.",
    TextColor3 = Config.Gray,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

--========================================
-- HERO CARD
--========================================

local Hero = Create("Frame", {
    Position = UDim2.fromOffset(25, 105),
    Size = UDim2.new(1, -50, 0, 135),
    BackgroundColor3 = Color3.fromRGB(85, 53, 150),
    BorderSizePixel = 0,
    ClipsDescendants = true
}, Content)

Corner(Hero, 13)
Gradient(Hero,
    Color3.fromRGB(111, 69, 205),
    Color3.fromRGB(46, 36, 88),
    15
)

Create("Frame", {
    Position = UDim2.new(1, -115, 0, -70),
    Size = UDim2.fromOffset(190, 190),
    BackgroundColor3 = Config.PurpleLight,
    BackgroundTransparency = 0.88,
    BorderSizePixel = 0
}, Hero)

local HeroText = Create("TextLabel", {
    Position = UDim2.fromOffset(22, 23),
    Size = UDim2.new(1, -40, 0, 35),
    BackgroundTransparency = 1,
    Text = "Welcome to " .. Config.Name,
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Hero)

Create("TextLabel", {
    Position = UDim2.fromOffset(23, 62),
    Size = UDim2.new(1, -50, 0, 35),
    BackgroundTransparency = 1,
    Text = "Your workspace is ready. Start building something amazing.",
    TextColor3 = Color3.fromRGB(220, 208, 255),
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left
}, Hero)

Create("TextLabel", {
    Position = UDim2.fromOffset(23, 101),
    Size = UDim2.fromOffset(100, 20),
    BackgroundTransparency = 1,
    Text = "VERSION " .. Config.Version,
    TextColor3 = Color3.fromRGB(225, 211, 255),
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Hero)

--========================================
-- EMPTY WORKSPACE
--========================================

local Workspace = Create("Frame", {
    Position = UDim2.fromOffset(25, 257),
    Size = UDim2.new(1, -50, 1, -282),
    BackgroundColor3 = Config.Card,
    BorderSizePixel = 0
}, Content)

Corner(Workspace, 12)
Stroke(Workspace, Config.Border, 0.3)

local EmptyIcon = Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, -30),
    Size = UDim2.fromOffset(48, 48),
    BackgroundColor3 = Color3.fromRGB(57, 43, 91),
    BorderSizePix
