require('base')
require('keybinds')

function gitBranchName()
	local source_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
	if string.find(source_branch, "-(%d+)") then
		local number = tonumber(string.match(source_branch, "-(%d+)"))
		local result = "-" .. number
		return result
	else
		print("String does not match the pattern " .. source_branch)
	end

end

function localBuild()
	local path = vim.fn.getcwd()
	local build_dir = string.match(path, "(.*/)")

	local num_branch = gitBranchName()
	mkd_build_dir = build_dir .. "local-builds/local-build" .. num_branch

	executable_script = {'/bin/bash', "build-depends.bash", mkd_build_dir}
	vim.fn.jobstart(executable_script, {
		on_exit = function(job_id, exit_code, _)
			print('Script exit code: ', exit_code)
		end
	})

	--os.execute("bash ./build-depends.bash " .. mkd_build_dir)
end

vim.api.nvim_create_user_command('LocalBuild', localBuild, {})

local isTerminalOpen = false
function toggleTerminal()
	if isTerminalOpen then
		vim.cmd('q')
		isTerminalOpen = false
	else
		vim.cmd('belowright split | resize 10 | terminal')
		isTerminalOpen = true
	end
end


vim.api.nvim_set_keymap('n', '<Leader>t', ':lua toggleTerminal()<CR>', {noremap = true, silent = true})

