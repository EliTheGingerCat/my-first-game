--> Build the test place.

local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")
local stdio = require("@lune/stdio")

local project = serde.decode("json", fs.readFile("./default.project.json"))

project.tree.ReplicatedStorage.tests = {
	["$path"] = "./tests"
}

fs.writeFile("./test.project.json", serde.encode("json", project))

local function fix_output(s: string): string
	local mostly_indented = string.gsub(
		s,
		"\n",
		"\n\t"
	)
	return "\t" .. mostly_indented .. "\n"
end

local function exec(program: string, params: {string}?, options: process.ExecOptions?): ()
	local params_string: string
	if params then
		params_string = " " .. table.concat(params, " ")
	else
		params_string = ""
	end

	print(`> {program}{params_string}`)
	local results = process.exec(program, params, options)
	
	stdio.write(fix_output(results.stdout))
	stdio.ewrite(fix_output(results.stderr))

	if not results.ok then
		error("Aborting.")
	end
end

local function exec_friendly(command: string, options: process.ExecOptions?): ()
	local params = string.split(command, " ")
	local program = table.remove(params, 1) :: string -- Up to the user if they want to pass in nothing.
	exec(program, params, options)
end

exec_friendly("rojo build test.project.json -o build.rbxl")