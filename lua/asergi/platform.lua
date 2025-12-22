local M = {}
M.is_nixos = false

do
  local f = io.open("/etc/os-release", "r")
  if f then
    local content = f:read("*a")
    f:close()
    if content:match("ID=nixos") then
      M.is_nixos = true
    end
  end
end

return M
