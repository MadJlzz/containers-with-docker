package main

import (
	"fmt"
	"net/http"
)

func main() {
	cfg, err := NewConfiguration()
	if err != nil {
		panic(err)
	}
	mux := http.NewServeMux()

	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, "ok")
	})

	fmt.Printf("server started and listening on %s\n", cfg.Server.Hostname)
	http.ListenAndServe(cfg.Server.Hostname, mux)
}
