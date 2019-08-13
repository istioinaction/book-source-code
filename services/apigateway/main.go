package main

import (
	"fmt"
	"github.com/julienschmidt/httprouter"
	"net/http"
	"io/ioutil"
	"log"
	"os"
	"strings"
)

func Catalog(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var host string = os.Getenv("CATALOG_SERVICE_HOST")
	var port string = os.Getenv("CATALOG_SERVICE_PORT")
	catalogUrl := "http://"+host+":"+port+"/items"

	client := &http.Client{}

	req, err := http.NewRequest("GET", catalogUrl, nil)

	for name, value := range r.Header {
		if strings.HasPrefix(strings.ToLower(name), "x-") {
			req.Header.Add(name, value[0])
			fmt.Printf("Adding header to request: %s=%s", name, value[0])
		}
	}


	response, err := client.Do(req)

	if err != nil {
		fmt.Printf("The HTTP request failed calling Catalog service with error %s\n", err)
	}

	if(response.StatusCode != 200) {
		http.Error(w, "error calling Catalog service", http.StatusInternalServerError)
	}else {
		data, _ := ioutil.ReadAll(response.Body)
		fmt.Fprint(w, string(data))
	}

}

func Hello(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	fmt.Fprintf(w, "hello, %s!\n", ps.ByName("name"))
}

func main() {
	router := httprouter.New()
	router.GET("/api/catalog", Catalog)
	router.GET("/hello/:name", Hello)

	log.Fatal(http.ListenAndServe(":8080", router))
}