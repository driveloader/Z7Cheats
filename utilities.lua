local Utilities = {} do
    function Utilities.Locate(Path)
        local PathSplit = Path:split(".")
        local Service = table.remove(PathSplit, 1)
        local LastChild = nil
        
        if Service == "LocalPlayer" then
            Service = game:GetService("Players").LocalPlayer
        else
            Service = game:GetService(Service)
        end

        for i, v in pairs(PathSplit) do
            if i == 1 then
                LastChild = Service:WaitForChild(v, 5)
            else
                LastChild = LastChild:WaitForChild(v, 5)
            end
        end
    
        if not LastChild then
            warn("[Locate Instance]: Failed to locate: [" .. Path .. "].")
        end
        
        return LastChild
    end

    function Utilities.Create(Object, Properties)
        local Object = Instance.new(Object)

        for i, v in pairs(Properties) do
            Object[i] = v
        end

        return Object
    end

    function Utilities.CreateDrawing(Object, Properties)
        local Object = Drawing.new(Object)

        for i, v in pairs(Properties) do
            Object[i] = v
        end

        return Object
    end
end

--// Services
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

for i, v in pairs(Utilities) do
    getgenv()[i] = v
end

for i, v in pairs(ExploitFunctions) do
    getgenv()[i] = v
end
