package main

import (
	"fmt"
	"github.com/julienschmidt/httprouter"
	"net/http"
	"io/ioutil"
	"log"
	"strings"
)

func Users(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	usersUrl := "http://jsonplaceholder.typicode.com/users"

	client := &http.Client{}

	req, err := http.NewRequest("GET", usersUrl, nil)

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
		http.Error(w, "error calling Users service", http.StatusInternalServerError)
	}else {
		data, _ := ioutil.ReadAll(response.Body)
		fmt.Fprint(w, string(data))
	}

}


func main() {
	router := httprouter.New()
	router.GET("/api/users", Users)

	log.Fatal(http.ListenAndServe(":8080", router))
}