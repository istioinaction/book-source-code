package controllers

import (
	"net/http"
	"strings"
)

func ExtractHeaders(r *http.Request) http.Header {
	customHeaders := http.Header{}
	for name, value := range r.Header {
		if strings.HasPrefix(strings.ToLower(name), "x-") ||
			strings.HasPrefix(name, "Authorization") {
			customHeaders.Add(name, value[0])
		}
	}
	return customHeaders
}