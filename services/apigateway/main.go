package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/julienschmidt/httprouter"
)

func GetCatalog(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var port = os.Getenv("CATALOG_SERVICE_PORT")
	catalogUrl := "http://catalog" + ":" + port + "/items"

	client := &http.Client{}

	req, err := http.NewRequest("GET", catalogUrl, nil)
	check(err)

	req.Header = extractHeaders(r)

	response, err := client.Do(req)

	if err != nil {
		fmt.Printf("The HTTP request failed calling Catalog service with error %s\n", err)
	}

	if response.StatusCode != 200 {
		http.Error(w, "error calling Catalog service", http.StatusInternalServerError)
	} else {
		data, _ := ioutil.ReadAll(response.Body)
		fmt.Fprint(w, string(data))
	}
}

func CreateCatalog(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var port = os.Getenv("CATALOG_SERVICE_PORT")
	catalogUrl := "http://catalog" + ":" + port + "/items"

	client := &http.Client{}

	body, err := ioutil.ReadAll(r.Body)
	req, err := http.NewRequest("POST", catalogUrl, bytes.NewBuffer(body))
	check(err)

	req.Header = extractHeaders(r)
	req.Header.Add("Content-Type", "application/json")

	response, err := client.Do(req)

	if err != nil {
		log.Printf("The HTTP request failed calling Catalog service with error %s\n", err)
	}

	if response.StatusCode != 201 {
		http.Error(w, "error calling Catalog service", http.StatusInternalServerError)
	} else {
		data, _ := ioutil.ReadAll(response.Body)
		fmt.Fprint(w, string(data))
	}
}

func extractHeaders(r *http.Request) http.Header {
	customHeaders := http.Header{}
	log.Println(r.Header)
	for name, value := range r.Header {
		if strings.HasPrefix(strings.ToLower(name), "x-") ||
			strings.HasPrefix(name, "Authorization") {
			customHeaders.Add(name, value[0])
		}
	}
	return customHeaders
}

func check(err error) {
	if err != nil {
		panic(err)
	}
}

func Hello(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	fmt.Fprintf(w, "hello, %s!\n", ps.ByName("name"))
}

func main() {
	router := httprouter.New()
	router.GET("/api/catalog", GetCatalog)
	router.POST("/api/catalog", CreateCatalog)
	router.GET("/hello/:name", Hello)

	log.Fatal(http.ListenAndServe(":8080", router))
}
