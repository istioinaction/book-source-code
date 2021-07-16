package main

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/beego/v2/server/web/context"
	"github.com/istioinaction/book-source-code/services/webapp/controllers"
)

func main() {
	web.Router("/", &controllers.IndexController{})
	web.Router("/api/catalog/items", &controllers.CatalogController{}, "post:CreateCatalogItem")
	web.Router("/api/catalog", &controllers.CatalogController{}, "*:GetCatalog")
	web.Router("/api/catalog/items/:id:int", &controllers.CatalogController{}, "*:GetCatalogItem")
	web.Router("/api/users", &controllers.ForumController{}, "*:GetUsersList")
	web.Get("/api/healthz", func(ctx *context.Context){
		ctx.Output.Body([]byte("Healthy!"))
	})
	web.BConfig.Log.AccessLogs = true
	web.Run()
}