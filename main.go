package main

import (
	"fmt"
	"net/http"

	"github.com/caarlos0/env/v6"
	"github.com/xyproto/simpleredis"
)

var (
	pool   *simpleredis.ConnectionPool
	config = struct {
		RedisAddr string `env:"REDIS_ADDR" envDefault:"127.0.0.1:6379"`
		Addr      string `env:"ADDR" envDefault:"0.0.0.0:8080"`
	}{}
)

func main() {
	err := env.Parse(&config)
	if err != nil {
		panic(err)
	}

	pool = simpleredis.NewConnectionPoolHost(config.RedisAddr)
	defer pool.Close()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		info, err := pool.Get(0).Do("INFO")
		if err != nil {
			panic(err)
		}

		b, ok := info.([]byte)
		if !ok {
			panic(fmt.Errorf("can't cast info reply to byte"))
		}

		w.Write(b)
	})

	fmt.Printf("Starting up %+v\n", config)

	err = http.ListenAndServe(config.Addr, nil)
	if err != nil {
		panic(err)
	}
}
