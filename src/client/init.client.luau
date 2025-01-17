local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

for _, module: ModuleScript in script.Controllers:GetChildren() do
    require(module)
end

for _, module: ModuleScript in ReplicatedStorage.Shared.Classes:GetChildren() do
    local class = require(module)
    if class.TAG and class.IS_CLIENT then
        for _, instance: Instance in CollectionService:GetTagged(class.TAG) do
            class.new(instance)
        end
        CollectionService:GetInstanceAddedSignal(class.TAG):Connect(function(instance: Instance)
            class.new(instance)
        end)
    end
end