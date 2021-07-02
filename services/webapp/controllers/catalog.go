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

func (this *CatalogController) GetCatalogList() {
	headers := ExtractHeaders(this.Ctx.Request)
	list, err := clients.GetCatalogList(headers)
	if err != nil {
		this.CustomAbort(500, "error calling Catalog service")
	}
	this.Data["json"] = list
	this.ServeJSON()
}

func  (this *CatalogController) CreateCatalog() {
	headers := ExtractHeaders(this.Ctx.Request)
	var catalog clients.Catalog
	err := json.Unmarshal(this.Ctx.Input.RequestBody, &catalog)
	if err != nil {
		this.CustomAbort(500, "error calling Catalog service")
	}
	err = clients.CreateCatalog(catalog, headers)
	if err != nil {
		this.CustomAbort(500, "error calling Catalog service")
	}
	this.ServeJSON()
}

func (this *CatalogController) GetCatalog() {
	headers := ExtractHeaders(this.Ctx.Request)
	id, _ := strconv.Atoi(this.Ctx.Input.Param(":id"))

	catalog, err := clients.GetCatalog(id, headers)
	if err != nil {
		this.CustomAbort(500, "error calling Catalog service")
	}
	this.Data["json"] = catalog
	this.ServeJSON()
}