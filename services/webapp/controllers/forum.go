package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/istioinaction/book-source-code/services/webapp/clients"
)

type ForumController struct {
	web.Controller
}

func (this *ForumController) GetUsersList() {
	headers := ExtractHeaders(this.Ctx.Request)
	list, err := clients.GetUsers(headers)
	if err != nil {
		this.CustomAbort(500, "error calling Forum service")
	}
	this.Data["json"] = list
	this.ServeJSON()
}
