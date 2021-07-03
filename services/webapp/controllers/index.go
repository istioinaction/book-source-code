package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/istioinaction/book-source-code/services/webapp/clients"
	"math"
)

type IndexController struct {
	web.Controller
}

func (this *IndexController) Get() {
	headers := ExtractHeaders(this.Ctx.Request)
	catalog, err := clients.GetCatalog(headers)
	if err != nil {
		this.Data["CatalogServiceError"] = "The catalog service is currently not available."
	} else {
		limitAtFour := int(math.Min(float64(len(*catalog)), 4))
		this.Data["CatalogItemList"] = (*catalog)[:limitAtFour]
	}

	userlist, err := clients.GetUsers(headers)
	if err != nil {
		this.Data["ForumServiceError"] = "The forum service is currently not available."
	} else {
		limitAtFour := int(math.Min(float64(len(*userlist)), 4))
		this.Data["UserList"] = (*userlist)[:limitAtFour]
	}

	this.TplName = "index.html"

	this.Render()
}
