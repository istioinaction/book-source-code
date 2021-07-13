package clients

import (
	"github.com/beego/beego/v2/client/httplib"
	"net/http"
)

func SetHeaders(headers http.Header, req *httplib.BeegoHTTPRequest) {
	for key, value := range headers {
		req.Header(key, value[0])
	}
}
