package main

import (
	"fmt"
	"github.com/julienschmidt/httprouter"
	"net/http"
	"io/ioutil"
	"log"
	"strings"
	"os"
)

func Users(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	usersUrl := "http://jsonplaceholder.typicode.com/users"
	
	var localUsers = os.Getenv("LOCAL_USERS")
	if localUsers=="true" {
		var json = `[{"id":10,"name":"ClementinaDuBuque","username":"Moriah.Stanton","email":"Rey.Padberg@karina.biz","address":{"street":"KattieTurnpike","suite":"Suite198","city":"Lebsackbury","zipcode":"31428-2261","geo":{"lat":"-38.2386","lng":"57.2232"}},"phone":"024-648-3804","website":"ambrose.net","company":{"name":"HoegerLLC","catchPhrase":"Centralizedempoweringtask-force","bs":"targetend-to-endmodels"}}]`
		fmt.Fprint(w, string(json))
		return
	}
	 
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
	fmt.Printf("Server is listening in port:8080")
	router := httprouter.New()
	router.GET("/api/users", Users)
	router.GET("/api/healthz", func (_ http.ResponseWriter, _ *http.Request, _ httprouter.Params) {})

	log.Fatal(http.ListenAndServe(":8080", router))
}