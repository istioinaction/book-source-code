package clients

import (
	"encoding/json"
	"errors"
	"github.com/beego/beego/v2/client/httplib"
	"net/http"
	"os"
	"strconv"
)


type CatalogItem struct {
	ID         int    `json:"id"`
	Color      string `json:"color"`
	Department string `json:"department"`
	Name       string `json:"name"`
	Price      string `json:"price"`
	ImageURL   string `json:"imageUrl,omitempty"`
}

func GetCatalog(headers http.Header) (*[]CatalogItem, error) {
	var port = os.Getenv("CATALOG_SERVICE_PORT")
	var url = os.Getenv("CATALOG_SERVICE_HOST")
	catalogUrl := "http://" + url + ":" + port
	req := httplib.Get(catalogUrl + "/items")

	SetHeaders(headers, req)

	res, err := req.String()
	if err != nil {
		return nil, err
	}

	catalogItems := &[]CatalogItem{}
	err = json.Unmarshal([]byte(res), catalogItems)
	if err != nil {
		return nil, err
	}
	return catalogItems, nil
}

func CreateCatalogItem(catalogItem CatalogItem, headers http.Header) error {
	var port = os.Getenv("CATALOG_SERVICE_PORT")
	var url = os.Getenv("CATALOG_SERVICE_HOST")
	catalogUrl := "http://" + url + ":" + port
	req := httplib.Post(catalogUrl + "/items")

	req, err := req.JSONBody(catalogItem)
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

func GetCatalogItem(id int, headers http.Header) (*CatalogItem, error) {
	var port = os.Getenv("CATALOG_SERVICE_PORT")
	var url = os.Getenv("CATALOG_SERVICE_HOST")
	catalogUrl := "http://" + url + ":" + port
	req := httplib.Get(catalogUrl + "/items/" + strconv.Itoa(id))

	SetHeaders(headers, req)

	res, err := req.String()
	if err != nil {
		return nil, err
	}

	catalogItem := &CatalogItem{}
	err = json.Unmarshal([]byte(res), catalogItem)
	if err != nil {
		return nil, err
	}
	return catalogItem, nil
}