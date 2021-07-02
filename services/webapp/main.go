package main

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/istioinaction/book-source-code/services/webapp/controllers"
)

func main() {
	web.Router("/", &controllers.IndexController{})
	web.Router("/api/catalogs", &controllers.CatalogController{}, "post:CreateCatalog")
	web.Router("/api/catalogs", &controllers.CatalogController{}, "*:GetCatalogList")
	web.Router("/api/catalogs/:id:int", &controllers.CatalogController{}, "*:GetCatalog")
	web.Router("/api/users", &controllers.ForumController{}, "*:GetUsersList")
	web.BConfig.Log.AccessLogs = true
	web.Run()
}