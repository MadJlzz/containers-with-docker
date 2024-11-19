package main

import "fmt"

func main() {
	cfg, err := NewConfiguration()
	if err != nil {
		panic(err)
	}
	fmt.Println(cfg.Server)
}
