package clients

import (
	"encoding/json"
	"errors"
	"github.com/beego/beego/v2/client/httplib"
	"net/http"
	"os"
	"strconv"
)


type Catalog struct {
	ID         int    `json:"id"`
	Color      string `json:"color"`
	Department string `json:"department"`
	Name       string `json:"name"`
	Price      string `json:"price"`
}

func GetCatalogList(headers http.Header) (*[]Catalog, error) {
	var port = os.Getenv("CATALOG_SERVICE_PORT")
	var url = os.Getenv("CATALOG_SERVICE_NAME")
	catalogUrl := "http://" + url + ":" + port
	req := httplib.Get(catalogUrl + "/items")

	SetHeaders(headers, req)

	res, err := req.String()
	if err != nil {
		return nil, err
	}

	catalogList := &[]Catalog{}
	err = json.Unmarshal([]byte(res), catalogList)
	if err != nil {
		return nil, err
	}
	return catalogList, nil
}

// https://stackoverflow.com/questions/47739398/how-to-pass-json-response-in-go-beego-framework
func CreateCatalog(catalog Catalog, headers http.Header) error {
	var port = os.Getenv("CATALOG_SERVICE_PORT")
	var url = os.Getenv("CATALOG_SERVICE_NAME")
	catalogUrl := "http://" + url + ":" + port
	req := httplib.Post(catalogUrl + "/items")
	//catalogM, err := json.Marshal(catalog)
	//if err != nil {
	//	return err
	//}

	req, err := req.JSONBody(catalog)
	if err != nil {
		return err
	}
	SetHeaders(headers, req)

	res, err := req.DoRequest()
	if err != nil {
		return err
	}

	if res.StatusCode != 201 {
		return errors.New("error calling Catalog service")
	}

	return nil
}

func GetCatalog(id int, headers http.Header) (*Catalog, error) {
	var port = os.Getenv("CATALOG_SERVICE_PORT")
	var url = os.Getenv("CATALOG_SERVICE_NAME")
	catalogUrl := "http://" + url + ":" + port
	req := httplib.Get(catalogUrl + "/items/" + strconv.Itoa(id))

	SetHeaders(headers, req)

	res, err := req.String()
	if err != nil {
		return nil, err
	}

	catalog := &Catalog{}
	err = json.Unmarshal([]byte(res), catalog)
	if err != nil {
		return nil, err
	}
	return catalog, nil
}