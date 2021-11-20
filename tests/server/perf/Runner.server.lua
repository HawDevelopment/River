-- Taken from: https://github.com/Elttob/Fusion/blob/main/test-runner/Run.client.lua

local Scripts = script.Parent.scripts:GetChildren()

local RUN_PERF_TESTS = true

if RUN_PERF_TESTS then
    
print("Running benchmarks...")
    task.wait(1)
	local result = {}

	for _, inst in pairs(Scripts) do
		if inst:IsA("ModuleScript") then
            task.wait(1)
			local module = require(inst)
			local res = {}

			for index, perf in ipairs(module) do
				local state
				if perf.Pre ~= nil then
					state = perf.Pre()
				end
                local run = perf.Run
				local start = os.clock()
				for _ = 1, perf.Calls do
					run(state)
				end
				local fin = os.clock()

				if perf.Stop ~= nil then
					perf.Stop(state)
				end

				local time = (fin - start) * 1000000 / perf.Calls
				res[index] = {name = perf.Name, time = time}
			end

			table.insert(result, {name = inst.Name, result = res})
		end
	end

	local str = "Benchmark results:"

	for _, res in ipairs(result) do
		str ..= "\n[+] " .. res.name

		for _, perf in ipairs(res.result) do
			str ..= "\n   [+] "
			str ..= perf.name .. " "
			str ..= ("."):rep(20 - #perf.name + 4) .. " "
			str ..= ("%.2f μs"):format(perf.time)
		end
	end

	print(str)
end