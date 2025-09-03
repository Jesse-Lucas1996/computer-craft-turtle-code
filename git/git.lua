local url, output_filename = ...
if not url or not output_filename then
  print("Usage: your_script_name <URL> <output_filename>")
  return
end
shell.run("wget", url, output_filename)
if not fs.exists(output_filename) then
  error("Failed to download the file from: " .. url)
end
local fileHandle = fs.open(output_filename, "r")
local code = fileHandle.readAll()
fileHandle.close()
print("Successfully downloaded and read the script.")
print("The file is now saved as:", output_filename)
print("The script's length is:", #code)