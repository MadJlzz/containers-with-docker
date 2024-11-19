package main

import (
	"fmt"
	"io"
	"net/http"
)

const PokemonApi = "https://pokeapi.co/api/v2"

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

	mux.HandleFunc("/api/v1/pokemon/{name}", func(w http.ResponseWriter, r *http.Request) {
		name := r.PathValue("name")
		resp, err := http.Get(fmt.Sprintf("%s/pokemon/%s", PokemonApi, name))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			fmt.Fprintln(w, "Something went wrong")
		}
		defer resp.Body.Close()

		w.Header().Add("Content-Type", "application/json")
		io.Copy(w, resp.Body)
	})

	fmt.Printf("server started and listening on %s\n", cfg.Server.Hostname)
	http.ListenAndServe(cfg.Server.Hostname, mux)
}
