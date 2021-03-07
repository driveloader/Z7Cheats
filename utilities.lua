local Utilities = {} do
    function Utilities:Create(Object, Properties)
        local Object = Instance.new(Object)

        for Property, Value in pairs(Properties) do
            Object[Property] = Value
        end

        return Object
    end

    function Utilities:CreateDrawing(Object, Properties)
        local Object = Drawing.new(Object)

        for Property, Value in pairs(Properties) do
            Object[Property] = Value
        end

        return Object
    end
end

--// Services
local Services = {
    Players = game:GetService("Players"),
    LocalPlayer = game:GetService("LocalPlayer"),
    ReplicatedFirst = game:GetService("ReplicatedFirst"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    StarterGui = game:GetService("StarterGui"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    Debris = game:GetService("Debris")
    
}

local ExploitFunctions = {
    HttpRequest = syn.request,
    GetGarbageCollection = getgc,
    MoveMouse = mousemoverel,
    ProtectGui = syn.protect_gui,
    IsLuaClosure = islclosure,
    IsExploitFunction = is_synapse_function,
    NewCClosure = newcclosure,
    HookFunction = hookfunction,
    WindowActive = iswindowactive,
    GetConnections = getconnections,
    GetUpValues = (getupvalues or debug.getupvalues),
    GetUpValue = (getupvalue or debug.getupvalue),
    SetUpValue = (setupvalue or debug.setupvalue),
    GetConstants = (getconstants or debug.getconstants),
    GetConstant = (getconstant or debug.getconstant),
    SetConstant = (setconstant or debug.setconstant),
    GetProtos = (getprotos or debug.getprotos),
    GetProto = (getproto or debug.getproto),
    SetProto = (setproto or debug.setproto),
    GetInfo = (getinfo or debug.getinfo),
    GetRegistry = (getreg or debug.getregistry),
    SetReadOnly = setreadonly,
    IsReadOnly = isreadonly,
    CheckCaller = checkcaller,
    GetNamecallMethod = getnamecallmethod,
    GetRawMetatable = getrawmetatable,
    SetRawMetatable = setrawmetatable,
    GetGlobalEnvironment = getgenv,
    GetModuleEnvironment = getmenv,
    GetScriptEnvironment = getsenv,
    GetRobloxEnvironment = getrenv
}
for Index, Service in pairs(Services) do
    getgenv()[Index] = Service
end

for Index, Function in pairs(Utilities) do
    getgenv()[Index] = Function
end

for Index, ExploitFunction in pairs(ExploitFunctions) do
    getgenv()[Index] = ExploitFunction
end
