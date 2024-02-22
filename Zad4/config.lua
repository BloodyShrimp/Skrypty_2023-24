local config
config = require("lapis.config").config
return config("development", function()
  server("nginx")
  code_cache("off")
  num_workers("1")
  return mysql(function()
    host("127.0.0.1")
    user("root")
    password("password")
    return database("shop_db")
  end)
end)
