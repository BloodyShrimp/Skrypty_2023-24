local lapis = require("lapis")
local schema = require("lapis.db.schema")
local lapis_app = require("lapis.application")
local Model
Model = require("lapis.db.model").Model
local create_table, drop_table, types
create_table, drop_table, types = schema.create_table, schema.drop_table, schema.types
local respond_to, json_params
respond_to, json_params = lapis_app.respond_to, lapis_app.json_params
local Products
do
  local _class_0
  local _parent_0 = Model
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Products",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Products = _class_0
end
local Categories
do
  local _class_0
  local _parent_0 = Model
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Categories",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Categories = _class_0
end
local App
do
  local _class_0
  local _parent_0 = lapis.Application
  local _base_0 = {
    ["/"] = function(self)
      return "ok!"
    end,
    ["/categories/create"] = function(self)
      return create_table("categories", {
        {
          "id",
          types.id
        },
        {
          "name",
          types.varchar
        }
      })
    end,
    ["/categories/drop"] = function(self)
      return drop_table("categories")
    end,
    ["/categories"] = respond_to({
      GET = function(self)
        local categories = Categories:select()
        return {
          json = categories
        }
      end,
      POST = json_params(function(self)
        local body = self.params
        return Categories:create({
          name = body.name
        })
      end)
    }),
    ["/categories/:id"] = respond_to({
      GET = function(self)
        local category = Categories:find(self.params.id)
        return {
          json = category
        }
      end,
      PUT = json_params(function(self)
        local body = self.params
        local category = Categories:find(self.params.id)
        local ret = category:update({
          name = body.name
        })
      end),
      DELETE = function(self)
        local category = Categories:find(self.params.id)
        local ret = category:delete()
      end
    }),
    ["/products/create"] = function(self)
      return create_table("products", {
        {
          "id",
          types.id
        },
        {
          "name",
          types.varchar
        },
        {
          "price",
          types.double
        },
        {
          "category_id",
          types.integer
        },
        "FOREIGN KEY (category_id) REFERENCES categories(id)"
      })
    end,
    ["/products/drop"] = function(self)
      return drop_table("products")
    end,
    ["/products"] = respond_to({
      GET = function(self)
        local products = Products:select()
        return {
          json = products
        }
      end,
      POST = json_params(function(self)
        local body = self.params
        return Products:create({
          name = body.name,
          price = body.price,
          category_id = body.category_id
        })
      end)
    }),
    ["/products/:id"] = respond_to({
      GET = function(self)
        local product = Products:find(self.params.id)
        return {
          json = product
        }
      end,
      PUT = json_params(function(self)
        local body = self.params
        local product = Products:find(self.params.id)
        local ret = product:update({
          name = body.name,
          price = body.price,
          category_id = body.category_id
        })
      end),
      DELETE = function(self)
        local product = Products:find(self.params.id)
        local ret = product:delete()
      end
    }),
    ["/products/category/:id"] = respond_to({
      GET = function(self)
        local products = Products:select("where category_id = ?", self.params.id)
        return {
          json = products
        }
      end
    })
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "App",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  App = _class_0
  return _class_0
end
