local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

for _, module: ModuleScript in script.Services:GetChildren() do
    require(module)
end

for _, module: ModuleScript in ReplicatedStorage.Shared.Classes:GetChildren() do
    local class = require(module)
    if class.TAG and not class.IS_CLIENT then
        for _, instance: Instance in CollectionService:GetTagged(class.TAG) do
            class.new(instance)
        end
        CollectionService:GetInstanceAddedSignal(class.TAG):Connect(function(instance: Instance)
            class.new(instance)
        end)
    end
end