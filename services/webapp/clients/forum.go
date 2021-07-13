package clients

import (
	"encoding/json"
	"github.com/beego/beego/v2/client/httplib"
	"net/http"
	"os"
)

type User struct {
	ID       int    `json:"id"`
	Name     string `json:"name"`
	Username string `json:"username"`
	Email    string `json:"email"`
	Address  Address `json:"address"`
	Phone   string `json:"phone"`
	Website string `json:"website"`
	Company CompanyDetails `json:"company"`
}

type Address struct {
	Street  string `json:"street"`
	Suite   string `json:"suite"`
	City    string `json:"city"`
	Zipcode string `json:"zipcode"`
}

type CompanyDetails struct {
	Name        string `json:"name"`
	CatchPhrase string `json:"catchPhrase"`
	Bs          string `json:"bs"`
}

func GetUsers(headers http.Header) (*[]User, error) {
	var host = os.Getenv("FORUM_SERVICE_HOST")
	var port = os.Getenv("FORUM_SERVICE_PORT")
	url := "http://" + host + ":" + port
	req := httplib.Get(url + "/api/users")

	SetHeaders(headers, req)

	res, err := req.String()
	if err != nil {
		return nil, err
	}

	userList := &[]User{}
	err = json.Unmarshal([]byte(res), userList)
	if err != nil {
		return nil, err
	}
	return userList, nil
}
