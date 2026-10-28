--// Japan HUB ー Rayfield (vortex.txt Exact Copy)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local service = setmetatable({}, {__index=function(self,k) local s=game:GetService(k) rawset(self,k,s) return s end})
local localPlayer = service.Players.LocalPlayer

local CreateGrabLine = service.ReplicatedStorage.GrabEvents:WaitForChild("CreateGrabLine")
local DestroyGrabLine = service.ReplicatedStorage.GrabEvents:WaitForChild("DestroyGrabLine")
local SetNetworkOwner = service.ReplicatedStorage.GrabEvents:WaitForChild("SetNetworkOwner")
local MenuToys = service.ReplicatedStorage:WaitForChild("MenuToys")
local SpawnToyRemoteFunction = MenuToys:WaitForChild("SpawnToyRemoteFunction")

local SpawnedInToys = service.Workspace:WaitForChild(localPlayer.Name .. "SpawnedInToys")

local Config = {
    PlayerList = {},
    aa6 = false, aa9 = 25, aa13 = false, aa17 = false, aa73 = nil,
    running = false,
}

local function JapanNotify(Message)
    Rayfield:Notify({ Title = "Japan HUB", Content = Message, Duration = 4, Image = 4483362458 })
end

local function spawntoy(name, cframe, vector3)
    SpawnToyRemoteFunction:InvokeServer(name, cframe, vector3 or Vector3.zero)
    return SpawnedInToys and SpawnedInToys[name]
end

local function GetCharacter()
    return localPlayer.Character
end

local Window = Rayfield:CreateWindow({
    Name = "Japan HUB",
    LoadingTitle = "Japan HUB",
    LoadingSubtitle = "Pallet Kick",
    Theme = "Default",
    ToggleUIKeybind = "K",
    KeySystem = false,
})

local MainTab = Window:CreateTab("Pallet Kick", 4483362458)

-- ===== ターゲット選択 =====
local TargetOptions = {}
local TargetMap = {}

local function UpdateTargetOptions()
    TargetOptions = {"(なし)"}
    TargetMap = {}
    for _, p in ipairs(service.Players:GetPlayers()) do
        if p ~= localPlayer then
            local display = p.DisplayName
            table.insert(TargetOptions, display)
            TargetMap[display] = p
        end
    end
end
UpdateTargetOptions()

local TargetDropdown = MainTab:CreateDropdown({
    Name = "Select Target",
    Options = TargetOptions,
    CurrentOption = {"(なし)"},
    MultipleOptions = false,
    Flag = "TargetSelect",
    Callback = function(option)
        local val = option[1]
        local p = TargetMap[val]
        Config.PlayerList = p and {p.Name} or {}
    end,
})

MainTab:CreateButton({
    Name = "Refresh Target List",
    Callback = function()
        UpdateTargetOptions()
        TargetDropdown:Refresh(TargetOptions)
        JapanNotify("リスト更新完了。")
    end,
})

-- ===== 板キック本体（vortex.txt完全コピペ） =====
MainTab:CreateToggle({
    Name = "Kick spam (Ragdoll & Lag)",
    CurrentValue = false,
    Flag = "KickSpam",
    Callback = function(aa61)
        Config.aa6 = aa61
        Config.aa13 = aa61
        if aa61 then
            if not Config.PlayerList or #Config.PlayerList == 0 then
                JapanNotify("ターゲットを選べ。")
                Config.aa6 = false Config.aa13 = false
                return
            end
        end
        
        local function aa31(aa32, aa33, aa34)
            return aa32:FindFirstChild(aa33) or aa32:WaitForChild(aa33, aa34 or 5)
        end
        
        local function aa35(aa36)
            if aa36 and aa36:IsA("BasePart") then
                SetNetworkOwner:FireServer(aa36, aa36.CFrame)
                task.wait()
            end
        end
        
        local function aa37(aa38, aa39)
            return aa38:FindFirstChild(aa39) ~= nil
        end
        
        local function aa40(aa41)
            local aa42 = GetCharacter()
            if not aa42 then return nil end
            local aa43 = aa42:WaitForChild("HumanoidRootPart")
            local waitCount = 0
            while (localPlayer.InPlot.Value and not localPlayer.InOwnedPlot.Value) and waitCount < 50 do
                task.wait(0.1)
                waitCount = waitCount + 1
            end
            waitCount = 0
            while not localPlayer.CanSpawnToy.Value and waitCount < 50 do
                task.wait(0.1)
                waitCount = waitCount + 1
            end
            local aa44 = aa43.CFrame * CFrame.new(0, 14, 20)
            local aa45 = workspace:FindFirstChild(localPlayer.Name.."SpawnedInToys")
            if not aa45 then
                aa45 = workspace:FindFirstChild("PlotItems")
                if aa45 then
                    aa45 = aa45:FindFirstChild("Plot1")
                end
            end
            if not aa45 then
                aa45 = workspace
            end
            local aa46 = nil
            local aa47 = aa45.ChildAdded:Connect(function(aa48)
                if aa48.Name == aa41 then
                    aa46 = aa48
                end
            end)
            task.spawn(function()
                pcall(function()
                    spawntoy(aa41, aa44, Vector3.zero)
                end)
            end)
            local aa49 = tick()
            repeat task.wait(0.05) until aa46 or (tick() - aa49) > 5
            aa47:Disconnect()
            return aa46
        end
        
        local function aa50()
            if Config.aa17 then return nil end
            Config.aa17 = true
            local aa51 = aa40("PalletLightBrown")
            if not aa51 then
                Config.aa17 = false
                return nil
            end
            local aa52 = aa31(aa51, "SoundPart", 3)
            if not aa52 then
                aa51:Destroy()
                Config.aa17 = false
                return nil
            end
            local retryCount = 0
            while retryCount < 10 do
                if not Config.aa13 then
                    aa51:Destroy()
                    Config.aa17 = false
                    return nil
                end
                aa35(aa52)
                task.wait()
                if aa37(aa52, "PartOwner") then
                    break
                end
                retryCount = retryCount + 1
            end
            if not aa37(aa52, "PartOwner") then
                aa51:Destroy()
                Config.aa17 = false
                return nil
            end            
            for _, aa54 in pairs(aa51:GetDescendants()) do
                if aa54:IsA("BasePart") then
                    aa54.CanCollide = false
                    aa54.Transparency = 0.8
                end
            end
            aa51.Name = "RagdollPalete"
            local aa55 = Instance.new("BodyVelocity")
            aa55.MaxForce = Vector3.new(0, math.huge, 0)
            aa55.Velocity = Vector3.new(0, 900, 0)
            aa55.Parent = aa52

            Config.aa17 = false
            return aa51
        end
        
        local function aa25(aa26, aa27)
            if not aa26.Character then return end
            local aa28 = aa26.Character:FindFirstChild("HumanoidRootPart")
            if not aa28 or not aa27 then return end
            local aa29 = aa27.CFrame
            aa27.CFrame = aa28.CFrame * CFrame.new(0, 0, 2)
            for aa30 = 1, 15 do
                SetNetworkOwner:FireServer(aa28, aa28.CFrame)
                task.wait()
            end
            aa27.CFrame = aa29
        end
        
        local function startLagSpam()
            if Config.running then return end
            if not Config.PlayerList or #Config.PlayerList == 0 then return end
            if not CreateGrabLine then
                CreateGrabLine = Events.GrabEvents:WaitForChild("CreateGrabLine", 3)
                if not CreateGrabLine then return end
            end
            Config.running = true
            task.spawn(function()
                while Config.running do
                    local spawnLocation = service.Workspace:FindFirstChild("SpawnLocation")
                        or service.Workspace:FindFirstChild("Spawn")
                        or (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart"))

                    if spawnLocation then
                        CreateGrabLine:FireServer(spawnLocation, CFrame.new(math.random(-2010000000, 2000000001), 0, math.random(-2008100000, 2000200000)))
                    end
                    task.wait(0.001)
                end
            end)
        end
        
        local function stopLagSpam()
            if not Config.running then return end
            Config.running = false
        end
        
        if aa61 then
            if not Config.PlayerList or #Config.PlayerList == 0 then
                return
            end
            task.wait(0.5)
            task.defer(function()
                startLagSpam()
            end)
        else
            stopLagSpam()
        end
        if Config.aa6 then
            task.spawn(function()
                while Config.aa6 do
                    local targets = type(Config.PlayerList) == "table" and Config.PlayerList or {Config.PlayerList}
                    for _, targetName in ipairs(targets) do
                        local aa62 = service.Players:FindFirstChild(targetName)
                        local aa63 = localPlayer.Character
                        local aa64 = aa63 and aa63:FindFirstChild("HumanoidRootPart")
                        if aa62 and aa64 then
                            local aa65 = aa62.Character
                            local aa66 = aa65 and aa65:FindFirstChild("HumanoidRootPart")
                            if aa66 then
                                local aa67 = (aa64.Position - aa66.Position).Magnitude
                                if aa67 > Config.aa9 then
                                    aa25(aa62, aa64)
                                end
                                SetNetworkOwner:FireServer(aa66, aa66.CFrame)
                                if DestroyGrabLine then
                                    DestroyGrabLine:FireServer(aa66)
                                end
                                aa66.AssemblyLinearVelocity = Vector3.zero
                                aa66.AssemblyAngularVelocity = Vector3.zero
                                local aa68 = aa66:FindFirstChild("ControlBP")
                                if not aa68 then
                                    aa68 = Instance.new("BodyPosition")
                                    aa68.Name = "ControlBP"
                                    aa68.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                    aa68.P = 800000
                                    aa68.Parent = aa66
                                end
                                aa68.Position = aa64.Position + Vector3.new(0, 15, 0)
                            end
                        end
                    end
                    task.wait(0.001)
                end
                local targets = type(Config.PlayerList) == "table" and Config.PlayerList or {Config.PlayerList}
                for _, targetName in ipairs(targets) do
                    local aa69 = service.Players:FindFirstChild(targetName)
                    if aa69 and aa69.Character then
                        local aa70 = aa69.Character:FindFirstChild("HumanoidRootPart")
                        if aa70 and aa70:FindFirstChild("ControlBP") then
                            aa70.ControlBP:Destroy()
                        end
                    end
                end
            end)
        end
        if aa61 then
            local aa71 = workspace:FindFirstChild(localPlayer.Name.."SpawnedInToys")
            local aa72 = nil
            Config.aa73 = service.RunService.RenderStepped:Connect(function()
                if not Config.aa13 then return end
                if not Config.PlayerList or #Config.PlayerList == 0 then return end
                local targets = type(Config.PlayerList) == "table" and Config.PlayerList or {Config.PlayerList}
                local targetName = targets[1]
                if not targetName then return end
                local aa74 = service.Players:FindFirstChild(targetName)
                if not aa74 or not aa74.Character then return end
                local aa75 = aa74.Character:FindFirstChild("HumanoidRootPart")
                local aa76 = aa74.Character:FindFirstChild("Humanoid")
                if not aa75 or not aa76 then return end
                if aa72 and aa72:IsDescendantOf(workspace) then
                    local aa77 = aa72:FindFirstChild("SoundPart")
                    if aa77 then
                        if not aa37(aa77, "PartOwner") then
                            aa72:Destroy()
                            aa72 = nil
                        end
                    else
                        aa72:Destroy()
                        aa72 = nil
                    end
                end
                if not Config.aa17 and (not aa72 or not aa72:IsDescendantOf(workspace)) then
                    aa72 = aa71 and aa71:FindFirstChild("RagdollPalete") or aa50()
                end
                if aa72 and aa72:FindFirstChild("SoundPart") then
                    local aa78 = aa76:FindFirstChild("Ragdolled")
                    if aa78 and not aa78.Value then
                        aa72.SoundPart.Position = aa75.Position
                    end
                end
            end)
        else
            if Config.aa73 then
                Config.aa73:Disconnect()
                Config.aa73 = nil
            end
        end
    end,
})

MainTab:CreateSlider({
    Name = "Pallet Distance",
    Range = {5, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 25,
    Flag = "PalletDist",
    Callback = function(v) Config.aa9 = v end,
})

local UITab = Window:CreateTab("UI", 4483362458)
UITab:CreateButton({
    Name = "Close UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

JapanNotify("Japan HUB Loaded.")
