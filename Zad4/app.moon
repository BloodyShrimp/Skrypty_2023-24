lapis = require "lapis"
schema = require "lapis.db.schema"
lapis_app = require "lapis.application"
import Model from require "lapis.db.model"
import create_table, drop_table, types from schema
import respond_to, json_params from lapis_app

class Products extends Model
class Categories extends Model

class App extends lapis.Application
  "/": =>
    "ok!"

  "/categories/create": =>
    create_table "categories", {
      { "id", types.id },
      { "name", types.varchar }
    }
  "/categories/drop": =>
    drop_table "categories"
  
  "/categories": respond_to {
    GET: =>
      categories = Categories\select()
      { json: categories }
    POST: json_params =>
      body = self.params
      Categories\create {
        name: body.name
      }
  }

  "/categories/:id": respond_to {
    GET: =>
      category = Categories\find(self.params.id)
      { json: category }
    PUT: json_params =>
      body = self.params
      category = Categories\find(self.params.id)
      ret = category\update {
        name: body.name
      }
    DELETE: =>
      category = Categories\find(self.params.id)
      ret = category\delete!
  }

  "/products/create": =>
    create_table "products", {
      { "id", types.id },
      { "name", types.varchar },
      { "price", types.double }
      { "category_id", types.integer }

      "FOREIGN KEY (category_id) REFERENCES categories(id)"
    }
  "/products/drop": =>
    drop_table "products"

  "/products": respond_to {
    GET: =>
      products = Products\select()
      { json: products }
    POST: json_params =>
      body = self.params
      Products\create {
        name: body.name
        price: body.price
        category_id: body.category_id
      }
  }

  "/products/:id": respond_to {
    GET: =>
      product = Products\find(self.params.id)
      { json: product }
    PUT: json_params =>
      body = self.params
      product = Products\find(self.params.id)
      ret = product\update {
        name: body.name
        price: body.price
        category_id: body.category_id
      }
    DELETE: =>
      product = Products\find(self.params.id)
      ret = product\delete!
  }

  "/products/category/:id": respond_to {
    GET: =>
      products = Products\select "where category_id = ?", self.params.id
      { json: products }
  }