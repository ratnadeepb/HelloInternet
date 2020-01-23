--[[
-- Created on Tue Jan 21 2020:16:49:46
-- Created by Ratnadeep Bhattacharya
--]]
-- [[ function for checking error and printing line ]]
function check_print_line(line_r, err)
	if not err then
		print(line_r .. "\n")
	else
		print("Following error occurred: " .. err)
	end
end

-- [[ function to send two lines of data and done automatically ]]
function send_random_data(client)
	assert(client:send("Sending something random\n"))
	line_r, err = client:receive()
	check_print_line(line_r, err)
	assert(client:send("Cool\n"))
	line_r, err = client:receive()
	check_print_line(line_r, err)
	assert(client:send("done\n"))
	line_r, err = client:receive()
	check_print_line(line_r, err)
end

local socket = require("socket")
local host, port = "localhost", 8080

local ip = assert(socket.dns.toip(host))
local client = assert(socket.tcp())
assert(client:connect(ip, port))

-- 	line, err = client:receive("*a")

-- [[ run loop to continuously take input from client and send to server ]]
if client then
	print("Do you want me to test the protocol? ([y]/n)")
	ans = io.read()
	if not ans or ans == "" or ans == "y" or ans == "Y" or ans == "YES" or ans == "yes" or ans == "Yes" then
		send_random_data(client)
		client:close()
	else
		while 1 do
			print("Type in next line to send to server:\t")
			line = io.read() -- read input from stdin
			if not line or line == "" then
				print("Empty input\nTerminating.") -- send done and close connection
				break
			end
			assert(client:send(line .. "\n"))
			line_r, err = client:receive()
			check_print_line(line_r, err)
			print("Want to send another line? (y/[n]):\t")
			ans = io.read()
			if not ans or ans == "" or ans == "n" or ans == "N" or ans == "NO" or ans == "no" or ans == "No" then
				break -- send done and close connection
			end
		end
		client:send("done\n")
		line_r, err = client:receive()
		check_print_line(line_r, err)
		client:close()
	end
else
	print("Connection error")
	client:close()
end
