-- [[ FFLAG INJECT ]]
local function applyFFlags()
    local flags = {
        ["DFIntMaxFrameBufferSize"]="4",["DFIntInterpolationDtLimitForLod"]="5",
        ["DFIntInterpolationNumMechanismsPerTask"]="5",["DFIntInterpolationNumParallelTasks"]="5",
        ["DFIntMaxInterpolationRecursionsBeforeCheck"]="1",["FIntInterpolationMaxDelayMSec"]="35",
        ["DFIntInterpolationFrameRotVelocityThresholdMillionth"]="1",["DFIntInterpolationFrameVelocityThresholdMillionth"]="1",
        ["DFIntInterpolationMinAssemblyCount"]="1",["DFIntNumFramesToKeepAfterInterpolation"]="1",
        ["DFIntInterpolationNumMechanismsBatchSize"]="1",["DFIntInterpolationFramePositionThresholdMillionth"]="1",
        ["FFlagRobloxInputUsesRuntime2"]="true",["FFlagFasterPreciseTime5"]="true",
        ["FIntActivatedCountTimerMSKeyboard"]="0",["FIntDefaultJitterN"]="0",
        ["DFIntMaxAcceptableUpdateDelay"]="150",["DFIntAuroraServerInputBufferSize"]="1",
        ["DFIntAuroraClientInputBufferSize"]="1",["DFIntServerAutomaticNetworkOwnershipBufferMs"]="0",
        ["FIntMaquettesFrameRateBufferPercentage"]="0",["DFIntTaskSchedulerTargetFps"]="999",
        ["FFlagTaskSchedulerLimitTargetFps"]="False",["FFlagLargeReplicatorEnabled2"]="True",
        ["FFlagLargeReplicatorRead2"]="True",["FFlagLargeReplicatorWrite2"]="True",
        ["FFlagNextGenReplicatorEnabledRead"]="True",["FFlagNextGenReplicatorEnabledWrite"]="True",
    }
    local function m(z) return z:gsub("^DFInt",""):gsub("^DFFlag",""):gsub("FString",""):gsub("FLog",""):gsub("^FFlag",""):gsub("^DFint",""):gsub("^FInt","") end
    if setfflag then
        for k,v in pairs(flags) do pcall(function()
            if getfflag(m(k)) then setfflag(m(k),v) elseif getfflag(k) then setfflag(k,v) end
        end) end
    end
end

-- [[ CUSTOM UI ]]
local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player       = Players.LocalPlayer

local BG       = Color3.fromRGB(18, 18, 22)
local SURFACE  = Color3.fromRGB(26, 26, 32)
local ELEVATED = Color3.fromRGB(34, 34, 42)
local ACCENT   = Color3.fromRGB(99, 102, 241)
local ACCENT2  = Color3.fromRGB(79, 82, 221)
local TEXT     = Color3.fromRGB(240, 240, 245)
local SUBTEXT  = Color3.fromRGB(150, 150, 165)
local SUCCESS  = Color3.fromRGB(52, 211, 153)
local DANGER   = Color3.fromRGB(239, 68, 68)
local BORDER   = Color3.fromRGB(50, 50, 62)

local function make(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end
local function corner(r, p)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end
local function stroke(thickness, color, p)
    local s = Instance.new("UIStroke"); s.Thickness = thickness; s.Color = color; s.Parent = p
end
local function padding(top, right, bottom, left, p)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, top); pad.PaddingRight = UDim.new(0, right)
    pad.PaddingBottom = UDim.new(0, bottom); pad.PaddingLeft = UDim.new(0, left)
    pad.Parent = p
end

-- Notification system
local notifGui = make("ScreenGui", {Name="BraveHubNotifs", IgnoreGuiInset=true, ResetOnSpawn=false, Parent=player:WaitForChild("PlayerGui")})
local notifHolder = make("Frame", {Size=UDim2.new(0,280,1,0), Position=UDim2.new(1,-290,0,0), BackgroundTransparency=1, Parent=notifGui})
make("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,8), VerticalAlignment=Enum.VerticalAlignment.Bottom, Parent=notifHolder})
padding(0,0,16,0,notifHolder)

local function notify(title, msg, ntype)
    local col = ntype == "success" and SUCCESS or ntype == "error" and DANGER or ACCENT
    local card = make("Frame", {Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y, BackgroundColor3=SURFACE, ClipsDescendants=true, Parent=notifHolder})
    corner(8, card); stroke(1, col, card)
    make("Frame", {Size=UDim2.new(0,3,1,0), BackgroundColor3=col, Parent=card})
    local inner = make("Frame", {Size=UDim2.new(1,-11,1,0), Position=UDim2.new(0,11,0,0), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y, Parent=card})
    padding(10,10,10,0,inner)
    make("TextLabel", {Size=UDim2.new(1,0,0,16), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, Text=title, TextColor3=TEXT, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=inner})
    make("TextLabel", {Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,0,20), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, Text=msg, TextColor3=SUBTEXT, Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, Parent=inner})
    task.delay(3.5, function()
        TweenService:Create(card, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
        task.wait(0.3); card:Destroy()
    end)
end

-- Main GUI
local screenGui = make("ScreenGui", {Name="BraveHub", IgnoreGuiInset=true, ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=player:WaitForChild("PlayerGui")})
local window = make("Frame", {Size=UDim2.new(0,480,0,520), Position=UDim2.new(0.5,-240,0.5,-260), BackgroundColor3=BG, BorderSizePixel=0, Parent=screenGui})
corner(12, window); stroke(1, BORDER, window)

make("ImageLabel", {
    Size=UDim2.new(1,30,1,30), Position=UDim2.new(0,-15,0,-15), BackgroundTransparency=1,
    Image="rbxassetid://5554236805", ImageColor3=Color3.fromRGB(0,0,0), ImageTransparency=0.6,
    ScaleType=Enum.ScaleType.Slice, SliceCenter=Rect.new(23,23,277,277), ZIndex=0, Parent=window
})

local titlebar = make("Frame", {Size=UDim2.new(1,0,0,46), BackgroundColor3=SURFACE, Parent=window})
corner(12, titlebar)
make("Frame", {Size=UDim2.new(1,0,0,12), Position=UDim2.new(0,0,1,-12), BackgroundColor3=SURFACE, BorderSizePixel=0, Parent=titlebar})
local titleDot = make("Frame", {Size=UDim2.new(0,8,0,8), Position=UDim2.new(0,16,0.5,-4), BackgroundColor3=ACCENT, Parent=titlebar})
corner(4, titleDot)
make("TextLabel", {Size=UDim2.new(0,200,1,0), Position=UDim2.new(0,32,0,0), BackgroundTransparency=1, Text="Brave Hub", TextColor3=TEXT, Font=Enum.Font.GothamBold, TextSize=15, TextXAlignment=Enum.TextXAlignment.Left, Parent=titlebar})
make("TextLabel", {Size=UDim2.new(0,120,1,0), Position=UDim2.new(1,-130,0,0), BackgroundTransparency=1, Text="Press K to toggle", TextColor3=SUBTEXT, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Right, Parent=titlebar})

local dragging, dragStart, startPos = false, nil, nil
titlebar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true; dragStart=i.Position; startPos=window.Position end
end)
titlebar.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)

local tabRow = make("Frame", {Size=UDim2.new(1,-24,0,32), Position=UDim2.new(0,12,0,52), BackgroundColor3=ELEVATED, Parent=window})
corner(8, tabRow)
make("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,4), Parent=tabRow})
padding(4,4,4,4,tabRow)

local contentArea = make("Frame", {Size=UDim2.new(1,-24,1,-102), Position=UDim2.new(0,12,0,92), BackgroundTransparency=1, Parent=window})
local toggleValues = {}

local function makePage()
    local page = make("ScrollingFrame", {
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, ScrollBarThickness=3,
        ScrollBarImageColor3=ACCENT, BorderSizePixel=0, CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false, Parent=contentArea
    })
    make("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6), Parent=page})
    return page
end

local function makeSection(name, page)
    local lbl = make("TextLabel", {
        Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, Text=name:upper(),
        TextColor3=ACCENT, Font=Enum.Font.GothamBold, TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=page
    })
    padding(0,0,0,2,lbl)
end

local function makeButton(label, desc, page, callback)
    local row = make("Frame", {Size=UDim2.new(1,0,0,52), BackgroundColor3=SURFACE, Parent=page})
    corner(8, row); stroke(1, BORDER, row); padding(0,10,0,12,row)
    make("TextLabel", {Size=UDim2.new(1,-80,0,20), Position=UDim2.new(0,0,0,8), BackgroundTransparency=1, Text=label, TextColor3=TEXT, Font=Enum.Font.GothamSemibold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    if desc and desc ~= "" then
        make("TextLabel", {Size=UDim2.new(1,-80,0,16), Position=UDim2.new(0,0,0,28), BackgroundTransparency=1, Text=desc, TextColor3=SUBTEXT, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    end
    local btn = make("TextButton", {Size=UDim2.new(0,70,0,28), Position=UDim2.new(1,-70,0.5,-14), BackgroundColor3=ACCENT, Text="Run", TextColor3=TEXT, Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=false, Parent=row})
    corner(6, btn)
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=ACCENT2}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=ACCENT}):Play() end)
    btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

local function makeToggle(label, desc, flag, page, callback)
    toggleValues[flag] = false
    local row = make("Frame", {Size=UDim2.new(1,0,0,52), BackgroundColor3=SURFACE, Parent=page})
    corner(8, row); stroke(1, BORDER, row); padding(0,10,0,12,row)
    make("TextLabel", {Size=UDim2.new(1,-60,0,20), Position=UDim2.new(0,0,0,8), BackgroundTransparency=1, Text=label, TextColor3=TEXT, Font=Enum.Font.GothamSemibold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    if desc and desc ~= "" then
        make("TextLabel", {Size=UDim2.new(1,-60,0,16), Position=UDim2.new(0,0,0,28), BackgroundTransparency=1, Text=desc, TextColor3=SUBTEXT, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    end
    local track = make("Frame", {Size=UDim2.new(0,40,0,22), Position=UDim2.new(1,-40,0.5,-11), BackgroundColor3=ELEVATED, Parent=row})
    corner(11, track); stroke(1, BORDER, track)
    local knob = make("Frame", {Size=UDim2.new(0,16,0,16), Position=UDim2.new(0,3,0.5,-8), BackgroundColor3=SUBTEXT, Parent=track})
    corner(8, knob)
    local function setToggle(val)
        toggleValues[flag] = val
        TweenService:Create(track,TweenInfo.new(0.15),{BackgroundColor3=val and ACCENT or ELEVATED}):Play()
        TweenService:Create(knob,TweenInfo.new(0.15),{Position=val and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8), BackgroundColor3=val and TEXT or SUBTEXT}):Play()
        pcall(callback, val)
    end
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then setToggle(not toggleValues[flag]) end end)
end

-- Global guard: only one keybind box listens at a time
local globalListening = {active = false}

local function makeKeybindBox(labelText, defaultKey, defaultKeyName, parent, yOffset)
    local state = {keyCode = defaultKey, keyName = defaultKeyName, listening = false}
    make("TextLabel", {
        Size=UDim2.new(0,72,0,14), Position=UDim2.new(0,0,0,yOffset+4),
        BackgroundTransparency=1, Text=labelText,
        TextColor3=SUBTEXT, Font=Enum.Font.Gotham, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=parent
    })
    local box = make("TextButton", {
        Size=UDim2.new(0,60,0,22), Position=UDim2.new(0,76,0,yOffset),
        BackgroundColor3=ELEVATED, Text=defaultKeyName,
        TextColor3=TEXT, Font=Enum.Font.GothamBold, TextSize=12,
        AutoButtonColor=false, Parent=parent
    })
    corner(6, box); stroke(1, BORDER, box)
    box.MouseButton1Click:Connect(function()
        if globalListening.active then return end
        globalListening.active = true; state.listening = true
        box.Text = "..."; TweenService:Create(box,TweenInfo.new(0.1),{BackgroundColor3=ACCENT}):Play()
    end)
    UIS.InputBegan:Connect(function(input, gp)
        if not state.listening then return end
        if gp then return end
        local name = input.KeyCode.Name
        if name and name ~= "Unknown" then
            state.listening = false; globalListening.active = false
            state.keyCode = input.KeyCode; state.keyName = name
            box.Text = name
            TweenService:Create(box,TweenInfo.new(0.1),{BackgroundColor3=ELEVATED}):Play()
            notify("Keybind", labelText .. " → " .. name, "success")
        end
    end)
    return state
end

-- Tab management
local tabs = {}
local function switchTab(name)
    for n, t in pairs(tabs) do
        t.page.Visible = (n == name)
        TweenService:Create(t.btn,TweenInfo.new(0.15),{
            BackgroundColor3=(n==name) and ACCENT or Color3.fromRGB(0,0,0),
            BackgroundTransparency=(n==name) and 0 or 1,
            TextColor3=(n==name) and TEXT or SUBTEXT
        }):Play()
    end
end

local function addTab(name)
    local page = makePage()
    local btn = make("TextButton", {
        Size=UDim2.new(0,90,1,0), BackgroundColor3=Color3.fromRGB(0,0,0), BackgroundTransparency=1,
        Text=name, TextColor3=SUBTEXT, Font=Enum.Font.GothamSemibold, TextSize=12,
        AutoButtonColor=false, Parent=tabRow
    })
    corner(6, btn)
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    tabs[name] = {page=page, btn=btn}
    return page
end

-- =============================================
-- BUILD TABS
-- =============================================
local mainPage = addTab("Main")
local perfPage = addTab("Performance")

-- MAIN TAB
makeSection("Optimization & Networking", mainPage)

makeButton("Re-Apply Delay Reducer", "Re-injects FFlags into the session", mainPage, function()
    applyFFlags()
    notify("Delay Reducer", "FFlags have been re-injected.", "success")
end)

makeButton("Enable Ping Spoofer", "Toggle with Right Shift after injecting", mainPage, function()
    local pl = game.Players.LocalPlayer
    local uisvc = game:GetService("UserInputService")
    if pl.PlayerGui:FindFirstChild("ShiftF3_Stats") then notify("Ping Spoofer","Already injected!","error"); return end
    local gui = Instance.new("ScreenGui")
    gui.Name="ShiftF3_Stats"; gui.IgnoreGuiInset=true; gui.ResetOnSpawn=true; gui.DisplayOrder=999; gui.Enabled=false; gui.Parent=pl:WaitForChild("PlayerGui")
    local bg = Instance.new("Frame")
    bg.Parent=gui; bg.AnchorPoint=Vector2.new(0,1); bg.Position=UDim2.new(0,50,1,-41)
    bg.Size=UDim2.new(0,425,0,514); bg.BackgroundColor3=Color3.fromRGB(0,0,0); bg.BackgroundTransparency=0.45; bg.BorderSizePixel=0

    local txtShadow = Instance.new("TextLabel")
    txtShadow.Parent=bg; txtShadow.Position=UDim2.new(0,7,0,0); txtShadow.Size=UDim2.new(1,-20,1,-16)
    txtShadow.BackgroundTransparency=1; txtShadow.TextXAlignment=Enum.TextXAlignment.Left; txtShadow.TextYAlignment=Enum.TextYAlignment.Top
    txtShadow.TextWrapped=false; txtShadow.RichText=true; txtShadow.TextSize=17; txtShadow.LineHeight=1
    txtShadow.Text=""; txtShadow.TextColor3=Color3.fromRGB(0,0,0)
    txtShadow.TextTransparency=0.55; txtShadow.TextStrokeTransparency=1
    txtShadow.ZIndex=1
    txtShadow.FontFace=Font.new("rbxasset://fonts/families/RobotoMono.json")

    local txt = Instance.new("TextLabel")
    txt.Parent=bg; txt.Position=UDim2.new(0,5,0,-1); txt.Size=UDim2.new(1,-20,1,-16)
    txt.BackgroundTransparency=1; txt.TextXAlignment=Enum.TextXAlignment.Left; txt.TextYAlignment=Enum.TextYAlignment.Top
    txt.TextWrapped=false; txt.RichText=true; txt.TextSize=17; txt.LineHeight=1
    txt.TextColor3=Color3.fromRGB(210,210,210)
    txt.TextStrokeTransparency=1
    txt.ZIndex=2
    txt.FontFace=Font.new("rbxasset://fonts/families/RobotoMono.json")

    local currentPing = 32.00
    local lastStatTick = 0
    local inData     = {0.42, 8.60, 37.50}
    local inDataKBtick   = 0
    local inDataKBdelay  = 3 + math.random()
    local inDataPkttick  = 0
    local inDataPktdelay = 1 + math.random()
    local incPhys    = {0.13, 0.70, 55.35, 4.78}
    local physTick   = 0
    local physDelay  = 12 + math.random()*3
    local physSubCount = 0
    local physSubTick  = 0
    local physSubDelay = 0
    local physInCycle  = false
    local lastRootPos  = nil
    local incTouch   = {0.02, 0.60, 30.00}
    local touchTick  = 0
    local touchDelay = 9
    local incOverall = {0.80, 9.20}
    local outData    = {0.38, 8.50, 47.80}
    local outDataKBtick  = 0
    local outDataKBdelay = 3 + math.random()
    local outDataPkttick = 0
    local outDataPktdelay= 1 + math.random()
    local outPhys    = {0.08, 1.20, 47.50}
    local outTouch   = {0.03, 0.80, 32.00}
    local outTouchTick = 0
    local outTouchDelay= 7
    local lastRenderTick = tick()

    local function updateDisplay()
        local B = "#b3e8ff"
        local G = "#C0C0C0"
        local W = "#ffffff"
        local overallOut = outData[1] + outPhys[1] + outTouch[1] + (math.random()*0.04)
        txt.Text="<b>"..string.format([[
<font color="%s">----- HTTP -----</font>
<font color="%s">Request Queue Size: </font><font color="%s">0</font>
<font color="%s">----- Replicator -----</font>
<font color="%s">General  (MTU Size, Data Ping):</font>
<font color="%s">    1200, %.2fms, StreamingEnabled: Off</font>
<font color="%s">----- Incoming -----</font>
<font color="%s">Overall (KB/s, Pkt/s, Queue):</font>
<font color="%s">    %.2f, %.2f, 0</font>
<font color="%s">In Data (KB/s, Pkt/s, Avg Size):</font>
<font color="%s">    %.2f, %.2f, %.2fB</font>
<font color="%s">In ISR (KB/s, Pkt/s, Avg Size):</font>
<font color="%s">    0.00, 0.00, 0.00B</font>
<font color="%s">In LR (KB/s, Pkt/s, Avg Size):</font>
<font color="%s">    0.00, 0.00, 0.00B</font>
<font color="%s">In Physics (KB/s, Pkt/s, Avg Size, Avg Lag):</font>
<font color="%s">    %.2f, %.2f, %.2fB, %.2f</font>
<font color="%s">In Touches (KB/s, Pkt/s, Avg Size):</font>
<font color="%s">    %.2f, %.2f, %.2fB</font>
<font color="%s">In Clusters (KB/s, Pkt/s, Avg Size):</font>
<font color="%s">    0.00, 0.00, 0.00B</font>
<font color="%s">----- Outgoing -----</font>
<font color="%s">Overall (KB/s): </font><font color="%s">%.2f</font>
<font color="%s">Out Data (KB/s, Pkt/s, Avg Size, Throttle):</font>
<font color="%s">    %.2f, %.2f, %.2fB, 0.00%%</font>
<font color="%s">Out Physics (KB/s, Pkt/s, Avg Size, Throttle):</font>
<font color="%s">    %.2f, %.2f, %.2fB, 0.00%%</font>
<font color="%s">Out Touches (KB/s, Pkt/s, Avg Size, #Waiting):</font>
<font color="%s">    %.2f, %.2f, %.2fB, 0</font>
<font color="%s">Out Clusters (KB/s, Pkt/s, Avg Size):</font>
<font color="%s">    0.00, 0.00, 0.00B</font>
]],
        B, G, W, B, G, W, currentPing,
        B, G, W, incOverall[1], incOverall[2],
        G, W, inData[1], inData[2], inData[3],
        G, W, G, W,
        G, W, incPhys[1], incPhys[2], incPhys[3], incPhys[4],
        G, W, incTouch[1], incTouch[2], incTouch[3],
        G, W, B, G, W, overallOut,
        G, W, outData[1], outData[2], outData[3],
        G, W, outPhys[1], outPhys[2], outPhys[3],
        G, W, outTouch[1], outTouch[2], outTouch[3],
        G, W
        ).."</b>"
        txtShadow.Text = txt.Text:gsub('<font color="[^"]*">', ''):gsub('</font>', '')
    end

    uisvc.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.KeyCode==Enum.KeyCode.RightShift then gui.Enabled=not gui.Enabled end
    end)

    task.spawn(function()
        while true do
            local now = tick()
            local dt = now - lastRenderTick
            lastRenderTick = now
            if gui.Enabled then
                currentPing = 29 + (math.random()*6)
                local isMoving = false
                pcall(function()
                    local char = pl.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local curPos = hrp.Position
                        if lastRootPos then
                            local moved = (curPos - lastRootPos).Magnitude
                            if moved > 0.08 then isMoving = true end
                        end
                        lastRootPos = curPos
                    end
                end)
                if now - inDataKBtick >= inDataKBdelay then
                    inData[1] = 0.28 + math.random()*0.32
                    inDataKBtick = now; inDataKBdelay = 3 + math.random()
                end
                if now - inDataPkttick >= inDataPktdelay then
                    inData[2] = 7.80 + math.random()*1.60
                    inDataPkttick = now; inDataPktdelay = 1 + math.random()
                end
                if now - lastStatTick >= 1 then
                    inData[3] = 30.00 + math.random()*12.00
                end
                if isMoving then
                    if not physInCycle then
                        if now - physTick >= physDelay then
                            physInCycle = true; physSubCount = 0
                            physSubTick = now; physSubDelay = 0.18
                            physTick = now; physDelay = 12 + math.random()*3
                        end
                    else
                        if physSubCount < 7 then
                            if now - physSubTick >= physSubDelay then
                                incPhys[1] = 0.13 + math.random()*0.70
                                incPhys[2] = 0.70 + math.random()*14.33
                                incPhys[3] = 55.35
                                incPhys[4] = 4.78 + math.random()*17.36
                                physSubCount = physSubCount + 1
                                physSubTick = now; physSubDelay = 0.12 + math.random()*0.10
                            end
                        else
                            physInCycle = false
                        end
                    end
                end
                if now - touchTick >= touchDelay then
                    incTouch[1] = 0.01 + math.random()*0.04
                    incTouch[2] = 0.40 + math.random()*0.80
                    incTouch[3] = 24.00 + math.random()*14.00
                    touchTick = now; touchDelay = 9
                end
                if now - lastStatTick >= 1 then
                    incOverall[1] = inData[1] + incPhys[1] + incTouch[1] + math.random()*0.15
                    incOverall[2] = 8.00 + math.random()*3.00
                    if now - outDataKBtick >= outDataKBdelay then
                        outData[1] = 0.25 + math.random()*0.28
                        outDataKBtick = now; outDataKBdelay = 3 + math.random()
                    end
                    if now - outDataPkttick >= outDataPktdelay then
                        outData[2] = 7.80 + math.random()*1.50
                        outDataPkttick = now; outDataPktdelay = 1 + math.random()
                    end
                    outData[3] = 44.00 + math.random()*6.00
                    outPhys[1] = 0.04 + math.random()*0.14
                    outPhys[2] = 0.80 + math.random()*1.70
                    outPhys[3] = 46.00 + math.random()*3.00
                    if now - outTouchTick >= outTouchDelay then
                        outTouch[1] = 0.01 + math.random()*0.05
                        outTouch[2] = 0.30 + math.random()*0.90
                        outTouch[3] = 28.00 + math.random()*14.00
                        outTouchTick = now; outTouchDelay = 7
                    end
                    lastStatTick = now
                end
                updateDisplay()
            end
            task.wait(0.8)
        end
    end)
    notify("Ping Spoofer","Injected! Press Right Shift to toggle.","success")
end)

makeSection("Character Enhancements", mainPage)

makeToggle("No Kick CD","Removes kick cooldown","NoKickCD",mainPage,function(val)
    getgenv().NoKickCD=val
    task.spawn(function()
        while getgenv().NoKickCD do
            pcall(function()
                local char=game.Players.LocalPlayer.Character
                local kick=char and char:FindFirstChild("Status") and char.Status:FindFirstChild("KickCD")
                if kick then kick:Destroy() end
            end)
            task.wait()
        end
    end)
end)

makeToggle("Infinite Stamina","Keeps stamina at 100","InfStam",mainPage,function(val)
    getgenv().InfStam=val
    task.spawn(function()
        while getgenv().InfStam do
            pcall(function()
                local char=game.Players.LocalPlayer.Character
                local s=char and char:FindFirstChild("Stats")
                if s then
                    if s:FindFirstChild("Stamina") then s.Stamina.Value=100 end
                    if s:FindFirstChild("StaminaCheck") then s.StaminaCheck.Value=100 end
                end
            end)
            task.wait()
        end
    end)
end)

makeSection("Gameplay Automation", mainPage)

-- [[ AUTO COUNTER ]]
do
    getgenv().AutoCounterLoaded  = getgenv().AutoCounterLoaded  or false
    getgenv().AutoCounterKey     = getgenv().AutoCounterKey     or Enum.KeyCode.Q
    getgenv().AutoCounterKeyName = getgenv().AutoCounterKeyName or "Q"

    local row = make("Frame", {Size=UDim2.new(1,0,0,80), BackgroundColor3=SURFACE, Parent=mainPage})
    corner(8, row); stroke(1, BORDER, row); padding(0,10,0,12,row)
    make("TextLabel", {Size=UDim2.new(1,-160,0,18), Position=UDim2.new(0,0,0,6), BackgroundTransparency=1, Text="Auto Counter", TextColor3=TEXT, Font=Enum.Font.GothamSemibold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    make("TextLabel", {Size=UDim2.new(1,-160,0,14), Position=UDim2.new(0,0,0,26), BackgroundTransparency=1, Text="Toggle: H", TextColor3=SUBTEXT, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    local acKeyState = makeKeybindBox("Counter Key:", getgenv().AutoCounterKey, getgenv().AutoCounterKeyName, row, 50)
    local btn = make("TextButton", {Size=UDim2.new(0,70,0,28), Position=UDim2.new(1,-70,0.5,-14), BackgroundColor3=ACCENT, Text="Load", TextColor3=TEXT, Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=false, Parent=row})
    corner(6, btn)
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=ACCENT2}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=ACCENT}):Play() end)
    btn.MouseButton1Click:Connect(function()
        if getgenv().AutoCounterLoaded then notify("Auto Counter","Already loaded!","error"); return end
        getgenv().AutoCounterLoaded = true
        task.spawn(function()
            local Pl=game:GetService("Players"); local VIM=game:GetService("VirtualInputManager")
            local RS=game:GetService("RunService"); local UIS2=game:GetService("UserInputService")
            local lp=Pl.LocalPlayer
            local char=lp.Character or lp.CharacterAdded:Wait()
            local hrp=char:WaitForChild("HumanoidRootPart")
            local on=false
            local targetAnims={"rbxassetid://18865205163","18865205163","rbxassetid://18865209727","18865209727","rbxassetid://15556188381","15556188381","rbxassetid://15556189685","15556189685"}
            local lastPress=0; local cooldown=0.5
            local function hasBall()
                local ok,r=pcall(function()
                    local b=workspace:FindFirstChild("Temp")
                    if b then b=b:FindFirstChild("Ball") if b then local h=b:FindFirstChild("PossessionHighlight") if h and h:IsA("Highlight") then return true end end end
                    return false
                end)
                return ok and r
            end
            local function hasAnim(otherChar)
                local function check(anim)
                    if not anim then return false end
                    for _,t in pairs(anim:GetPlayingAnimationTracks()) do
                        if t.IsPlaying then
                            local id=tostring(t.Animation.AnimationId); local num=string.match(id,"%d+")
                            for _,tid in pairs(targetAnims) do
                                if num==string.match(tid,"%d+") then return true end
                                if id==tid or id:find(tid) then return true end
                            end
                        end
                    end
                    return false
                end
                local hum=otherChar:FindFirstChildOfClass("Humanoid")
                if hum and check(hum:FindFirstChildOfClass("Animator")) then return true end
                local ctrl=otherChar:FindFirstChildOfClass("AnimationController")
                if ctrl and check(ctrl:FindFirstChildOfClass("Animator")) then return true end
                return false
            end
            local function pressKey()
                local now=tick(); if now-lastPress<cooldown then return end; lastPress=now
                VIM:SendKeyEvent(true,acKeyState.keyCode,false,game); task.wait(0.05); VIM:SendKeyEvent(false,acKeyState.keyCode,false,game)
            end
            UIS2.InputBegan:Connect(function(i,gp)
                if gp then return end
                if i.KeyCode==Enum.KeyCode.H then on=not on; notify("Auto Counter",on and "ENABLED" or "DISABLED",on and "success" or "error") end
            end)
            lp.CharacterAdded:Connect(function(nc) char=nc; hrp=char:WaitForChild("HumanoidRootPart") end)
            RS.Heartbeat:Connect(function()
                if not on or not hasBall() then return end
                if not char or not char.Parent then char=lp.Character if char then hrp=char:WaitForChild("HumanoidRootPart") else return end end
                if not hrp or not hrp.Parent then return end
                for _,op in pairs(Pl:GetPlayers()) do
                    if op~=lp and op.Character then
                        local or2=op.Character:FindFirstChild("HumanoidRootPart")
                        if or2 and (hrp.Position-or2.Position).Magnitude<=20 and hasAnim(op.Character) then pressKey(); break end
                    end
                end
            end)
        end)
        notify("Auto Counter","Loaded! Press H to toggle.","success")
    end)
end

-- [[ AUTO POWERSHOT (Low Bins / Top Bins / Volley) ]]
do
    getgenv().AutoPowershotLoaded  = getgenv().AutoPowershotLoaded  or false
    getgenv().PSLowKey             = getgenv().PSLowKey             or Enum.KeyCode.Y
    getgenv().PSLowKeyName         = getgenv().PSLowKeyName         or "Y"
    getgenv().PSTopKey             = getgenv().PSTopKey             or Enum.KeyCode.T
    getgenv().PSTopKeyName         = getgenv().PSTopKeyName         or "T"
    getgenv().PSVolleyKey          = getgenv().PSVolleyKey          or Enum.KeyCode.G
    getgenv().PSVolleyKeyName      = getgenv().PSVolleyKeyName      or "G"

    local row = make("Frame", {Size=UDim2.new(1,0,0,136), BackgroundColor3=SURFACE, Parent=mainPage})
    corner(8, row); stroke(1, BORDER, row); padding(0,10,0,12,row)

    make("TextLabel", {Size=UDim2.new(1,-160,0,18), Position=UDim2.new(0,0,0,6), BackgroundTransparency=1, Text="Auto Powershot", TextColor3=TEXT, Font=Enum.Font.GothamSemibold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    make("TextLabel", {Size=UDim2.new(1,-160,0,14), Position=UDim2.new(0,0,0,26), BackgroundTransparency=1, Text="Low / Top Bins (One-shot) + Volley (Toggle)", TextColor3=SUBTEXT, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})

    local psLowKeyState    = makeKeybindBox("Low Bins:",  getgenv().PSLowKey,    getgenv().PSLowKeyName,    row, 48)
    local psTopKeyState    = makeKeybindBox("Top Bins:",  getgenv().PSTopKey,    getgenv().PSTopKeyName,    row, 76)
    local psVolleyKeyState = makeKeybindBox("Volley:",    getgenv().PSVolleyKey, getgenv().PSVolleyKeyName, row, 104)

    local btn = make("TextButton", {Size=UDim2.new(0,70,0,28), Position=UDim2.new(1,-70,0.5,-14), BackgroundColor3=ACCENT, Text="Load", TextColor3=TEXT, Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=false, Parent=row})
    corner(6, btn)
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=ACCENT2}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=ACCENT}):Play() end)
    btn.MouseButton1Click:Connect(function()
        if getgenv().AutoPowershotLoaded then notify("Auto Powershot","Already loaded!","error"); return end
        getgenv().AutoPowershotLoaded = true
        task.spawn(function()
            local RS2  = game:GetService("ReplicatedStorage")
            local RS   = game:GetService("RunService")
            local UIS2 = game:GetService("UserInputService")
            local WS   = game:GetService("Workspace")

            -- [[ BIN-BASED AIM SETUP ]]
            local allBins = {}

            local function createBins(goalPart, offsetValue, prefix)
                local goalSize = goalPart.Size
                local goalCFrame = goalPart.CFrame
                local positions = {
                    ["TopLeft"]     = Vector3.new( goalSize.X/2.2,   goalSize.Y/2.2,  offsetValue),
                    ["TopRight"]    = Vector3.new(-goalSize.X/2.3,   goalSize.Y/2.2,  offsetValue),
                    ["BottomLeft"]  = Vector3.new( goalSize.X/2.2,  -goalSize.Y/2.3,  offsetValue),
                    ["BottomRight"] = Vector3.new(-goalSize.X/2.3,  -goalSize.Y/2.3,  offsetValue),
                }
                local binFolder = WS:FindFirstChild("Bins") or (function()
                    local f = Instance.new("Folder"); f.Name = "Bins"; f.Parent = WS; return f
                end)()
                for name, offset in pairs(positions) do
                    local partName = prefix .. "_" .. name
                    local bin = binFolder:FindFirstChild(partName)
                    local isNew = not bin
                    if isNew then bin = Instance.new("Part"); bin.Name = partName end
                    bin.Size = Vector3.new(0.6, 0.6, 0.6)
                    bin.Anchored = true
                    bin.CanCollide = false
                    bin.Transparency = 1
                    bin.CastShadow = false
                    bin.CFrame = goalCFrame * CFrame.new(offset)
                    if isNew then bin.Parent = binFolder; table.insert(allBins, bin) end
                end
            end

            local detectionFolder = WS:WaitForChild("Detection")
            local goalAway = detectionFolder:WaitForChild("goalDetectionAway")
            local goalHome = detectionFolder:WaitForChild("goalDetectionHome")
            createBins(goalAway,  6, "Away")
            createBins(goalHome, -6, "Home")

            local function getVolleyTarget(root)
                local charPos = root.Position
                local distToAway = (charPos - goalAway.Position).Magnitude
                local distToHome = (charPos - goalHome.Position).Magnitude
                local targetPrefix = (distToAway < distToHome) and "Away_" or "Home_"
                local validTargets = {}
                for _, bin in ipairs(allBins) do
                    if bin and bin.Parent and string.sub(bin.Name, 1, #targetPrefix) == targetPrefix then
                        table.insert(validTargets, bin)
                    end
                end
                if #validTargets > 0 then
                    return validTargets[math.random(1, #validTargets)].Position
                end
                return nil
            end
            -- [[ END BIN-BASED AIM ]]

            local ps = {
                volleyEnabled=false, toggleDebounce=false,
                lastActivation=0, TRIGGER_DISTANCE=6, COOLDOWN=1.5,
                leftLegAnimId="rbxassetid://15434792076",
                rightLegAnimId="rbxassetid://15434790443",
                inputConn=nil, renderConn=nil,
            }

            local function getGoalboxPoints()
                local field  = WS:WaitForChild("gameArea"):WaitForChild("Field")
                local awayGB = field:WaitForChild("GoalboxAway")
                local homeGB = field:WaitForChild("GoalboxHome")
                local offsets = {
                    ["TOP RIGHT"]=Vector3.new(3.8,0,0),   ["TOP LEFT"]=Vector3.new(-3.8,0,0),
                    ["BOTTOM RIGHT"]=Vector3.new(3.8,-3.8,0), ["BOTTOM LEFT"]=Vector3.new(-3.8,-3.8,0),
                }
                local nameMap = {
                    ["awayTOP RIGHT"]="awayTopRight",   ["awayTOP LEFT"]="awayTopLeft",
                    ["awayBOTTOM RIGHT"]="awayBottomRight", ["awayBOTTOM LEFT"]="awayBottomLeft",
                    ["homeTOP RIGHT"]="homeTopRight",   ["homeTOP LEFT"]="homeTopLeft",
                    ["homeBOTTOM RIGHT"]="homeBottomRight", ["homeBOTTOM LEFT"]="homeBottomLeft",
                }
                local all = {}
                for _, pair in pairs({{"away",awayGB},{"home",homeGB}}) do
                    local prefix, gb = pair[1], pair[2]
                    for cname, offset in pairs(offsets) do
                        local obj = gb:WaitForChild(cname)
                        all[nameMap[prefix..cname]] = {obj=obj, pos=obj.Position+offset}
                    end
                end
                return all
            end

            local function getPowershotTarget(root, isTop)
                local all      = getGoalboxPoints()
                local awayDist = (all.awayTopRight.obj.Position - root.Position).Magnitude
                local homeDist = (all.homeTopRight.obj.Position - root.Position).Magnitude
                local prefix   = awayDist < homeDist and "away" or "home"
                local lc = all[prefix..(isTop and "TopLeft"    or "BottomLeft")]
                local rc = all[prefix..(isTop and "TopRight"   or "BottomRight")]
                if not lc or not rc then return nil end
                local cam=WS.CurrentCamera; local ld=cam.CFrame.LookVector; local cp=cam.CFrame.Position
                local la=(lc.pos-(cp+ld*(lc.pos-cp):Dot(ld))).Magnitude
                local ra=(rc.pos-(cp+ld*(rc.pos-cp):Dot(ld))).Magnitude
                return la < ra and lc or rc
            end

            local function getBallSide(hrp, ball)
                if not hrp or not ball then return "Right" end
                return (ball.Position - hrp.Position):Dot(hrp.CFrame.RightVector) > 0 and "Right" or "Left"
            end

            local function playAnimation(character, side)
                local hum = character:FindFirstChildOfClass("Humanoid"); if not hum then return end
                local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
                local anim = Instance.new("Animation")
                anim.AnimationId = side == "Left" and ps.leftLegAnimId or ps.rightLegAnimId
                animator:LoadAnimation(anim):Play()
            end

            local function flickCameraTo(targetPos)
                local cam=WS.CurrentCamera; local s=cam.CFrame; local e=CFrame.lookAt(cam.CFrame.Position,targetPos)
                for i=1,4 do cam.CFrame=s:Lerp(e,i/4); task.wait() end
            end

            local function execute()
                local Knit       = require(RS2.Packages.Knit)
                local kickRemote = Knit.GetService("KeyHandlerService"):GetKey("Kick")

                ps.inputConn = UIS2.InputBegan:Connect(function(input, gp2)
                    if gp2 or ps.toggleDebounce then return end

                    if input.KeyCode == psLowKeyState.keyCode then
                        local character = player.Character; if not character then return end
                        local root = character:FindFirstChild("HumanoidRootPart"); if not root then return end
                        local temp = WS:FindFirstChild("Temp")
                        local ball = temp and temp:FindFirstChild("Ball")
                        local targetGoal = getPowershotTarget(root, false)
                        if not targetGoal then notify("Auto Low Bins","Target goal not found!","error"); return end
                        task.spawn(function()
                            flickCameraTo(targetGoal.pos)
                            local direction = (targetGoal.pos - root.Position).Unit * 200
                            local side = getBallSide(root, ball)
                            kickRemote:FireServer(direction, ball, false, true, 100, side, root.CFrame, {}, false, false)
                            local hum = character:FindFirstChildOfClass("Humanoid")
                            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                            playAnimation(character, side)
                        end)
                        notify("Auto Low Bins", "Fired!", "success")

                    elseif input.KeyCode == psTopKeyState.keyCode then
                        local character = player.Character; if not character then return end
                        local root = character:FindFirstChild("HumanoidRootPart"); if not root then return end
                        local temp = WS:FindFirstChild("Temp")
                        local ball = temp and temp:FindFirstChild("Ball")
                        local targetGoal = getPowershotTarget(root, true)
                        if not targetGoal then notify("Auto Top Bins","Target goal not found!","error"); return end
                        task.spawn(function()
                            flickCameraTo(targetGoal.pos)
                            local direction = (targetGoal.pos - root.Position).Unit * 200
                            local side = getBallSide(root, ball)
                            kickRemote:FireServer(direction, ball, false, true, 100, side, root.CFrame, {}, false, false)
                            local hum = character:FindFirstChildOfClass("Humanoid")
                            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                            playAnimation(character, side)
                        end)
                        notify("Auto Top Bins", "Fired!", "success")

                    elseif input.KeyCode == psVolleyKeyState.keyCode then
                        ps.toggleDebounce = true; ps.volleyEnabled = not ps.volleyEnabled
                        notify("Auto Volley", ps.volleyEnabled and "ENABLED (Waiting for ball)" or "DISABLED", ps.volleyEnabled and "success" or "error")
                        task.delay(0.25, function() ps.toggleDebounce = false end)
                    end
                end)

                ps.renderConn = RS.RenderStepped:Connect(function()
                    if not ps.volleyEnabled then return end
                    local now = tick(); if now - ps.lastActivation < ps.COOLDOWN then return end
                    local character = player.Character; if not character then return end
                    local hum  = character:FindFirstChildOfClass("Humanoid")
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if not root or not hum then return end
                    local temp = WS:FindFirstChild("Temp"); local ball = temp and temp:FindFirstChild("Ball")
                    if not ball then return end
                    if (ball.Position - root.Position).Magnitude > ps.TRIGGER_DISTANCE then return end
                    ps.lastActivation = now

                    -- Use bin-based aim for volley
                    local targetPos = getVolleyTarget(root)
                    if not targetPos then return end

                    flickCameraTo(targetPos)
                    local direction = (targetPos - root.Position).Unit * 200
                    local side = getBallSide(root, ball)
                    kickRemote:FireServer(direction, ball, false, true, 100, side, root.CFrame, {}, false, false)
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    playAnimation(character, side)
                    ps.volleyEnabled = false
                    notify("Auto Volley", "Fired and DISABLED", "success")
                end)
            end

            local function cleanup()
                if ps.inputConn  then ps.inputConn:Disconnect(); ps.inputConn  = nil end
                if ps.renderConn then ps.renderConn:Disconnect(); ps.renderConn = nil end
                ps.volleyEnabled=false; ps.toggleDebounce=false
            end

            execute()
            player.CharacterAdded:Connect(function() cleanup(); task.wait(1); execute() end)
        end)
        notify("Auto Powershot","Loaded!  Low:"..psLowKeyState.keyName.."  Top:"..psTopKeyState.keyName.."  Volley:"..psVolleyKeyState.keyName,"success")
    end)
end

-- [[ AUTO DIVE ]]
makeButton("Load Auto Dive", "Toggle Dive: V | Pre-dive: Q", mainPage, function()
    if getgenv().AutoDiveLoaded then notify("Auto Dive","Already loaded!","error"); return end
    getgenv().AutoDiveLoaded = true
    task.spawn(function()
        local ACTIVATION_KEY = Enum.KeyCode.V
        local PRE_DIVE_KEY   = Enum.KeyCode.Q
        local RunService = game:GetService("RunService")
        local Workspace = game:GetService("Workspace")
        local Players = game:GetService("Players")
        local VirtualInputManager = game:GetService("VirtualInputManager")
        local UserInputService = game:GetService("UserInputService")
        local StarterGui = game:GetService("StarterGui")
        local Player = Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local RootPart = Character:WaitForChild("HumanoidRootPart")
        local function Notify(title, text)
            pcall(function()
                StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 2})
            end)
        end
        local CONFIG = {
            Enabled = true, ShowVisuals = false, MinBallVelocity = 10,
            SidewaysPreDiveRadius = 5, PreDiveKeyHold = 0.08,
            DelayMidDive = 0.02, DelayHighDive = 0.13,
            TimeThresholdFar = 0.32, TimeThresholdMidFar = 0.23, TimeThresholdMid = 0.2,
            Height_Split_LowMid = -1.0, Height_Split_MidHigh = 3,
            ReachX = 40, ReachY = 25, BallRadius = 1.0, BounceElasticity = 0.7,
            Gravity = Vector3.new(0, -workspace.Gravity, 0),
            Keys = {Left = Enum.KeyCode.A, Right = Enum.KeyCode.D, Jump = Enum.KeyCode.Space}
        }
        local DiveCooldown = false
        local ActivationEnabled = false
        local PreDiveEnabled = false
        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == ACTIVATION_KEY then
                ActivationEnabled = not ActivationEnabled
                Notify("Auto Dive", ActivationEnabled and "ENABLED" or "DISABLED")
            end
            if input.KeyCode == PRE_DIVE_KEY then
                PreDiveEnabled = not PreDiveEnabled
                Notify("Pre-Dive", PreDiveEnabled and "ENABLED" or "DISABLED")
            end
        end)
        local function PerformDive(Direction, Mode, ShouldPreDive)
            if DiveCooldown then return end
            DiveCooldown = true
            local holdKey = nil
            if Direction == "Right" then holdKey = CONFIG.Keys.Right
            elseif Direction == "Left" then holdKey = CONFIG.Keys.Left end
            if ShouldPreDive then
                task.spawn(function()
                    VirtualInputManager:SendKeyEvent(true, PRE_DIVE_KEY, false, game)
                    task.wait(CONFIG.PreDiveKeyHold)
                    VirtualInputManager:SendKeyEvent(false, PRE_DIVE_KEY, false, game)
                end)
            end
            task.spawn(function()
                if holdKey then VirtualInputManager:SendKeyEvent(true, holdKey, false, game) end
                if Mode == "High" then
                    VirtualInputManager:SendKeyEvent(true, CONFIG.Keys.Jump, false, game)
                    task.wait(CONFIG.DelayHighDive)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 1)
                elseif Mode == "Mid" then
                    VirtualInputManager:SendKeyEvent(true, CONFIG.Keys.Jump, false, game)
                    task.wait(CONFIG.DelayMidDive)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 1)
                elseif Mode == "Low" then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 1)
                end
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 1)
                if Mode ~= "Low" then VirtualInputManager:SendKeyEvent(false, CONFIG.Keys.Jump, false, game) end
                if holdKey then VirtualInputManager:SendKeyEvent(false, holdKey, false, game) end
                task.wait(0.8)
                DiveCooldown = false
            end)
        end
        local function GetReactionThreshold(sidewaysDist)
            local DistCenter, DistFar = 4.0, 16.0
            if sidewaysDist >= DistFar then return CONFIG.TimeThresholdFar end
            if sidewaysDist <= DistCenter then return CONFIG.TimeThresholdMid end
            local alpha = (sidewaysDist - DistCenter) / (DistFar - DistCenter)
            return CONFIG.TimeThresholdMid + (CONFIG.TimeThresholdFar - CONFIG.TimeThresholdMid) * alpha
        end
        local function Update()
            if not CONFIG.Enabled or not RootPart then return end
            if not ActivationEnabled then return end
            local Ball = Workspace:FindFirstChild("Temp") and Workspace.Temp:FindFirstChild("Ball")
            if not Ball then Ball = Workspace:FindFirstChild("Ball") end
            if not Ball then return end
            local currentVel = Ball.AssemblyLinearVelocity
            if currentVel.Magnitude < CONFIG.MinBallVelocity then return end
            local externalAcc = Vector3.zero
            local mfObj = Ball:FindFirstChildWhichIsA("VectorForce", true)
            if mfObj and mfObj.Enabled then
                local rawForce = mfObj.Force
                if mfObj.RelativeTo == Enum.ActuatorRelativeTo.Attachment0 and mfObj.Attachment0 then
                    rawForce = mfObj.Attachment0.WorldCFrame:VectorToWorldSpace(rawForce)
                elseif mfObj.RelativeTo == Enum.ActuatorRelativeTo.Attachment1 and mfObj.Attachment1 then
                    rawForce = mfObj.Attachment1.WorldCFrame:VectorToWorldSpace(rawForce)
                end
                externalAcc = rawForce / Ball.AssemblyMass
            end
            local simPos = Ball.Position
            local simVel = currentVel
            local stepDt = 0.015
            local rootCF = RootPart.CFrame
            local lastRelZ = rootCF:PointToObjectSpace(simPos).Z
            for i = 1, 100 do
                local oldPos = simPos
                local oldRelZ = lastRelZ
                simVel += (CONFIG.Gravity + externalAcc) * stepDt
                simPos += simVel * stepDt
                if simPos.Y < CONFIG.BallRadius then
                    simPos = Vector3.new(simPos.X, CONFIG.BallRadius, simPos.Z)
                    simVel = Vector3.new(simVel.X, -simVel.Y * CONFIG.BounceElasticity, simVel.Z)
                end
                local relPos = rootCF:PointToObjectSpace(simPos)
                if (oldRelZ * relPos.Z) <= 0 then
                    local alpha = math.abs(oldRelZ) / math.max(math.abs(oldRelZ - relPos.Z), 0.0001)
                    local impactPos = oldPos:Lerp(simPos, alpha)
                    local relImpact = rootCF:PointToObjectSpace(impactPos)
                    local impactTime = (i - 1 + alpha) * stepDt
                    if relImpact.Y > -5 and relImpact.Y < CONFIG.ReachY and math.abs(relImpact.X) < CONFIG.ReachX
                        and impactTime <= GetReactionThreshold(math.abs(relImpact.X)) then
                        local mode = "Low"
                        if relImpact.Y >= CONFIG.Height_Split_LowMid and relImpact.Y <= CONFIG.Height_Split_MidHigh then mode = "Mid"
                        elseif relImpact.Y > CONFIG.Height_Split_MidHigh then mode = "High" end
                        local dir = "Center"
                        if relImpact.X > 2.5 then dir = "Right"
                        elseif relImpact.X < -2.5 then dir = "Left" end
                        local shouldPreDive = PreDiveEnabled and math.abs(relImpact.X) > CONFIG.SidewaysPreDiveRadius
                        PerformDive(dir, mode, shouldPreDive)
                    end
                    break
                end
                lastRelZ = relPos.Z
            end
        end
        RunService.RenderStepped:Connect(Update)
    end)
    notify("Auto Dive", "Loaded! Toggle Dive: V | Pre-dive: Q", "success")
end)

makeButton("Load Infinite Zoom","Toggle: B",mainPage,function()
    if getgenv().InfiniteZoomLoaded then return end
    getgenv().InfiniteZoomLoaded=true
    local lp=game.Players.LocalPlayer; local on=false
    game:GetService("UserInputService").InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.KeyCode==Enum.KeyCode.B then on=not on; lp.CameraMaxZoomDistance=on and 99999 or 100; notify("Zoom",on and "Infinite zoom ON" or "Default zoom restored",on and "success" or "error") end
    end)
    notify("Infinite Zoom","Loaded! Press B to toggle.","success")
end)

makeSection("Visuals & Tracking", mainPage)

-- [[ SECURE ESP ]]
do
    local espEnabled = false
    local row = make("Frame", {Size=UDim2.new(1,0,0,80), BackgroundColor3=SURFACE, Parent=mainPage})
    corner(8, row); stroke(1, BORDER, row); padding(0,10,0,12,row)
    make("TextLabel", {Size=UDim2.new(1,-160,0,18), Position=UDim2.new(0,0,0,6), BackgroundTransparency=1, Text="Secure Ball ESP", TextColor3=TEXT, Font=Enum.Font.GothamSemibold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    local espKeyState = makeKeybindBox("Toggle Key:", Enum.KeyCode.U, "U", row, 50)
    local btn = make("TextButton", {Size=UDim2.new(0,70,0,28), Position=UDim2.new(1,-70,0.5,-14), BackgroundColor3=ACCENT, Text="Load", TextColor3=TEXT, Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=false, Parent=row})
    corner(6, btn)
    local loaded = false
    btn.MouseButton1Click:Connect(function()
        if loaded then notify("ESP","Already loaded!","error"); return end
        loaded = true
        task.spawn(function()
            local Workspace = game:GetService("Workspace")
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local highlight = nil

            local function getBall()
                local temp = Workspace:FindFirstChild("Temp")
                local ball = temp and temp:FindFirstChild("Ball")
                if not ball then ball = Workspace:FindFirstChild("Ball") end
                if not ball then ball = Workspace:FindFirstChild("Ball", true) end
                return ball
            end

            local function cleanCompetingHighlights(ballPath)
                if not ballPath then return end
                for _, child in ipairs(ballPath:GetChildren()) do
                    if child:IsA("Highlight") and child.Name ~= "SecureBallHighlight" then
                        child:Destroy()
                    end
                end
            end

            local function applyHighlight(ballPath)
                if not ballPath then return end
                cleanCompetingHighlights(ballPath)
                if not highlight or not highlight:IsDescendantOf(game) then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "SecureBallHighlight"
                    highlight.FillColor = Color3.fromRGB(0, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Adornee = ballPath
                    highlight.Parent = ballPath
                    highlight.Enabled = espEnabled
                else
                    if highlight.Adornee ~= ballPath then highlight.Adornee = ballPath end
                    if highlight.Parent ~= ballPath then highlight.Parent = ballPath end
                    if highlight.DepthMode ~= Enum.HighlightDepthMode.AlwaysOnTop then highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end
                    highlight.Enabled = espEnabled
                end
            end

            UserInputService.InputBegan:Connect(function(input, isTyping)
                if isTyping then return end
                if input.KeyCode == espKeyState.keyCode then
                    espEnabled = not espEnabled
                    if highlight then highlight.Enabled = espEnabled end
                    notify("Secure ESP", espEnabled and "ENABLED" or "DISABLED", espEnabled and "success" or "error")
                end
            end)

            RunService.Heartbeat:Connect(function()
                local ballPath = getBall()
                if not ballPath then return end
                if espEnabled and not ballPath:FindFirstChild("SecureBallHighlight") then
                    applyHighlight(ballPath)
                elseif espEnabled then
                    cleanCompetingHighlights(ballPath)
                end
            end)
            
            Workspace.DescendantAdded:Connect(function(child)
                if espEnabled and child:IsA("Highlight") and child.Name ~= "SecureBallHighlight" and child.Parent == getBall() then
                    child:Destroy()
                    applyHighlight(getBall())
                end
            end)
        end)
        notify("Secure ESP", "Loaded! Press " .. espKeyState.keyName .. " to toggle.", "success")
    end)
end

-- [[ PREDICTIVE LOCK ]]
do
    local row = make("Frame", {Size=UDim2.new(1,0,0,80), BackgroundColor3=SURFACE, Parent=mainPage})
    corner(8, row); stroke(1, BORDER, row); padding(0,10,0,12,row)
    make("TextLabel", {Size=UDim2.new(1,-160,0,18), Position=UDim2.new(0,0,0,6), BackgroundTransparency=1, Text="Predictive Lock", TextColor3=TEXT, Font=Enum.Font.GothamSemibold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    local lockKeyState = makeKeybindBox("Toggle Key:", Enum.KeyCode.J, "J", row, 50)
    local btn = make("TextButton", {Size=UDim2.new(0,70,0,28), Position=UDim2.new(1,-70,0.5,-14), BackgroundColor3=ACCENT, Text="Load", TextColor3=TEXT, Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=false, Parent=row})
    corner(6, btn)
    local loaded = false
    btn.MouseButton1Click:Connect(function()
        if loaded then notify("Predictive Lock","Already loaded!","error"); return end
        loaded = true
        task.spawn(function()
            local Workspace = game:GetService("Workspace")
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local camera = Workspace.CurrentCamera
            local LOOK_AHEAD_TIME = 0.15
            local lockEnabled = false

            local function getBall()
                local temp = Workspace:FindFirstChild("Temp")
                local ball = temp and temp:FindFirstChild("Ball")
                if not ball then ball = Workspace:FindFirstChild("Ball") end
                if not ball then ball = Workspace:FindFirstChild("Ball", true) end
                return ball
            end

            UserInputService.InputBegan:Connect(function(input, isTyping)
                if isTyping then return end
                if input.KeyCode == lockKeyState.keyCode then
                    lockEnabled = not lockEnabled
                    notify("Predictive Lock", lockEnabled and "ENABLED (Aiming Ahead)" or "DISABLED", lockEnabled and "success" or "error")
                end
            end)

            RunService.RenderStepped:Connect(function()
                if not lockEnabled then return end
                local ball = getBall()
                if not ball or not ball:IsA("BasePart") then return end
                local startPos = ball.Position
                local velocity = ball.AssemblyLinearVelocity
                local gravity = Vector3.new(0, -Workspace.Gravity, 0) 
                local predictedPos = startPos + (velocity * LOOK_AHEAD_TIME) + (0.5 * gravity * LOOK_AHEAD_TIME * LOOK_AHEAD_TIME)
                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, predictedPos)
            end)
        end)
        notify("Predictive Lock", "Loaded! Press " .. lockKeyState.keyName .. " to toggle.", "success")
    end)
end

-- [[ BALL PREDICTOR ]]
do
    local row = make("Frame", {Size=UDim2.new(1,0,0,80), BackgroundColor3=SURFACE, Parent=mainPage})
    corner(8, row); stroke(1, BORDER, row); padding(0,10,0,12,row)
    make("TextLabel", {Size=UDim2.new(1,-160,0,18), Position=UDim2.new(0,0,0,6), BackgroundTransparency=1, Text="Ball Predictor (Path)", TextColor3=TEXT, Font=Enum.Font.GothamSemibold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    local predKeyState = makeKeybindBox("Toggle Key:", Enum.KeyCode.P, "P", row, 50)
    local btn = make("TextButton", {Size=UDim2.new(0,70,0,28), Position=UDim2.new(1,-70,0.5,-14), BackgroundColor3=ACCENT, Text="Load", TextColor3=TEXT, Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=false, Parent=row})
    corner(6, btn)
    local loaded = false
    btn.MouseButton1Click:Connect(function()
        if loaded then notify("Ball Predictor","Already loaded!","error"); return end
        loaded = true
        task.spawn(function()
            local Workspace = game:GetService("Workspace")
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local camera = Workspace.CurrentCamera
            local PREDICTION_TIME = 1.5
            local POINTS_COUNT = 20
            local DOT_COLOR = Color3.fromRGB(0, 255, 100)
            local DOT_SIZE = Vector3.new(0.25, 0.25, 0.25)
            local predictorEnabled = false
            local dotPool = {}

            local function getOrCreateDot(index)
                if dotPool[index] then return dotPool[index] end
                local dot = Instance.new("Part")
                dot.Name = "PredictorDot_" .. index
                dot.Shape = Enum.PartType.Ball
                dot.Size = DOT_SIZE
                dot.Color = DOT_COLOR
                dot.Material = Enum.Material.Neon
                dot.Anchored = true
                dot.CanCollide = false
                dot.CanTouch = false
                dot.CanQuery = false
                dot.Parent = camera
                dotPool[index] = dot
                return dot
            end

            local function getBall()
                local temp = Workspace:FindFirstChild("Temp")
                local ball = temp and temp:FindFirstChild("Ball")
                if not ball then ball = Workspace:FindFirstChild("Ball") end
                if not ball then ball = Workspace:FindFirstChild("Ball", true) end
                return ball
            end

            UserInputService.InputBegan:Connect(function(input, isTyping)
                if isTyping then return end
                if input.KeyCode == predKeyState.keyCode then
                    predictorEnabled = not predictorEnabled
                    notify("Ball Predictor", predictorEnabled and "ENABLED" or "DISABLED", predictorEnabled and "success" or "error")
                    if not predictorEnabled then
                        for _, dot in pairs(dotPool) do dot.Transparency = 1 end
                    end
                end
            end)

            RunService.RenderStepped:Connect(function()
                if not predictorEnabled then return end
                local ball = getBall()
                if not ball or not ball:IsA("BasePart") then
                    for _, dot in pairs(dotPool) do dot.Transparency = 1 end
                    return
                end
                local startPos = ball.Position
                local velocity = ball.AssemblyLinearVelocity
                local gravity = Vector3.new(0, -Workspace.Gravity, 0) 
                local timeStep = PREDICTION_TIME / POINTS_COUNT
                for i = 1, POINTS_COUNT do
                    local t = i * timeStep
                    local predictedPos = startPos + (velocity * t) + (0.5 * gravity * t * t)
                    local dot = getOrCreateDot(i)
                    dot.CFrame = CFrame.new(predictedPos)
                    dot.Transparency = 0
                end
            end)
        end)
        notify("Ball Predictor", "Loaded! Press " .. predKeyState.keyName .. " to toggle.", "success")
    end)
end

-- [[ LAST DICE (AUTO BLOCK) ]]
do
    local row = make("Frame", {Size=UDim2.new(1,0,0,80), BackgroundColor3=SURFACE, Parent=mainPage})
    corner(8, row); stroke(1, BORDER, row); padding(0,10,0,12,row)
    make("TextLabel", {Size=UDim2.new(1,-160,0,18), Position=UDim2.new(0,0,0,6), BackgroundTransparency=1, Text="Last Dice (Auto Block)", TextColor3=TEXT, Font=Enum.Font.GothamSemibold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
    local ldKeyState = makeKeybindBox("Hold Key:", Enum.KeyCode.T, "T", row, 50)
    local btn = make("TextButton", {Size=UDim2.new(0,70,0,28), Position=UDim2.new(1,-70,0.5,-14), BackgroundColor3=ACCENT, Text="Load", TextColor3=TEXT, Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=false, Parent=row})
    corner(6, btn)
    local loaded = false
    btn.MouseButton1Click:Connect(function()
        if loaded then notify("Last Dice","Already loaded!","error"); return end
        loaded = true
        task.spawn(function()
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local VirtualInputManager = game:GetService("VirtualInputManager")
            local Workspace = game:GetService("Workspace")
            local player = Players.LocalPlayer

            local SHARED_CFG = {
                AbilityKey = Enum.KeyCode.V, JumpKey = Enum.KeyCode.Space,
                MinBallVelocity = 80, Gravity = Vector3.new(0, -workspace.Gravity, 0),
                SequenceDelay = 0.05, BallRadius = 1.0, BounceElasticity = 0.7, MaxBlockHeight = 35
            }
            local LAST_DICE_CFG = { Radius = 32, ReactionTime = 0.95 }
            local lastDiceEnabled = true
            local blockCooldown = false

            local function performDiceSequence(relImpact)
                if blockCooldown then return end
                blockCooldown = true
                task.spawn(function()
                    local camera = workspace.CurrentCamera
                    local isGoingRight = relImpact.X > 0
                    local angle = isGoingRight and -math.rad(90) or math.rad(90)
                    camera.CFrame = camera.CFrame * CFrame.Angles(0, angle, 0)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(true, SHARED_CFG.AbilityKey, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, SHARED_CFG.AbilityKey, false, game)
                    task.wait(SHARED_CFG.SequenceDelay)
                    VirtualInputManager:SendKeyEvent(true, SHARED_CFG.JumpKey, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, SHARED_CFG.JumpKey, false, game)
                    task.wait(0.7)
                    blockCooldown = false
                end)
            end

            local function runPhysicsSim(config, onImpact)
                local character = player.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                local ball = Workspace:FindFirstChild("Temp") and Workspace.Temp:FindFirstChild("Ball") or Workspace:FindFirstChild("Ball")
                if not rootPart or not ball then return end
                local currentVel = ball.AssemblyLinearVelocity
                if currentVel.Magnitude < SHARED_CFG.MinBallVelocity then return end
                local externalAcc = Vector3.zero
                local mfObj = ball:FindFirstChildWhichIsA("VectorForce", true)
                if mfObj and mfObj.Enabled then
                    local rawForce = mfObj.Force
                    if mfObj.RelativeTo == Enum.ActuatorRelativeTo.Attachment0 and mfObj.Attachment0 then
                        rawForce = mfObj.Attachment0.WorldCFrame:VectorToWorldSpace(rawForce)
                    end
                    externalAcc = rawForce / ball.AssemblyMass
                end
                local simPos, simVel = ball.Position, currentVel
                local rootCF = rootPart.CFrame
                local lastRelZ = rootCF:PointToObjectSpace(simPos).Z

                for i = 1, 75 do
                    local oldPos = simPos
                    simVel = simVel + ((SHARED_CFG.Gravity + externalAcc) * 0.015)
                    simPos = simPos + (simVel * 0.015)
                    if simPos.Y < SHARED_CFG.BallRadius then
                        simPos = Vector3.new(simPos.X, SHARED_CFG.BallRadius, simPos.Z)
                        simVel = Vector3.new(simVel.X, -simVel.Y * SHARED_CFG.BounceElasticity, simVel.Z)
                    end
                    local curRel = rootCF:PointToObjectSpace(simPos)
                    if (lastRelZ * curRel.Z) <= 0 then
                        local alpha = (math.abs(lastRelZ) / (math.abs(lastRelZ) + math.abs(curRel.Z)))
                        local exactImpactPos = oldPos:Lerp(simPos, alpha)
                        local relImpact = rootCF:PointToObjectSpace(exactImpactPos)
                        local impactTime = (i - 1 + alpha) * 0.015
                        if (exactImpactPos - rootPart.Position).Magnitude <= config.Radius then
                            if impactTime <= config.ReactionTime and relImpact.Y < SHARED_CFG.MaxBlockHeight then
                                onImpact(relImpact)
                            end
                        end
                        break
                    end
                    lastRelZ = curRel.Z
                end
            end

            RunService.RenderStepped:Connect(function()
                if lastDiceEnabled and UserInputService:IsKeyDown(ldKeyState.keyCode) then
                    runPhysicsSim(LAST_DICE_CFG, performDiceSequence)
                end
            end)
        end)
        notify("Last Dice", "Loaded! Hold " .. ldKeyState.keyName .. " to use.", "success")
    end)
end

-- PERFORMANCE TAB
makeSection("FPS Boost", perfPage)
local _applied = false
local _origData = {}

makeButton("Apply FPS Boost","Strips textures, reflections & shadows",perfPage,function()
    if _applied then notify("FPS Boost","Already applied! Revert first.","error"); return end
    _origData={}
    local lighting=game:GetService("Lighting")
    _origData["__lighting"]={GlobalShadows=lighting.GlobalShadows,Brightness=lighting.Brightness,FogEnd=lighting.FogEnd,FogStart=lighting.FogStart,ShadowSoftness=lighting.ShadowSoftness}
    lighting.GlobalShadows=false; lighting.Brightness=2; lighting.FogEnd=100000; lighting.FogStart=100000; lighting.ShadowSoftness=0
    _origData["__fxlist"]={}
    for _,fx in pairs(lighting:GetChildren()) do
        if fx:IsA("PostEffect") or fx:IsA("Sky") or fx:IsA("Atmosphere") or fx:IsA("BloomEffect") or fx:IsA("BlurEffect") or fx:IsA("ColorCorrectionEffect") or fx:IsA("DepthOfFieldEffect") or fx:IsA("SunRaysEffect") then
            table.insert(_origData["__fxlist"],{inst=fx,parent=fx.Parent}); fx.Parent=nil
        end
    end
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("SpecialMesh") then _origData[v]={TextureId=v.TextureId}; v.TextureId=""
        elseif v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
            _origData[v]={Material=v.Material,Reflectance=v.Reflectance,CastShadow=v.CastShadow}
            v.Material=Enum.Material.Plastic; v.Reflectance=0; v.CastShadow=false
        elseif v:IsA("Decal") or v:IsA("Texture") then _origData[v]={Transparency=v.Transparency}; v.Transparency=1
        elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then _origData[v]={Enabled=v.Enabled}; v.Enabled=false
        end
    end
    _applied=true; notify("FPS Boost","Applied. Shadows, effects & textures removed.","success")
end)

makeButton("Revert FPS Boost","Restores original visuals",perfPage,function()
    if not _applied then notify("FPS Boost","Nothing to revert.","error"); return end
    local lighting=game:GetService("Lighting")
    if _origData["__lighting"] then
        local l=_origData["__lighting"]
        lighting.GlobalShadows=l.GlobalShadows; lighting.Brightness=l.Brightness
        lighting.FogEnd=l.FogEnd; lighting.FogStart=l.FogStart; lighting.ShadowSoftness=l.ShadowSoftness
    end
    if _origData["__fxlist"] then for _,e in pairs(_origData["__fxlist"]) do pcall(function() e.inst.Parent=e.parent end) end end
    for inst,data in pairs(_origData) do
        if inst=="__lighting" or inst=="__fxlist" then continue end
        pcall(function()
            if inst:IsA("SpecialMesh") then inst.TextureId=data.TextureId
            elseif inst:IsA("Part") or inst:IsA("MeshPart") or inst:IsA("UnionOperation") then inst.Material=data.Material; inst.Reflectance=data.Reflectance; inst.CastShadow=data.CastShadow
            elseif inst:IsA("Decal") or inst:IsA("Texture") then inst.Transparency=data.Transparency
            elseif inst:IsA("ParticleEmitter") or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles") then inst.Enabled=data.Enabled
            end
        end)
    end
    _origData={}; _applied=false; notify("FPS Boost","Reverted successfully.","success")
end)

-- Init
switchTab("Main")
UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode==Enum.KeyCode.K then window.Visible=not window.Visible end
end)
notify("Brave Hub","Loaded. Press K to toggle.","success")
