package controllers

import (
	"encoding/json"
	"github.com/beego/beego/v2/server/web"
	"github.com/istioinaction/book-source-code/services/webapp/clients"
	"strconv"
)

type CatalogController struct {
	web.Controller
}

func (this *CatalogController) GetCatalog() {
	headers := ExtractHeaders(this.Ctx.Request)
	catalog, err := clients.GetCatalog(headers)
	if err != nil {
		this.CustomAbort(500, "error calling Catalog service")
	}
	this.Data["json"] = catalog
	this.ServeJSON()
}

func  (this *CatalogController) CreateCatalogItem() {
	headers := ExtractHeaders(this.Ctx.Request)
	var catalogItem clients.CatalogItem
	err := json.Unmarshal(this.Ctx.Input.RequestBody, &catalogItem)
	if err != nil {
		this.CustomAbort(400, "Invalid CatalogItem")
	}
	err = clients.CreateCatalogItem(catalogItem, headers)
	if err != nil {
		this.CustomAbort(500, "error calling Catalog service")
	}
	this.ServeJSON()
}

func (this *CatalogController) GetCatalogItem() {
	headers := ExtractHeaders(this.Ctx.Request)
	id, _ := strconv.Atoi(this.Ctx.Input.Param(":id"))

	catalogItem, err := clients.GetCatalogItem(id, headers)
	if err != nil {
		this.CustomAbort(500, "error calling Catalog service")
	}
	this.Data["json"] = catalogItem
	this.ServeJSON()
}